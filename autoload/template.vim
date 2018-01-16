" vim: et ts=2 sts=2 sw=2

" This is basic vim plugin boilerplate
let s:save_cpo = &cpoptions
set cpoptions&vim

" Use Python3 by default
let s:py = has('python3') ? 'py3' : 'py'
let s:pyeval = function(has('python3') ? 'py3eval' : 'pyeval')

" Check of whether already ran the setup code and already have a buffer name
let s:STRTemplateSetup = 0
let s:FileSearchBufferName = ''

function! s:SetUpPython()
  execute s:py 'from api import API'
  execute s:py 'str_template_api = API()'
  let s:STRTemplateSetup = 1
endfunction

function! template#Enable()
  if s:STRTemplateSetup
    return
  endif

  execute s:SetUpPython()
endfunction

function! s:searchOutput(job_id, data, args)
  execute s:py 'str_template_api.parse_output("' . a:data . '", "' . a:args.for . '")'
endfunction

function! template#Search(for)
  wincmd b
  let l:buf_title = 'File_Search_Buffer'
  if bufname(bufnr('%')) !=# l:buf_title
    if s:FileSearchBufferName != ''
      rightbelow 10 split
      execute 'buffer ' . s:FileSearchBufferName
    else
      let s:FileSearchBufferName = l:buf_title
      rightbelow 10 new
      execute 'silent edit ' . s:FileSearchBufferName
      setlocal noswapfile
      setlocal buftype=nofile
      setlocal filetype=STRTestBuf
      setlocal nobuflisted
    endif
  endif

  setlocal modifiable
  1,$delete
  put ='Output:'
  1delete
  setlocal nomodifiable

  let l:job_options = {}
  let l:job_options.out_cb = function('s:searchOutput')
  let l:job_options.out_cb_args = {}
  let l:job_options.out_cb_args.for = a:for
  execute app#job#Start('find . -type f', l:job_options)
endfunction

" This is basic vim plugin boilerplate
let &cpo = s:save_cpo
unlet s:save_cpo
