" vim: et ts=2 sts=2 sw=2

" This is basic vim plugin boilerplate
let s:save_cpo = &cpoptions
set cpoptions&vim

" Use Python3 by default
let s:py = has('python3') ? 'py3' : 'py'
let s:pyeval = function(has('python3') ? 'py3eval' : 'pyeval')

" Basic setup
let s:STRTemplateSetup = 0
let s:FileSearchBufferName = ''
let s:JobList = []

function! s:SetUpPython()
  execute s:py 'from api import API'
  execute s:py 'str_template_api = API()'
  let s:STRTemplateSetup = 1
endfunction

function! s:Pyeval( eval_string )
  if has('python3')
    return py3eval( a:eval_string )
  endif
  return pyeval( a:eval_string )
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
  let l:buf_title = 'File_Search_Buffer'
  let l:options = '["noswapfile", "buftype=nofile", "filetype=STRTestBuf", "nobuflisted", "nomodifiable"]'
  let l:cmd = 'str_template_api.create_buffer("' . l:buf_title . '", ' . l:options . ')'
  let l:buffer_number = s:Pyeval(l:cmd)

  wincmd b
  if bufnr('%') !=# l:buffer_number
    rightbelow 10 split
    execute 'buffer ' . l:buffer_number
  endif
"  augroup strotterTemplateQuitBuffer
"    autocmd!
"    " autocmd BufLeave * call template#Enable()
"  augroup END

  execute s:py 'str_template_api.clear_buffer("' . l:buf_title . '")'
  execute s:py 'str_template_api.prepend_buffer("' . l:buf_title . '", 1, "Output (' . a:for . ')")'

  let l:job_options = {}
  let l:job_options.out_cb = function('s:searchOutput')
  let l:job_options.out_cb_args = {}
  let l:job_options.out_cb_args.for = a:for
  call add(s:JobList, app#job#Start('find . -type f', l:job_options))
endfunction

function! template#RunningJobs()
  let l:num_jobs_running = 0
  for l:job_id in s:JobList
    if app#job#IsRunning(l:job_id)
      let l:num_jobs_running += 1
    endif
  endfor
  return l:num_jobs_running
endfunction

function! template#StopAllJobs()
  for l:job_id in s:JobList
    execute app#job#Stop(l:job_id)
  endfor
endfunction

" This is basic vim plugin boilerplate
let &cpoptions = s:save_cpo
unlet s:save_cpo
