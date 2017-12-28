" This is basic vim plugin boilerplate
let s:save_cpo = &cpoptions
set cpoptions&vim

function! template#Enable()
  " TODO: Program something in
  echom "Setting up Strotter Template Plugin"
endfunction

" This is basic vim plugin boilerplate
let &cpo = s:save_cpo
unlet s:save_cpo
