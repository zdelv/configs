let s:yank_match = -1
let s:typst_job = v:null
let s:typst_pdf = ''

function! config#clipboard_copy(register, regtype, lines) abort
  let l:text = join(a:lines, "\n")
  if a:regtype ==# 'V'
    let l:text ..= "\n"
  endif
  call system(['/usr/bin/pbcopy'], l:text)
endfunction

function! config#clipboard_paste(register) abort
  let l:text = system(['/usr/bin/pbpaste'])
  let l:linewise = l:text =~# "\n$"
  let l:lines = split(l:text, "\n", 1)
  if l:linewise && !empty(l:lines) && l:lines[-1] ==# ''
    call remove(l:lines, -1)
  endif
  return [l:linewise ? 'V' : 'v', empty(l:lines) ? [''] : l:lines]
endfunction

function! config#term_abbrev() abort
  return getcmdtype() ==# ':' && getcmdline() ==# 'term'
        \ ? 'terminal ++curwin'
        \ : 'term'
endfunction

function! config#window_numbers() abort
  if &l:buftype ==# 'terminal'
    setlocal nonumber norelativenumber signcolumn=no
    setlocal fillchars+=eob:\ 
  elseif &l:buftype ==# ''
    setlocal number norelativenumber signcolumn=yes
    setlocal fillchars<
  endif
endfunction

function! config#highlight_yank() abort
  if s:yank_match != -1
    silent! call matchdelete(s:yank_match)
  endif
  let l:positions = []
  let l:first = getpos("'[")
  let l:last = getpos("']")
  if l:first[1] == 0 || l:last[1] == 0
    return
  endif
  for l:lnum in range(l:first[1], l:last[1])
    let l:start = l:lnum == l:first[1] ? l:first[2] : 1
    let l:length = l:lnum == l:last[1] ? max([1, l:last[2] - l:start + 1]) : max([1, strlen(getline(l:lnum)) - l:start + 1])
    call add(l:positions, [l:lnum, l:start, l:length])
  endfor
  let s:yank_match = matchaddpos('IncSearch', l:positions, 10)
  call timer_start(150, {-> execute('silent! call matchdelete(' .. s:yank_match .. ')')})
endfunction

function! config#command_exists(name) abort
  return exists(':' .. a:name) == 2
endfunction

