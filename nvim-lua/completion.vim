Plug 'nvim-lua/completion-nvim'

let g:completion_enable_snippet = 'UltiSnips'
let g:completion_confirm_key = "\<C-y>"
let g:completion_chain_complete_list = [
  \{'complete_items': ['lsp']},
  \{'complete_items': ['snippet']},
  \{'complete_items': ['path']},
  \{'mode': '<c-s>'},
  \{'mode': '<c-t>'}
\]
let g:completion_trigger_on_delete = 1
let g:completion_auto_change_source = 1
let g:completion_matching_strategy_list = ['exact', 'fuzzy']

" Use completion-nvim in every buffer
au BufEnter * lua require'completion'.on_attach()