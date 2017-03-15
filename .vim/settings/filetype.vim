augroup FILETYPE
  autocmd!
  autocmd FileType cpp,c,hpp,h source ~/.vim/settings/filetype/cpp.vim
  autocmd FileType python source ~/.vim/settings/filetype/python.vim
  autocmd FileType php source ~/.vim/settings/filetype/php.vim
  autocmd FileType vim source ~/.vim/settings/filetype/vim.vim
  autocmd FileType html,css source ~/.vim/settings/filetype/htmlcss.vim
  autocmd FileType text source ~/.vim/settings/filetype/text.vim
  autocmd FileType markdown source ~/.vim/settings/filetype/markdown.vim
  autocmd FileType css source ~/.vim/settings/filetype/css.vim
  autocmd FileType scss source ~/.vim/settings/filetype/scss.vim
  autocmd FileType gitcommit source ~/.vim/settings/filetype/gitcommit.vim
augroup END

augroup FILETYPE_ALIASES
  autocmd!
  autocmd BufNewFile,BufRead *.module,*.inc,*.install,*.profile set filetype=php
  autocmd BufNewFile,BufRead *.info set filetype=dosini
  autocmd BufNewFile,BufRead *.tpl.php set filetype=phtml
augroup END
