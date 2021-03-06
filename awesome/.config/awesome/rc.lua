require("autorun")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")
local os = require("os")

local utils = require("utils")

local hostname = utils.get_hostname()
local config_dir = gears.filesystem.get_configuration_dir()

local modkey = "Mod4"
local terminal = os.getenv("TERMINAL") or "st"
local theme = "gruvbox"

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_base_dir = config_dir .. "themes/" .. theme

local theme_files = {
  theme_base_dir .. "-" .. hostname .. "/theme.lua",
  theme_base_dir .. "/theme.lua",
}

for _, theme_file in pairs(theme_files) do
  if utils.file_exists(theme_file) then
    beautiful.init(theme_file)

    break
  end
end
-- }}}

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
  awful.layout.suit.max,
}

-- Reset key bindings
root.keys({}) -- luacheck: globals root

-- {{{ Librarian
local librarian = require("librarian")
librarian.init({
    verbose = true,
    libraries_dir = config_dir .. "/libraries/",
  })

librarian.require("scisssssssors/fuzzy", {
  do_after = function(fuzzy)
    local fuzzy_processors = require("fuzzy.processor")
    local fuzzy_sources = require("fuzzy.source")
    local fuzzy_handlers = require("fuzzy.handler")
    local cache = require("fuzzy.cache.memory")
    local lutris = require("plugins.fuzzy.lutris")

    fuzzy.init({
      box_options = {
        lines = 10,
      },
    })

    local processors = {
      {
        callback = fuzzy_processors.fuzzy,
        options = { attr = function (item) return item.title end, },
      },
      {
        callback = function (list, input, options)
          if #list < 100 then
            return list
          end

          return fuzzy_processors.threshold(list, input, options)
        end,
        options = { attr = function (item) return item.data.fuzzy_score end, threshold = 0.9, },
      },
      {
        callback = fuzzy_processors.sort,
        options = { attr = function (item) return item.data.fuzzy_score end, order = "DESC", },
      },
    }

    root.keys(gears.table.join( -- luacheck: globals root
      root.keys(), -- luacheck: globals root
      awful.key({ modkey }, "d", function () fuzzy.show(
        {
          cache = { storage = cache, key = "path" },
          source = fuzzy_sources.path,
          handler = fuzzy_handlers.spawn,
          processors = processors,
        }) end,
        {description = "toggle fuzzy window", group = "app"}),
      awful.key({ modkey }, "s", function () fuzzy.show(
        {
          cache = { storage = cache, key = "lutris" },
          source = lutris.source,
          handler = lutris.handler,
          processors = processors
        }) end,
        {description = "toggle fuzzy window", group = "app"}),
      awful.key({ modkey }, "u", function () fuzzy.show(
        {
          source = fuzzy_sources.client_options,
          handler = fuzzy_handlers.callback,
          processors = processors,
        }) end,
        {description = "toggle fuzzy window", group = "app"}),
      awful.key({ modkey }, "c", function () fuzzy.show(
        {
          source = fuzzy_sources.client,
          handler = fuzzy_handlers.jump_to,
          processors = processors,
          box_options = {
            on_change = function (item)
              fuzzy_handlers.jump_to(item)
            end,
          },
        }) end,
        {description = "toggle fuzzy window", group = "app"})
      )
    )
  end
})
-- }}}

