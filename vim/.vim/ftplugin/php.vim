let g:phpactorInitialCwd=FindProject('.git')
nnoremap <buffer> g] :call phpactor#GotoDefinition()<cr>

augroup PHP
  autocmd!
  autocmd FileType php setlocal omnifunc=phpactor#Complete
augroup END

let g:ale_fixers = {
      \   'php': [
      \       'php_cs_fixer',
      \   ],
      \}

let g:ale_php_phpmd_executable = 'phpmd'
let g:ale_php_phpmd_ruleset = 'unusedcode,cleancode,codesize'
let g:ale_php_phpmd_suffixes = 'php,module,inc,theme,install,profile,theme'

setlocal expandtab
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal tabstop=4
setlocal iskeyword+=$