function! config#lsp_setup() abort
  call LspOptionsSet(#{
        \ autoComplete: v:true,
        \ autoHighlight: v:true,
        \ autoHighlightDiags: v:true,
        \ completionMatcher: 'icase',
        \ diagSignErrorText: 'E',
        \ diagSignWarningText: 'W',
        \ diagSignInfoText: 'I',
        \ diagSignHintText: 'H',
        \ highlightDiagInline: v:true,
        \ popupBorder: v:true,
        \ semanticHighlight: v:true,
        \ showDiagOnStatusLine: v:true,
        \ showDiagWithSign: v:true,
        \ showDiagWithVirtualText: v:true,
        \ showSignature: v:true
        \ })

  let l:servers = []
  if executable('rust-analyzer')
    call add(l:servers, #{name: 'rust-analyzer', filetype: ['rust'], path: exepath('rust-analyzer'), args: [], rootSearch: ['Cargo.toml', '.git/']})
  endif
  if executable('oxfmt')
    call add(l:servers, #{
          \ name: 'oxfmt',
          \ filetype: ['javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'toml', 'json', 'jsonc', 'json5', 'yaml', 'html', 'vue', 'handlebars', 'css', 'scss', 'less', 'graphql', 'markdown'],
          \ path: exepath('oxfmt'),
          \ args: ['--lsp'],
          \ rootSearch: ['.oxfmtrc.json', '.oxfmtrc.jsonc', 'oxfmt.config.ts', 'package.json', '.git/']
          \ })
  endif
  if !empty(l:servers)
    call LspAddServer(l:servers)
  endif
endfunction

function! config#lsp_mappings() abort
  nnoremap <buffer> <silent> gd <Cmd>LspGotoDefinition<CR>
  nnoremap <buffer> <silent> gr <Cmd>LspShowReferences<CR>
  nnoremap <buffer> <silent> gI <Cmd>LspGotoImpl<CR>
  nnoremap <buffer> <silent> gD <Cmd>LspGotoDeclaration<CR>
  nnoremap <buffer> <silent> <leader>D <Cmd>LspGotoTypeDef<CR>
  nnoremap <buffer> <silent> <leader>ds <Cmd>Scope LspDocumentSymbol<CR>
  nnoremap <buffer> <silent> <leader>ws <Cmd>LspSymbolSearch<CR>
  nnoremap <buffer> <silent> <leader>rn <Cmd>LspRename<CR>
  nnoremap <buffer> <silent> <leader>ca <Cmd>LspCodeAction<CR>
  xnoremap <buffer> <silent> <leader>ca <Cmd>LspCodeAction<CR>
  nnoremap <buffer> <silent> <leader>ch <Cmd>LspHover<CR>
  nnoremap <buffer> <silent> <leader>th <Cmd>LspInlayHints toggle<CR>
  inoremap <buffer> <silent> <expr> <Tab> config#completion_tab()
endfunction

function! config#completion_tab() abort
  if !pumvisible()
    return "\<Tab>"
  endif
  " nvim-cmp used `confirm { select = true }`: select the first match when
  " necessary, then accept it without inserting a literal tab.
  return complete_info(['selected']).selected == -1
        \ ? "\<C-n>\<C-y>"
        \ : "\<C-y>"
endfunction

function! config#replace_range(first, last, lines) abort
  call setline(a:first, a:lines)
  let l:new_last = a:first + len(a:lines) - 1
  if l:new_last < a:last
    execute (l:new_last + 1) .. ',' .. a:last .. 'delete _'
  endif
endfunction

function! config#format(first, last) abort
  let l:view = winsaveview()
  let l:input = join(getline(a:first, a:last), "\n") .. "\n"
  let l:cmd = []
  if index(['c', 'cpp'], &filetype) >= 0 && executable('clang-format')
    let l:cmd = ['clang-format', '-style=file', '--assume-filename=' .. expand('%:p')]
  endif

  if !empty(l:cmd)
    let l:output = systemlist(l:cmd, l:input)
    if v:shell_error
      echohl ErrorMsg | echom join(l:output, "\n") | echohl None
    else
      call config#replace_range(a:first, a:last, l:output)
    endif
  elseif config#command_exists('LspFormat')
    execute a:first .. ',' .. a:last .. 'LspFormat'
  else
    echohl WarningMsg | echom 'No formatter is available for ' .. &filetype | echohl None
  endif
  call winrestview(l:view)
endfunction

function! config#format_on_save() abort
  if (index(['c', 'cpp'], &filetype) >= 0 && executable('clang-format'))
    call config#format(1, line('$'))
  endif
endfunction

function! config#format_json() abort
  if !executable('jq')
    echoerr 'FormatJson requires jq'
    return
  endif
  let l:view = winsaveview()
  let l:output = systemlist(['jq', '.'], join(getline(1, '$'), "\n"))
  if v:shell_error
    echohl ErrorMsg | echom 'jq failed: ' .. join(l:output, "\n") | echohl None
    return
  endif
  call config#replace_range(1, line('$'), l:output)
  call winrestview(l:view)
endfunction

function! config#grep_word() abort
  execute 'Scope Grep . ' .. shellescape(expand('<cword>'))
endfunction

function! config#files(directory) abort
  let l:cwd = getcwd()
  try
    execute 'lcd ' .. fnameescape(a:directory)
    Scope File
  finally
    execute 'lcd ' .. fnameescape(l:cwd)
  endtry
endfunction

function! config#todo_highlight() abort
  syntax match ConfigTodo /\v<(TODO|FIXME|HACK|WARN|WARNING|PERF|NOTE|TEST)>/ containedin=.*Comment.*
  highlight default link ConfigTodo Todo
endfunction

function! config#typst_preview() abort
  if &filetype !=# 'typst' && expand('%:e') !=# 'typ'
    echoerr 'TypstPreview must be run from a .typ file'
    return
  endif
  if !executable('typst')
    echoerr 'TypstPreview requires the typst executable'
    return
  endif
  call config#typst_preview_stop()
  silent update
  let s:typst_pdf = tempname() .. '.pdf'
  let l:compile = system(['typst', 'compile', expand('%:p'), s:typst_pdf])
  if v:shell_error
    echohl ErrorMsg | echom l:compile | echohl None
    return
  endif
  if has('mac')
    call job_start(['open', s:typst_pdf], #{out_io: 'null', err_io: 'null'})
  endif
  let s:typst_job = job_start(['typst', 'watch', expand('%:p'), s:typst_pdf], #{out_io: 'null', err_io: 'null'})
  echom 'Typst preview watching ' .. expand('%:t')
endfunction

function! config#typst_preview_stop() abort
  if type(s:typst_job) == v:t_job && job_status(s:typst_job) ==# 'run'
    call job_stop(s:typst_job)
  endif
  let s:typst_job = v:null
endfunction
