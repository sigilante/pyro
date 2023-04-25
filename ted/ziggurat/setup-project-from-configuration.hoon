/-  spider,
    ub=uqbuild,
    zig=zig-ziggurat
/+  strandio
::
=*  strand     strand:spider
=*  poke-our   poke-our:strandio
=*  take-poke  take-poke:strandio
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold
  $:  tid=@tatid
      project-name=@tas
      repo-host=@p
      repo-name=@tas
      request-id=(unit @t)
      branch-name=@tas
      commit-hash=(unit @ux)
      file-path=path
      special-configuration-args=vase
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
      ;:  weld
          "Usage:\0a-suite!ziggurat-build tid=@tatid"
          " project-name=@t repo-host=@p repo-name=@tas"
          " request-id=(unit @t) branch-name=@tas"
          " commit-hash=(unit @ux) file-path=path"
          " special-configuration-args=vase"
      ==
    (return-error message)
  =*  tid           tid.u.args
  =*  project-name  project-name.u.args
  =*  repo-host     repo-host.u.args
  =*  repo-name     repo-name.u.args
  =*  request-id    request-id.u.args
  =*  branch-name   branch-name.u.args
  =*  commit-hash   commit-hash.u.args
  =*  file-path     file-path.u.args
  =*  special-configuration-args
    special-configuration-args.u.args
  ~&  %zspfc^%0
  ;<  ~  bind:m
    %+  poke-our  %uqbuild
    :-  %uqbuild-action
    !>  ^-  action:ub
    :^  %build  [%ted tid]  repo-host
    [repo-name branch-name commit-hash file-path]
  ~&  %zspfc^%1
  ;<  build-result=vase  bind:m  (take-poke %uqbuild-update)
  ~&  %zspfc^%2
  =+  !<(=update:ub build-result)
  ?.  ?=(%build -.update)     !!  :: TODO
  ?:  ?=(%| -.result.update)  !!  :: TODO
  =*  configuration-thread  p.result.update
  ~&  %zspfc^%3
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    :^  project-name  repo-name  request-id
    :^  %queue-thread
      (cat 3 'zig-configuration-' repo-name)  %lard
    !<  shed:khan
      %+  slam  (slap configuration-thread (ream '$'))
      !>  ^-  vase
      ?:  =(!>(~) special-configuration-args)
        !>(`[project-name repo-name request-id repo-host])
      ;:  slop
          !>(~)
          !>(project-name)
          !>(repo-name)
          !>(request-id)
          !>(repo-host)
          special-configuration-args
      ==
  ~&  %zspfc^%4
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    [project-name repo-name request-id [%run-queue ~]]
  ~&  %zspfc^%5
  return-success
--
