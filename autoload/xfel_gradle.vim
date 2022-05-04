function! xfel_gradle#root ()
  let l:cwd = fnameescape(fnamemodify(bufname(), ':p:h'))
  let l:files = findfile('build.gradle', l:cwd . ';', -1)
  if (empty(l:files))
    echo 'No build.gradle found in ancestors of current buffer'
  else
    return fnamemodify(l:files[-1], ':p:h')
  endif
endfunction

function! xfel_gradle#main (task)
  let l:path = xfel_gradle#root()

  if (empty(l:path))
    return
  endif

  let &makeprg = 'cd ' . fnameescape(l:path) . ';'
  let &makeprg .='./gradlew --console=plain -w ' . a:task
  let &errorformat='%t:\ %f:\ (%l\,\ %c):\ %m'     "kotlinc
  let &errorformat.=',%A%f:%l:\ %m,%-Z%p^,%-C%.%#' "javac
  let &errorformat.=',%-G%.%#'                     "ignore other lines
  make
  "copen
endfunction
