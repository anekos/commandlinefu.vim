
let s:save_cpo = &cpo
set cpo&vim


let s:unite_source = {
      \ 'name': 'commandlinefu',
      \ 'max_candidates': 30,
      \ 'default_action': 'append'
      \ }


function! s:word(entry)
  return a:entry.summary . "\n  " . a:entry.command
endfunction

function! s:unite_source.gather_candidates(args, context)
  let l:query = join(a:args, ' ')

  if len(l:query) ==# 0
    let l:query = input('query: ')
  endif

  let l:entries = commandlinefu#api#search(l:query)

  return map(l:entries,
        \ '{ "abbr": s:word(v:val),
        \    "word": v:val.command,
        \    "source": "commandlinefu",
        \    "is_multiline": 1,
        \    "kind": "common"}')
endfunction

function! unite#sources#commandlinefu#define() abort
  return s:unite_source
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
