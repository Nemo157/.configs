Plug 'w0rp/ale'

try
  set signcolumn=number
catch
  set signcolumn=yes
endtry

let g:ale_sign_error=''
let g:ale_sign_warning=' '
let g:ale_sign_info=' '
let g:ale_sign_style_error='🪶'
let g:ale_sign_style_warning='🪶'
