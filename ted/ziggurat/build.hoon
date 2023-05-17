/-  linedb,
    spider,
    zig=zig-ziggurat
/+  strandio,
    zig-lib=zig-ziggurat,
    ziggurat-threads=zig-ziggurat-threads
::
=*  strand         strand:spider
=*  get-bowl       get-bowl:strandio
=*  get-time       get-time:strandio
=*  leave-our      leave-our:strandio
=*  poke-our       poke-our:strandio
=*  scry           scry:strandio
=*  send-raw-card  send-raw-card:strandio
=*  sleep          sleep:strandio
=*  take-fact      take-fact:strandio
=*  take-poke      take-poke:strandio
=*  watch-our      watch-our:strandio
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
  |=  result=vase
  =/  m  (strand ,vase)
  ^-  form:m
  (pure:m !>(`(each vase tang)`[%& result]))
::
++  return-error
  |=  message=tape
  =/  m  (strand ,vase)
  ^-  form:m
  (pure:m !>(`(each vase tang)`[%| [%leaf message]~]))
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    =/  message=tape
      ;:  weld
        "Usage:\0a-suite!ziggurat-build project-name=@t"
        " desk-name=@tas request-id=(unit @t) repo-host=@p"
        " branch-name=@tas commit-hash=(unit @ux)"
        " file-path=path"
      ==
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
      !>  ^-  action:linedb
      :^  %build  repo-host  desk-name
      [branch-name commit-hash file-path [%ted tid.bowl]]
    ~&  %zb^%non-con^%0
    ;<  build-result=vase  bind:m  (take-poke %linedb-update)
    ~&  %zb^%non-con^%1
    =+  !<(=update:linedb build-result)
    ?.  ?=(%build -.update)
      %-  return-error
      %+  weld  "{<file-path>} build failed unexpectedly,"
      " please see dojo for compilation errors"
    ?:  ?=(%& -.result.update)
      (return-success p.result.update)
    =*  error
      (reformat-compiler-error:zig-lib p.result.update)
    %-  return-error
    %+  weld  "{<file-path>} build failed: {<error>}"
    " please see dojo for additional compilation errors"
  =*  commit=@ta
    ?~  commit-hash  %head  (scot %ux u.commit-hash)
  =*  path-prefix=path
   /(scot %p repo-host)/[desk-name]/[branch-name]/[commit]
  ;<  jam-mar=(unit @t)  bind:m
    %+  scry  (unit @t)
    (welp [%gx %linedb path-prefix] /mar/jam/hoon/noun)
  ?~  jam-mar
    %-  return-error
    %+  weld  "/mar/jam/hoon does not exist in %linedb"
    " {<`path`path-prefix>}; please add and try again"
  ;<  smart-lib-vase=vase  bind:m
    (scry vase /gx/ziggurat/get-smart-lib-vase/noun)
  ;<  =bowl:strand  bind:m  get-bowl
  =*  zl  zig-lib(now.bowl now.bowl, our.bowl our.bowl)
  =/  =build-result:zig
    %^  build-contract:zl  smart-lib-vase  path-prefix
    file-path
  ?:  ?=(%| -.build-result)
    %-  return-error
    %+  weld
      "contract compilation failed at {<`path`file-path>}"
    " with error:\0a{<(trip p.build-result)>}"
  =*  jam-path
    (need (convert-contract-hoon-to-jam:zig-lib file-path))
  ;<  empty-vase=vase  bind:m
    (save-file:zig-threads jam-path (jam p.build-result))
  ;<  ~  bind:m
    %^  watch-our  /save-done  %linedb
    [%branch-updates (snip path-prefix)]
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    %^  make-read-repo-cage:zig-lib  project-name  desk-name
    request-id
  ;<  save-done=cage  bind:m  (take-fact /save-done)
  ;<  ~  bind:m  (leave-our /save-done %linedb)
  ?.  ?=(%linedb-update p.save-done)     !!
  =+  !<(=update:linedb q.save-done)
  ?.  ?=(%new-data -.update)             !!
  ?.  =((snip path-prefix) path.update)  !!
  (return-success !>(p.build-result))
--
