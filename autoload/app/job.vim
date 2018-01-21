" job.vim
"
" Based on https://github.com/w0rp/ale/blob/master/autoload/ale/job.vim

if !has_key(s:, 'job_map')
  let s:job_map = {}
endif

function! s:ParseProcessID(job_string)
    return matchstr(a:job_string, '\d\+') + 0
endfunction

function! app#job#Start(command, options) abort
  let l:job_info = {'stdout': [], 'stderr': []}
  let l:job_options = deepcopy(a:options)

  if has_key(a:options, 'out_cb')
    let l:job_info.out_cb = a:options.out_cb
    let l:job_info.out_cb_args = []
    if has_key(a:options, 'out_cb_args')
      let l:job_info.out_cb_args = remove(l:job_options, 'out_cb_args')
    endif
  endif

  if has_key(a:options, 'err_cb')
    let l:job_info.err_cb = a:options.err_cb
    let l:job_info.err_cb_args = []
    if has_key(a:options, 'err_cb_args')
      let l:job_info.err_cb_args = a:options.err_cb_args
    endif
  endif

  let l:job_options.out_cb = function('s:StdoutCallback')
  let l:job_options.err_cb = function('s:StderrCallback')

  let l:job = job_start(a:command, l:job_options)
  let l:job_info.job = l:job
  let l:job_id = s:ParseProcessID(l:job)
  let s:job_map[l:job_id] = l:job_info

  return l:job_id
endfunction

function! app#job#IsRunning(job_id) abort
  let l:job = s:job_map[a:job_id].job
  return job_status(l:job) is# 'run'
endfunction

function! app#job#Stdout(job_id) abort
  return s:job_map[a:job_id].stdout
endfunction

function! app#job#Stderr(job_id) abort
  return s:job_map[a:job_id].stderr
endfunction

function! s:StdoutCallback(channel, data) abort
  let l:job = ch_getjob(a:channel)
  let l:job_id = s:ParseProcessID(string(l:job))
  let l:job_info = s:job_map[l:job_id]

  call add(l:job_info.stdout, a:data)

  if has_key(l:job_info, 'out_cb')
    call l:job_info.out_cb(l:job_id, a:data, l:job_info.out_cb_args)
  endif
endfunction

function! s:StderrCallback(channel, data) abort
  let l:job = ch_getjob(a:channel)
  let l:job_id = s:ParseProcessID(string(l:job))

  call add(s:job_map[l:job_id].stderr, a:data)

  if has_key(s:job_map[l:job_id], 'err_cb')
    call s:job_map[l:job_id].err_cb(l:job_id, a:data)
  endif
endfunction
