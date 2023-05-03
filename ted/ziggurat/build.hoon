/-  spider,
    zig=zig-ziggurat
/+  strandio,
    zig-lib=zig-ziggurat,
    ziggurat-threads=zig-ziggurat-threads
::
=*  strand         strand:spider
=*  get-bowl       get-bowl:strandio
=*  get-time       get-time:strandio
=*  poke-our       poke-our:strandio
=*  scry           scry:strandio
=*  send-raw-card  send-raw-card:strandio
=*  sleep          sleep:strandio
::
=/  m  (strand ,vase)
=|  project-name=@t
=|  desk-name=@tas
=|  ship-to-address=(map @p @ux)
=|  start=@da
=*  zig-threads
  ~(. ziggurat-threads project-name desk-name ship-to-address)
|^  ted
::
+$  arg-mold
  $:  project-name=@t
      desk-name=@tas
      request-id=(unit @t)
      repo-host=@p
      branch-name=@tas
      commit-hash=(unit @ux)
      file-path=path
  ==
::
++  return-success
  =/  m  (strand ,vase)
  ^-  form:m
  (pure:m !>(`(unit @t)`~))
::
++  return-error
  |=  message=tape
  =/  m  (strand ,vase)
  ^-  form:m
  (pure:m !>(`(unit @t)``(crip message)))
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    =/  message=tape
      %+  weld
      "Usage:\0a-suite!ziggurat-build project-name=@t"
      " desk-name=@tas request-id=(unit @t) repo-host=@p"
      " branch-name=@tas commit-hash=(unit @ux) file-path=path"
    (return-error message)
  =.  project-name  project-name.u.args
  =.  desk-name     desk-name.u.args
  =*  request-id    request-id.u.args
  =*  repo-host     repo-host.u.args
  =*  branch-name   branch-name.u.args
  =*  commit-hash   commit-hash.u.args
  =*  file-path     file-path.u.args
  ?~  file-path  (return-error "file-path must be non-~")
  ?.  =(%con i.file-path)
    ;<  =bowl:strand  bind:m  get-bowl
    ;<  ~  bind:m
      %+  poke-our  %linedb
      :-  %linedb-action
      !>  ^-  action:ldb
      :^  %build  repo-host  repo-name
      [branch-name commit-hash file-path [%ted tid.bowl]]
    ~&  %zb^%non-con^%0
    ;<  build-result=vase  bind:m  (take-poke %linedb-update)
    ~&  %zb^%non-con^%1
    =+  !<(=update:ub build-result)
    ?.  ?=(%build -.update)
      %-  return-error
      %+  weld  "{<file-path>} build failed unexpectedly,"
      " please see dojo for compilation errors"
    ?^  q.result.update
      =+  !<(result=(each vase tang) result.update)
      ?:  ?=(%& -.result)  return-success
      =*  error  (reformat-compiler-error:zig-lib p.result)
      %-  return-error
      %+  weld  "{<file-path>} build failed: {<error>}"
      " please see dojo for additional compilation errors"
    %-  return-error
    %+  weld  "{<file-path>} build failed,"
    " please see dojo for compilation errors"
  ::  TODO: to %linedb
  ;<  have-jam-mar=?  bind:m
    (scry ? /cu/[desk-name]/mar/jam/hoon)
  ?.  have-jam-mar
    %-  return-error
    %+  weld  "/mar/jam/hoon does not exist in "
    " {<desk-name>}; please add and try again"
  ;<  smart-lib-vase=vase  bind:m
    (scry vase /gx/ziggurat/get-smart-lib-vase/noun)
  ;<  =bowl:strand  bind:m  get-bowl
  =/  =build-result:zig
    %^  build-contract:zig-lib  smart-lib-vase
      /(scot %p our.bowl)/[project-name]/(scot %da now.bowl)
    file-path
  ?:  ?=(%| -.build-result)
    %-  return-error
    %+  weld
      "contract compilation failed at {<`path`file-path>}"
    " with error:\0a{<(trip p.build-result)>}"
  =*  jam-path
    (need (convert-contract-hoon-to-jam:zig-lib file-path))
  ;<  ~  bind:m
    %-  send-raw-card
    %^  make-save-jam:zig-lib  desk-name  jam-path
    p.build-result
  ;<  ~  bind:m  (sleep ~s1)
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    %^  make-read-desk-cage:zig-lib  project-name  desk-name
    request-id
  return-success
--
