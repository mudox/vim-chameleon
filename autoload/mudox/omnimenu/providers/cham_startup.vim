" vim: foldmethod=marker

" GUARD                       {{{1
if exists("s:loaded") || &cp || version < 700
  finish
endif
let s:loaded = 1
" }}}1

" PROVIDER MEMEBERS           {{{1

function s:on_enter(session)   " {{{2
  echo 'lauching: ' . a:session.line

  call writefile([a:session.getsel()], g:mdx_chameleon_cur_mode_file)
  py import subprocess
  py subprocess.Popen('gvim')

  " close omnibuffer & clear cmd line.
  " closing at the beginning will cause vim to quit in statup mode, which
  " would skip the aboving spawning process.
  call mudox#omnimenu#close()
endfunction "  }}}2

function s:feed(session)       " {{{2
  let line_list = mudox#chameleon#TopModeList()

  if !empty(a:session.input)
    call filter(line_list, "match(v:val, '^.*' . a:session.input . '.*$') != -1")
  endif

  return line_list
endfunction "  }}}2

" }}}1

" PROVIDERS                {{{1

" used as a normal omnimenu session during any vim session.
let mudox#omnimenu#providers#cham_startup#provider = {
      \ 'title'             : 'New Gvim Instance',
      \ 'description'       : 'spawn a new gvim isntance in new mode',
      \ 'feed'              : function('s:feed'),
      \ 'on_enter'          : function('s:on_enter'),
      \ }

" specially used in chameleon startup mode.
" the omnimenu window will be open on startup as only window.
" and quit vim when user determinate the omnimenu session.
let mudox#omnimenu#providers#cham_startup#provider_startup = copy(
      \ mudox#omnimenu#providers#cham_startup#provider)
let mudox#omnimenu#providers#cham_startup#provider_startup.open_way   = 'edit'
let mudox#omnimenu#providers#cham_startup#provider_startup.shrinkable = 0
let mudox#omnimenu#providers#cham_startup#provider_startup.view       = 'list'

" }}}1
