let s:save_cpo = &cpo
set cpo&vim


let s:V = vital#of('commandlinefu')
let s:Base64 = s:V.import('Data.Base64')
let s:HTTP = s:V.import('Web.HTTP')
let s:URI = s:V.import('Web.URI')
let s:JSON = s:V.import('Web.JSON')

let s:cache = {}

function! commandlinefu#api#search(query) abort
  if has_key(s:cache, a:query)
    return s:cache[a:query]
  endif

  let l:url = printf(
    \ 'http://www.commandlinefu.com/commands/matching/%s/%s/json',
    \ s:URI.encode(a:query),
    \ s:URI.encode(s:Base64.encode(a:query)))

  let l:header = {"User-Agent": "unite-commandlinefu"}

  let l:res = s:HTTP.get(l:url, {}, l:header)
  let l:json = s:JSON.decode(l:res.content)

  let s:cache[a:query] = deepcopy(l:json)

  return l:json
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
