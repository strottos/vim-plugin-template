" This is basic vim plugin boilerplate
let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:restore_cpo()
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endfunction

if exists( "g:loaded_strotter_template_plugin" )
  call s:restore_cpo()
  finish
elseif !(has('python') || has('python3'))
  echohl WarningMsg |
      \ echomsg 'Plugin requires vim compiled with python or python3' |
      \ echohl None
  call s:restore_cpo()
  finish
elseif !(has('job') && has('timers') && has('lambda'))
  echohl WarningMsg |
      \ echomsg 'Plugin requires vim compiled with features `job`, `timers` and `lambda`' |
      \ echohl None
  call s:restore_cpo()
  finish
endif

let g:loaded_strotter_template_plugin = 1

if get(g:, 'strotter_template_plugin_autostart', 1)
  if has( 'vim_starting' ) " Loading at startup.
    " The following technique is from the YouCompleteMe plugin.
    " We defer loading until after VimEnter to allow the gui to fork (see
    " `:h gui-fork`) and avoid a deadlock situation, as explained here:
    " https://github.com/Valloric/YouCompleteMe/pull/2473#issuecomment-267716136
    augroup strotterTemplatePluginStart
      autocmd!
      autocmd VimEnter * call template#Enable()
    augroup END
  else " Manual loading with :packadd.
    call template#Enable()
  endif
endif

" This is basic vim plugin boilerplate
call s:restore_cpo()