-- {{{ Tagged
local tagged = librarian.require("scisssssssors/awesome-tagged")

if (librarian.is_installed("scisssssssors/awesome-tagged")) then
  local tagged_keys = {}

  for i = 0, 10 do
    tagged_keys[i] = {
      view = {{ modkey }, tostring(i)},
      move_to = {{ modkey, "Shift" }, tostring(i)},
    }
  end

  tagged.init({
    { -- 1 screen configuration
      {
        wallpaper = beautiful.wallpaper,
        tags = {
          { name = "0", layout = awful.layout.suit.tile, keys = tagged_keys[0], },
          { name = "1", layout = awful.layout.suit.tile, keys = tagged_keys[1], },
          { name = "2", layout = awful.layout.suit.tile, keys = tagged_keys[2], },
          { name = "3", layout = awful.layout.suit.tile, keys = tagged_keys[3], },
          { name = "4", layout = awful.layout.suit.max.fullscreen, keys = tagged_keys[4],
            clients = {
              class = { "Gimp" }
            }
          },
          { name = "5", layout = awful.layout.suit.tile, keys = tagged_keys[5], },
          { name = "6", layout = awful.layout.suit.floating, keys = tagged_keys[6],
            clients = {
              class = { "steam.exe", "Wine", "Lutris", "Steam" },
              name = { "Steam" },
            },
          },
          { name = "7", layout = awful.layout.suit.tile, keys = tagged_keys[7], },
          { name = "8", layout = awful.layout.suit.tile, keys = tagged_keys[8], },
          { name = "9", layout = awful.layout.suit.max, keys = tagged_keys[9],
            clients = {
              class = { "TelegramDesktop", "Skype", "discord", "Riot" },
            },
          },
        },
      },
    },
    { -- 2 screens configuration
      { -- 1st screen
        wallpaper = beautiful.wallpaper,
        tags = {
          { name = "0", layout = awful.layout.suit.tile, keys = tagged_keys[0],
            force_clients = true,
            clients = {
              class = { "st-project" },
            },
          },
          { name = "1", layout = awful.layout.suit.max, keys = tagged_keys[1],
            clients = {
              class = { "Chromium" },
            },
          },
          { name = "2", layout = awful.layout.suit.tile, keys = tagged_keys[2], },
          { name = "3", layout = awful.layout.suit.tile, keys = tagged_keys[3], },
          { name = "4", layout = awful.layout.suit.floating, keys = tagged_keys[4], },
          { name = "5", layout = awful.layout.suit.tile, keys = tagged_keys[5], },
          { name = "6", layout = awful.layout.suit.floating, keys = tagged_keys[6],
            clients = {
              class = { "steam.exe", "Wine", "Lutris", "Steam", "elitedangerous64.exe" },
              name = { "Steam" },
            },
          },
          { name = "7", layout = awful.layout.suit.tile, keys = tagged_keys[7], },
          { name = "9", layout = awful.layout.suit.max, keys = tagged_keys[9],
            clients = {
              class = { "TelegramDesktop", "Skype", "discord", "Riot" }
            },
          },
        },
      },
      { -- 2nd screen
        wallpaper = beautiful.wallpaper,
        tags = {
          { name = "8", layout = awful.layout.suit.tile, keys = tagged_keys[8], },
        },
      },
    },
  })
end
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then -- luacheck: globals awesome
  naughty.notify({ preset = naughty.config.presets.critical,
      title = "Oops, there were errors during startup!",
    text = awesome.startup_errors }) -- luacheck: globals awesome
end

-- Handle runtime errors after startup
do
  local in_error = false
  awesome.connect_signal("debug::error", function (err) -- luacheck: globals awesome
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
      text = tostring(err) })
    in_error = false
  end)
end
-- }}}

local function show_status()
  local status_message = ":: " .. os.date('%X | %a, %d/%m/%Y') .. "\n"
  awful.spawn.easy_async_with_shell('bash -c "acpi | cut -d, -f 2 | head -1 | tr -d \'[:space:]\'"', function(stdout)
    status_message = status_message .. ":: " .. stdout:gsub("%c$", "")
    naughty.notify { text = status_message }
  end)
end

