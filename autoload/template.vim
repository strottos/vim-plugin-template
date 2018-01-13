" vim: et ts=2 sts=2 sw=2

" This is basic vim plugin boilerplate
let s:save_cpo = &cpoptions
set cpoptions&vim

" Use Python3 by default
let s:py = has('python3') ? 'py3' : 'py'
let s:pyeval = function(has('python3') ? 'py3eval' : 'pyeval')

" Check whether already ran the setup code
let s:STRTemplateSetup = 0

function! s:SetUpPython()
  execute s:py 'import api as str_template_api'
  let s:STRTemplateSetup = 1
endfunction

function! template#Enable()
  if s:STRTemplateSetup
    return
  endif

  execute s:SetUpPython()

  " TODO: Program something in
endfunction

function! template#Search(for)
  exec s:py 'str_template_api.testing()'
endfunction

" This is basic vim plugin boilerplate
let &cpo = s:save_cpo
unlet s:save_cpo
