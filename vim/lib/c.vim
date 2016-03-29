" Clang based C/C++ Completion
Plug 'Rip-Rip/clang_complete'

" Use clang_completes config file so it can be generated by Makefile and shared
let g:syntastic_c_config_file='.clang_complete'

" Use clang if available
if executable('clang')
  let g:syntastic_c_compiler='clang'
endif

" Stops syntastic from injecting a whole lot of random include dirs
" (wtf does it try this at all?)
" Big issue with this is SDL vs SDL2, both use SDL.h so need to only include
" the SDL2 directory otherwise everything breaks.
let g:syntastic_c_no_include_search=1

if filereadable('/Library/Developer/CommandLineTools/usr/lib/libclang.dylib')
  let g:clang_library_path='/Library/Developer/CommandLineTools/usr/lib/libclang.dylib'
endif
