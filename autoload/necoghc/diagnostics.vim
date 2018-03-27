function! necoghc#diagnostics#report() abort
  let l:debug_flag = get(g:, 'necoghc_debug', 0)
  if !l:debug_flag
    let g:necoghc_debug = 1
  endif

  echomsg 'Current filetype:' &l:filetype

  let l:executable = executable('ghc-mod')
  let l:exe= 'ghc-mod'

  if get(g:, 'necoghc_use_stack', 0)
    let l:executable = executable('stack')
    let l:exe = 'stack ghc-mod'
  endif

  echomsg l:exe . ' is executable: ' . l:executable
  if !l:executable
    echomsg '  Your $PATH does not include the binary:' $PATH
  endif

  echomsg 'omnifunc:' &l:omnifunc
  echomsg 'neocomplete.vim:' exists(':NeoCompleteEnable')
  echomsg 'neocomplcache.vim:' exists(':NeoComplCacheEnable')
  echomsg 'YouCompleteMe:' exists(':YcmDebugInfo')

  try
    echomsg 'vimproc.vim:' vimproc#version()
  catch /^Vim\%((\a\+)\)\=:E117/
    echomsg 'vimproc.vim: not installed'
  endtry

  echomsg  l:exe . ' version:' necoghc#ghc_mod_version()

  if &l:filetype !=# 'haskell'
    call s:error('Run this command in a buffer with a Haskell file')
    return
  endif
  call necoghc#boot()
  echomsg 'Imported modules:' join(keys(necoghc#get_modules()), ', ')

  echomsg 'Number of symbols in Prelude:' len(necoghc#browse('Prelude'))

  if !l:debug_flag
    let g:necoghc_debug = 0
  endif
endfunction

function! s:error(msg) abort
  echohl ErrorMsg
  echomsg a:msg
  echohl None
endfunction