-- {{{ Key bindings
local globalkeys = gears.table.join(
  root.keys(), -- luacheck: globals root
  awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    {description = "view previous", group = "tag"}),
  awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    {description = "view next", group = "tag"}),
  awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    {description = "go back", group = "tag"}),

  awful.key({ modkey,           }, "j",
    function ()
      awful.client.focus.byidx( 1)
    end,
    {description = "focus next by index", group = "client"}
    ),
  awful.key({ modkey,           }, "k",
    function ()
      awful.client.focus.byidx(-1)
    end,
    {description = "focus previous by index", group = "client"}
    ),

  -- Layout manipulation
  awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
    {description = "swap with next client by index", group = "client"}),
  awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
    {description = "swap with previous client by index", group = "client"}),
  awful.key({ modkey,           }, "Tab", function () awful.screen.focus_relative( 1) end,
    {description = "focus the next screen", group = "screen"}),
  awful.key({ modkey, "Shift" }, "Tab", function () awful.screen.focus_relative(-1) end,
    {description = "focus the previous screen", group = "screen"}),
  awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
    {description = "jump to urgent client", group = "client"}),

  -- Standard program
  awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
    {description = "open a terminal", group = "launcher"}),
  awful.key({ modkey, "Shift" }, "r", awesome.restart, -- luacheck: globals awesome
    {description = "reload awesome", group = "awesome"}),

  awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    {description = "increase master width factor", group = "layout"}),
  awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    {description = "decrease master width factor", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    {description = "increase the number of master clients", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    {description = "decrease the number of master clients", group = "layout"}),
  awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
    {description = "increase the number of columns", group = "layout"}),
  awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
    {description = "decrease the number of columns", group = "layout"}),
  awful.key({ modkey }, "y",     function () awful.spawn.with_shell("maim --select --hidecursor --quality 10 --capturebackground --nokeyboard | xclip -selection clipboard -t image/png")    end,
    {description = "make a screenshot", group = "misc"}),
  awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
    {description = "select next", group = "layout"}),
  awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
    {description = "select previous", group = "layout"}),

  awful.key({ modkey            }, "p", function () awful.spawn.with_shell('physlock')      end,
    {description = "lock screen", group = "layout"}),
  awful.key({ modkey            }, "n", function () show_status()                           end,
    {description = "show current status", group = "awesome"})
)

local clientkeys = gears.table.join(
  awful.key({ modkey,           }, "f",
    function (c)
      c.fullscreen = not c.fullscreen
      c:raise()
    end,
    {description = "toggle fullscreen", group = "client"}),
  awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
    {description = "close", group = "client"}),
  awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
    {description = "toggle floating", group = "client"}),
  awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    {description = "move to master", group = "client"}),
  awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    {description = "move to screen", group = "client"})
)

local clientbuttons = gears.table.join(
  awful.button({ }, 1, function (c) client.focus = c; c:raise() end),  -- luacheck: globals client
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys) -- luacheck: globals root
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = gears.table.join(awful.rules.rules,
  {
    { rule = { },
      properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = clientkeys,
        buttons = clientbuttons,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    },
  }
)
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c) -- luacheck: globals client
  if awesome.startup and -- luacheck: globals awesome
    not c.size_hints.user_position
    and not c.size_hints.program_position then
    -- Prevent clients from being unreachable after screen count changes.
    awful.placement.no_offscreen(c)
  end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end) -- luacheck: globals client
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end) -- luacheck: globals client
-- }}}

-- Make max.fullscreen layout actually fullscreen
client.connect_signal("manage", function (c) -- luacheck: globals client
  if c.first_tag.layout.name == awful.layout.suit.max.fullscreen.name then
    c.fullscreen = true
  end
end)

-- Rounded corners
-- client.connect_signal("manage", function(c)
--     c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.border_radius) end
--   end)

-- client.connect_signal("property::fullscreen", function(c) -- luacheck: globals client
--     if c.fullscreen then
--       c.shape = function(cr, w, h) gears.shape.rectangle(cr, w, h, beautiful.border_radius) end
--     else
--       c.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, beautiful.border_radius) end
--     end
--   end)
-- }}}
