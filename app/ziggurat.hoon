::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
    ldb=linedb,
    pyro=zig-pyro,
    ui=zig-indexer,
    zig=zig-ziggurat,
    zink=zig-zink
/+  agentio,
    dbug,
    default-agent,
    mip,
    strandio,
    verb,
    dock=docket,
    engine=zig-sys-engine,
    pyro-lib=pyro-pyro,
    seq=zig-sequencer,
    smart=zig-sys-smart,
    ziggurat-threads=zig-ziggurat-threads,
    ziggurat-lib=zig-ziggurat
::
|%
+$  card  $+(card card:agent:gall)
--
::
=|  inflated-state-0:zig
=*  state  -
=|  smart-lib-noun=*
=|  zink-cax-noun=*
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def      ~(. (default-agent this %|) bowl)
    io       ~(. agentio bowl)
    strand   strand:spider
    zig-lib  ~(. ziggurat-lib bowl settings)
::
++  on-init
  ^-  (quip card _this)
  =*  scry-prefix=path
    :^  (scot %p our.bowl)  q.byk.bowl  (scot %da now.bowl)
    /lib/zig/sys
  =.  smart-lib-noun
    .^  *
        %cx
        (weld scry-prefix /smart-lib/noun)
    ==
  =.  zink-cax-noun
    .^  *
        %cx
        (weld scry-prefix /hash-cache/noun)
    ==
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) jets:zink %.y %.n]
  =*  nec-address
    0x7a9a.97e0.ca10.8e1e.273f.0000.8dca.2b04.fc15.9f70
  =*  bud-address
    0xd6dc.c8ff.7ec5.4416.6d4e.b701.d1a6.8e97.b464.76de
  =*  wes-address
    0x5da4.4219.e382.ad70.db07.0a82.12d2.0559.cf8c.b44d
  ~&  %z^%on-init
  :-  :+  %.  [%pyro /load-failed]
          ~(watch-our pass:io /pyro-load-failed)
        %.  (add now.bowl ~s5)
        ~(wait pass:io /on-init-zig-setup)
      ~
  %_    this
      state
    :_  [eng smart-lib]
    :*  %0
        ~
    ::
        %+  ~(put by *configs:zig)  'global'
        %-  ~(gas by *config:zig)
        :~  [[~nec %address] nec-address]
            [[~bud %address] bud-address]
            [[~wes %address] wes-address]
            [[~nec %sequencer] 0x0]
        ==
    ::
        ''
        ~
        [%uninitialized ~]
        [1.024 10.000 10 200]
    ==
  ==
::
++  on-save  !>(-.state)
::
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  ::  on-load: pre-cue our compiled smart contract library
  =*  scry-prefix=path
    :^  (scot %p our.bowl)  q.byk.bowl  (scot %da now.bowl)
    /lib/zig/sys
  =.  smart-lib-noun
    .^  *
        %cx
        (weld scry-prefix /smart-lib/noun)
    ==
  =.  zink-cax-noun
    .^  *
        %cx
        (weld scry-prefix /hash-cache/noun)
    ==
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) jets:zink %.y %.n]
  `this(state [!<(state-0:zig old-vase) eng smart-lib])
::
++  on-watch
  |=  p=path
  ^-  (quip card _this)
  ?+    p  (on-watch:def p)
      [%pyro-done ~]  `this
      [%project ~]    `this
  ==
::
++  on-poke
  |=  [m=mark v=vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
    ?+  m  (on-poke:def m v)
      %ziggurat-action  (handle-poke !<(action:zig v))
    ==
  [cards this]
  ::
  ++  handle-poke
    |=  act=action:zig
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    =*  tag  -.+.+.+.act
    =/  =update-info:zig
      [project-name.act desk-name.act tag request-id.act]
    =*  zig-threads
      %~  .  ziggurat-threads
      :+  project-name.act  desk-name.act
      %+  get-ship-to-address-map:zig-lib
      project-name.act  configs
    |^
    ?-    tag
        %new-project
      =/  =long-operation-info:zig
        :+  ~  %new-project
        :_  `%fetch-repo
        %-  zing
        :^    fetch-repo:make-operation-steps:zig-lib
            setup-project:make-operation-steps:zig-lib
          commit-install-start:make-operation-steps:zig-lib
        ~
      ~&  %z^%np^%0
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      ::  do we have requested commit locally?
      =*  commit=@ta
        ?~  commit-hash.act  %head
        (scot %ux u.commit-hash.act)
      =*  repo-path-prefix=path
        :-  (scot %p repo-host.act)
        /[desk-name.act]/[branch-name.act]/[commit]
      =*  have-commit-locally
        (is-linedb-path-populated:zig-lib repo-path-prefix)
      ?.  have-commit-locally
        :_  state
        :_  ~
        %-  %~  arvo  pass:io
            /new-project-from-remote/[desk-name.act]
        :^  %k  %lard  q.byk.bowl
        %+  fetch-repo:zig-threads  repo-host.act
        :^  desk-name.act  branch-name.act
        long-operation-info  `!>(`action:zig`act)
      ::
      ~&  %z^%np^%1
      =/  cards=(list card)
        %+  setup-project-desk  repo-host.act
        :^  branch-name.act  commit-hash.act  update-info
        special-configuration-args.act
      :_  %=  state
              projects
            ?:  =('' focused-project)  projects
            ?~  thread-queue           projects
            %+  ~(jab by projects)     focused-project
            |=  =project:zig
            project(saved-thread-queue thread-queue)
          ==
      ?:  =('zig-dev' project-name.act)  cards
      :_  cards
      %-  ~(poke-self pass:io /self-wire)
      :-  %ziggurat-action
      !>  ^-  action:zig
      :^  project-name.act  desk-name.act
        request-id.act
      :^  %queue-thread
        (cat 3 'make-snap-' focused-project)  %lard
      (make-snap:zig-threads focused-project request-id.act)
    ::
        %delete-project
      =/  =project:zig  (~(got by projects) project-name.act)
      :_  %=  state
              projects
            (~(del by projects) project-name.act)
          ==
      =*  cards
        %+  turn  desks.project
        |=  [desk-name=@tas @ =repo-info:zig ^]
        %+  make-cancel-watch-for-file-changes:zig-lib
          project-name.act
        [repo-host repo-name branch-name]:repo-info
      =/  new-focus=(unit @tas)
        ?.  =(focused-project project-name.act)  ~
        ?.  (~(has by projects) %zig-dev)  `''  `%zig-dev
      ?~  new-focus  cards
      %+  snoc  cards
      %-  ~(poke-self pass:io /self-wire)
      :-  %ziggurat-action
      !>  ^-  action:zig
      :^  u.new-focus  desk-name.act  request-id.act
      [%change-focus ~]
    ::
        %add-sync-desk-vships
      |^
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  missing-ships=(list @p)
        (find-missing ships.act pyro-ships.project)
      ?^  missing-ships
        ::  start ships and then call this again
        :_  state
        :_  ~
        %-  %~  arvo  pass:io
            /add-sync-desk-vships
        :^  %k  %lard  q.byk.bowl
        =/  m  (strand ,vase)
        ^-  form:m
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          [%start-pyro-ships missing-ships]
        ;<  ~  bind:m  (sleep:strandio ~s1)
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          [%ziggurat-action !>(`action:zig`act)]
        (pure:m !>(~))
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =/  =long-operation-info:zig
        :^  ~  %add-sync-desk-vships
          commit-install-start:make-operation-steps:zig-lib
        `%commit-files-to-pyro-ships
      :_  state
      :_  ~
      %-  %~  arvo  pass:io  /add-sync-desk-vships
      :^  %k  %lard  q.byk.bowl
      %+  skip-queue:zig-threads  request-id.act
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        :^    %queue-thread
            (cat 3 'add-sync-desk-vships-' desk-name.act)
          %lard
        %^  commit-install-start:zig-threads  ships.act
          ~[repo-info.desk]
        :^    %-  ~(put by *(map @tas (list @p)))
              [desk-name install]:act
            %-  ~(put by *(map @tas (list @tas)))
            [desk-name start-apps]:act
          long-operation-info
        %.y
      (pure:m !>(~))
      ::
      ++  find-missing
        ::  return needles not in haystack
        |=  [needles=(list @p) haystack=(list @p)]
        ^-  (list @p)
        %~  tap  in
        %-  ~(dif in (~(gas in *(set @p)) needles))
        (~(gas in *(set @p)) haystack)
      --
    ::
        %delete-sync-desk-vships
      =/  =project:zig
        (~(got by projects) project-name.act)
      =.  sync-desk-to-vship.project
        |-
        ?~  ships.act  sync-desk-to-vship.project
        %=  $
            ships.act  t.ships.act
        ::
            sync-desk-to-vship.project
          %-  ~(del ju sync-desk-to-vship.project)
          [desk-name i.ships]:act
        ==
      :-  ~
      %=  state
          projects
        (~(put by projects) project-name.act project)
      ==
    ::
        %send-state-views
      :_  state
      :_  ~
      %-  fact:io  :_  ~[/project]
      :-  %json
      !>  ^-  json
      %-  update:enjs:zig-lib
      !<  update:zig
      %.  state-views.act
      %~  state-views  make-update-vase:zig-lib
      :^  project-name.act  desk-name.act  %send-state-views
      request-id.act
    ::
        %set-ziggurat-state
      `state(- new-state.act)
    ::
        %send-update
      :_  state
      :_  ~
      %-  fact:io  :_  ~[/project]
      [%ziggurat-update !>(`update:zig`update.act)]
    ::
        %change-focus
      |^
      =/  old=@t  focused-project
      =*  new=@t  project-name.act
      ?:  =(old new)  `state
      =/  new-project=project:zig  (~(got by projects) new)
      =*  new-snap-path  most-recent-snap.new-project
      =/  cards=(list card)
        %-  sync-out-of-date-desks
        (val-desk:zig-lib new-project)
      =?  cards  !=(~ new-snap-path)
        :_  cards
        %+  ~(poke-our pass:io /pyro-wire)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        [%restore-snap new-snap-path]
      ?.  (~(has by projects) old)
        :_  %=  state
                focused-project  new
                thread-queue     saved-thread-queue.new-project
                projects
              %+  ~(put by projects)  new
              new-project(saved-thread-queue ~)
            ==
        %+  weld  cards
        %+  update-linedb-watches  ~
        (project-to-repo-infos:zig-lib new-project)
      =/  old-project=project:zig  (~(got by projects) old)
      =/  old-snap-path=path
        /[old]/(scot %da now.bowl)
      =.  most-recent-snap.old-project  old-snap-path
      :_  %=  state
              focused-project  new
              thread-queue     saved-thread-queue.new-project
              projects
            %-  ~(gas by projects)
            :+  [new new-project(saved-thread-queue ~)]
              [old old-project(saved-thread-queue thread-queue)]
            ~
          ==
      :_  %+  weld  cards
          %+  update-linedb-watches
            (project-to-repo-infos:zig-lib old-project)
          (project-to-repo-infos:zig-lib new-project)
      %+  ~(poke-our pass:io /pyro-wire)  %pyro
      :-  %pyro-action
      !>  ^-  action:pyro
      :+  %snap-ships  old-snap-path
      pyro-ships.old-project
    ::
    ++  update-linedb-watches
      |=  [old=(list repo-info:zig) new=(list repo-info:zig)]
      ^-  (list card)
      %+  weld
        %+  turn  old
        |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
        %-  make-cancel-watch-for-file-changes:zig-lib
        [focused-project repo-host repo-name branch-name]
      %+  turn  new
      |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
      %-  make-watch-for-file-changes:zig-lib
      [project-name.act repo-host repo-name branch-name]
    ::
    ++  sync-out-of-date-desks
      |=  desks=(list desk:zig)
      ^-  (list card)
      %+  murn  desks
      |=  =desk:zig
      =*  ri  repo-info.desk
      =/  most-recent-commit=(unit @ux)
        %-  get-most-recent-commit:zig-lib
        [repo-host repo-name branch-name]:ri
      ?~  most-recent-commit
        ~&  %ziggurat^%sync-out-of-date-desks^%unexpected-null^ri
        ~
      ?:  .=  u.most-recent-commit
          most-recently-seen-commit.desk
        ~
      =*  desk-name  name.desk
      :-  ~
      %-  %~  arvo  pass:io
          /update-pyro-desk/[project-name.act]/[desk-name]
      :^  %k  %lard  q.byk.bowl
      %~  update-pyro-desks-to-repo  ziggurat-threads
      :+  project-name.act  desk-name
      %+  get-ship-to-address-map:zig-lib
      project-name.act  configs
    --
    ::
        %add-project-desk
      =/  add-project-desk-error
        %~  add-project-desk  make-error-vase:zig-lib
        [update-info %error]
      =/  =project:zig  (~(got by projects) project-name.act)
      ?:  (has-desk:zig-lib project desk-name.act)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  add-project-desk-error(level %warning)
        %-  crip
        %+  weld  "project {<`@tas`project-name.act>}"
        " already has desk {<`@tas`desk-name.act>}"
      =|  =desk:zig
      =.  desk
        %=  desk
            name  desk-name.act
            repo-info
          [repo-host desk-name branch-name commit-hash]:act
        ==
      =.  desks.project
        ?~  index.act
          (snoc desks.project [desk-name.act desk])
        (into desks.project u.index.act [desk-name.act desk])
      =/  =long-operation-info:zig
        :+  ~  %add-project-desk
        :_  `%fetch-repo
        fetch-repo:make-operation-steps:zig-lib
      :_  state
      :_  ~
      %-  %~  arvo  pass:io
          /new-project-from-remote/[desk-name.act]
      :^  %k  %lard  q.byk.bowl
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  empty-vase=vase  bind:m
        %+  fetch-repo:zig-threads  repo-host.act
        :^  desk-name.act  branch-name.act
          long-operation-info
        :-  ~
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act
          request-id.act
        :-  %set-ziggurat-state
        %=  -.state
            projects
          (~(put by projects) project-name.act project)
        ==
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        %-  make-read-repo-cage:zig-lib
        [project-name desk-name request-id]:act
      ;<  empty-vase=vase  bind:m
        %-  send-long-operation-update:zig-threads
        ?~  long-operation-info  ~
        %=  long-operation-info
            current-step.u  ~
        ==
      (pure:m !>(~))
    ::
        %delete-project-desk
      =/  delete-project-desk-error
        %~  delete-project-desk  make-error-vase:zig-lib
        [update-info %error]
      =/  =project:zig  (~(got by projects) project-name.act)
      ?.  (has-desk:zig-lib project desk-name.act)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  delete-project-desk-error(level %warning)
        %-  crip
        %+  weld  "project {<`@tas`project-name.act>}"
        " doesn't have desk {<`@tas`desk-name.act>}"
      =.  project
        %-  del-desk:zig-lib  :_  desk-name.act
        %=  project
            sync-desk-to-vship
          %.  desk-name.act
          ~(del by sync-desk-to-vship.project)
        ==
      :-  ~
      %=  state
          projects
        (~(put by projects) project-name.act project)
      ==
    ::
        %save-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        desk(user-files (~(put in user-files.desk) file.act))
      :_  %=  state
              projects
            (~(put by projects) project-name.act project)
          ==
      :_  ~
      %-  %~  arvo  pass:io
          [%save [project-name desk-name file]:act]
      :^  %k  %lard  q.byk.bowl
      (save-file:zig-threads [file contents]:act)
    ::
        %delete-file
      ::  should show warning
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        %=  desk
            user-files  (~(del in user-files.desk) file.act)
            to-compile  (~(del in to-compile.desk) file.act)
        ==
      :_  state(projects (~(put by projects) project-name.act project))
      :_  ~
      %-  ~(arvo pass:io /del-wire)
      [%c %info desk-name.act %& [file.act %del ~]~]
    ::
        %make-configuration-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  repo-dependencies=(list @t)
        %+  turn  desks.project
        |=  [n=@tas *]
        (crip "[our.bowl {<n>} %master ~]")
      =*  configuration-file-text
        %+  make-configuration-template:zig-lib
        repo-dependencies  pyro-ships.project
      =*  configuration-file-path
        /zig/configuration/[desk-name.act]/hoon
      =^  cards=(list card)  state
        %-  handle-poke
        :^  project-name.act  desk-name.act  request-id.act
        :+  %save-file  configuration-file-path
        configuration-file-text
      [cards state]
    ::
        %add-config
      =.  configs
        %^  ~(put bi:mip configs)  project-name.act
        [who what]:act  item.act
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  [who what item]:act
      %~  add-config  make-update-vase:zig-lib
      update-info
    ::
        %delete-config
      =.  configs
        (~(del bi:mip configs) project-name.act [who what]:act)
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  [who what]:act
      %~  delete-config  make-update-vase:zig-lib
      update-info
    ::
        %register-for-compilation
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      ?:  (~(has in to-compile.desk) file.act)  `state
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        %=  desk
            user-files  (~(put in user-files.desk) file.act)
            to-compile  (~(put in to-compile.desk) file.act)
        ==
      :-  :_  ~
          %+  make-build-file:zig-lib
            :^  project-name.act  desk-name.act
            %register-for-compilation  request-id.act
          file.act
      state(projects (~(put by projects) project-name.act project))
    ::
        %unregister-for-compilation
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      ?.  (~(has in to-compile.desk) file.act)  `state
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        %=  desk
            to-compile  (~(del in to-compile.desk) file.act)
        ==
      :-  ~
      state(projects (~(put by projects) project-name.act project))
    ::
        %deploy-contract-virtualnet
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =/  queue-thread-error
        %~  queue-thread  make-error-vase:zig-lib
        [update-info %error]
      =*  thread-name=@tas
        %^  cat  3  'deploy-contract-'
        (spat contract-jam-path.act)
      =/  host=(unit @p)
        %^  town-id-to-sequencer-host:zig-lib  project-name.act
        town-id.act  configs
      ?~  host
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  queue-thread-error
        :_  thread-name
        %-  crip
        %+  weld  "could not find host for town-id"
        " {<town-id.act>} amongst {<configs>}"
      =*  who  ?^(who.act u.who.act u.host)
      :_  state
      :_  ~
      %-  %~  arvo  pass:io  /deploy-contract
      :^  %k  %lard  q.byk.bowl
      %+  skip-queue:zig-threads  request-id.act
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        :^  %queue-thread  thread-name  %lard
        %-  send-wallet-transaction:zig-threads
        :^  who  u.host  !>(deploy-contract:zig-threads)
        [[%& who] town-id.act contract-jam-path.act %.n ~]
      (pure:m !>(~))
    ::
        %deploy-contract-livenet
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =/  queue-thread-error
        %~  queue-thread  make-error-vase:zig-lib
        [update-info %error]
      =*  thread-name=@tas
        %^  cat  3  'deploy-contract-'
        (spat contract-jam-path.act)
      :_  state
      :_  ~
      %-  %~  arvo  pass:io  /deploy-contract
      :^  %k  %lard  q.byk.bowl
      %+  skip-queue:zig-threads  request-id.act
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        :^  %queue-thread  thread-name  %lard
        %+  deploy-contract:zig-threads  [%| from.act]
        [town-id.act contract-jam-path.act %.n ~]
      (pure:m !>(~))
    ::
        %build-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =*  repo-host    repo-host.repo-info.desk
      =*  branch-name  branch-name.repo-info.desk
      =*  commit-hash  commit-hash.repo-info.desk
      :_  state
      :+  %-  make-read-repo:zig-lib
          [project-name desk-name request-id]:act
        %-  %~  arvo  pass:io
            ^-  path
            :^  %build-result  project-name.act  desk-name.act
            path.act
        :^  %k  %fard  %suite
        :-  %ziggurat-build
        :-  %noun
        !>  :-  ~
            :^  project-name.act  desk-name.act
              request-id.act
            [repo-host branch-name commit-hash path.act]
      ~
    ::
        %watch-repo-for-changes
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =*  repo-host    repo-host.repo-info.desk
      =*  branch-name  branch-name.repo-info.desk
      :_  state
      :_  ~
      %-  make-watch-for-file-changes:zig-lib
      :^  project-name.act  repo-host  desk-name.act
      branch-name
    ::
        %read-repo
      ::  for internal use -- app calls itself to scry clay
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =*  repo-host    repo-host.repo-info.desk
      =*  branch-name  branch-name.repo-info.desk
      =*  commit-hash  commit-hash.repo-info.desk
      =*  commit=@ta
        ?~  commit-hash  %head  (scot %ux u.commit-hash)
      =.  dir.desk
        %-  sort  :_  aor
        %~  tap  in
        %~  key  by
        .^  (map path wain)
            %gx
            :-  (scot %p our.bowl)
            :^  %linedb  (scot %da now.bowl)
              (scot %p repo-host)
            /[desk-name.act]/[branch-name]/[commit]/noun
        ==
      :_  %=  state
              projects
            %+  ~(put by projects)  project-name.act
            (put-desk:zig-lib project desk-name.act desk)
          ==
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  dir.desk
      %~  dir  make-update-vase:zig-lib
      update-info
    ::
        %queue-thread
      =/  queue-thread-error
        %~  queue-thread  make-error-vase:zig-lib
        [update-info %error]
      ?:  ?=(%lard -.payload.act)
        =^  update-vase=vase  thread-queue
          %-  add-to-queue:zig-lib
          :^  thread-queue  thread-name.act  payload.act
          update-info
        :_  state
        :_  ~
        (update-vase-to-card:zig-lib update-vase)
      ?>  ?=(%fard -.payload.act)
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =*  ri  repo-info.desk
      =*  commit=@ta
        ?~  commit-hash.ri  %head
        (scot %ux u.commit-hash.ri)
      =/  repo-path=path
        :-  (scot %p repo-host.ri)
        /[repo-name.ri]/[branch-name.ri]/[commit]
      =^  thread-path=(unit path)  thread-name.act
        =/  thread-path=(unit path)
          (get-fit:zig-lib repo-path %ted thread-name.act)
        ?^  thread-path  [thread-path thread-name.act]
        =*  thread-name-with-prefix=@tas
          (cat 3 'ziggurat-' thread-name.act)
        =/  thread-path-with-prefix=(unit path)
          %^  get-fit:zig-lib  repo-path  %ted
          thread-name-with-prefix
        ?~  thread-path-with-prefix  [~ thread-name.act]
        [thread-path-with-prefix thread-name-with-prefix]
      ?~  thread-path
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %+  queue-thread-error  'thread not found'
        thread-name.act
      :_  state
      :_  ~
      %-  %~  arvo  pass:io
          ^-  path
          :^  %queue-thread-result  project-name.act
          desk-name.act  u.thread-path
      :^  %k  %lard  q.byk.bowl
      =/  m  (strand ,vase)
      ^-  form:m
      ~&  %z^%qt^%m1
      ;<  thread-vase=vase  bind:m
        (build:zig-threads ri (snoc u.thread-path %hoon))
      ~&  %z^%qt^%0
      =+  !<(thread=(each vase tang) thread-vase)
      ?:  ?=(%| -.thread)
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          :-  %send-update
          !<  update:zig
          %+  queue-thread-error
            %^  cat  3
            '\0afailed to build thread\0a'  :: TODO: remove one \0a
            (reformat-compiler-error:zig-lib p.thread)
          thread-name.act
        (pure:m !>(~))
      ~&  %z^%qt^%1
      =^  update-vase=vase  thread-queue
        %-  add-to-queue:zig-lib
        :^  thread-queue  thread-name.act
          :-  %lard
          !<  shed:khan
          %+  slam  p.thread
          !>  ^-  vase
          ?.  =(!>(~) args.payload.act)  args.payload.act
          !>(`[project-name desk-name request-id]:act)
        update-info
      ~&  %z^%qt^%2
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        [%set-ziggurat-state -.state]
      ~&  %z^%qt^%3
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        [%send-update !<(update:zig update-vase)]
      ~&  %z^%qt^%4
      (pure:m p.thread)
    ::
        %save-thread
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  saved-test-steps.desk
        %-  ~(put by saved-test-steps.desk)
        [thread-name test-imports test-steps]:act
      =/  thread-text=@t
        %-  convert-test-steps-to-thread:zig-lib
        [project-name desk-name test-imports test-steps]:act
      =/  thread-path=path
        (thread-name-to-path:zig-lib thread-name.act)
      :_  %=  state
              projects
            %+  ~(put by projects)  project-name.act
            (put-desk:zig-lib project desk-name.act desk)
          ==
      :_  :_  ~
      %-  update-vase-to-card:zig-lib
      %.  thread-path
      ~(save-file make-update-vase:zig-lib update-info)
      %-  %~  arvo  pass:io
          /save-thread/[project-name.act]/[thread-name.act]
      :^  %k  %lard  q.byk.bowl
      (save-file:zig-threads thread-path thread-text)
    ::
        %delete-thread
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  saved-test-steps.desk
        (~(del by saved-test-steps.desk) thread-name.act)
      =*  thread-path  (thread-name-to-path:zig-lib thread-name.act)
      =^  cards=(list card)  state
        %-  handle-poke
        :^  project-name.act  desk-name.act  request-id.act
        [%delete-file thread-path]
      :-  cards
      %=  state
          projects
        %+  ~(put by projects)  project-name.act
        (put-desk:zig-lib project desk-name.act desk)
      ==
    ::
        %run-queue
      ~&  %z^%run-queue^(show-thread-queue:zig-lib thread-queue)
      =/  run-queue-error
        %~  run-queue  make-error-vase:zig-lib
        [update-info %error]
      =/  s=status:zig  status  ::  TODO: remove this hack
      ?-    -.s
          %running-thread
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %info)
        'queue already running'
      ::
          %uninitialized
        =/  top=(unit thread-queue-item:zig)
          ~(top to thread-queue)
        ?:  ?&  ?=(^ top)
                =('zig-dev' project-name.u.top)
                ?=(%zig-dev desk-name.u.top)
                ?=(%lard -.payload.u.top)
                ?=(%zig-configuration-zig-dev thread-name.u.top)
            ==
          =.  status  [%ready ~]
          $
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %warning)
        'must run %start-pyro-ships before threads'
      ::
          %ready
        ?:  =(~ thread-queue)
          :_  state
          :_  ~
          %-  update-vase-to-card:zig-lib
          %-  run-queue-error(level %warning)
          'no threads in queue'
        =^  top=thread-queue-item:zig  thread-queue
          ~(get to thread-queue)
        =*  next-project-name  project-name.top
        =*  next-desk-name     desk-name.top
        =*  next-thread-name   thread-name.top
        =*  next-payload       payload.top
        =.  status  [%running-thread ~]
        :_  state
        :+  %-  update-vase-to-card:zig-lib
            %.  thread-queue
            %~  thread-queue  make-update-vase:zig-lib
            update-info
          %-  %~  arvo  pass:io
              ^-  path
              :^  %thread-result  next-project-name
              next-desk-name  /[next-thread-name]
          ?:  ?=(%lard -.next-payload)
            [%k %lard q.byk.bowl shed.next-payload]
          :^  %k  %fard  next-desk-name
          [next-thread-name [%noun args.next-payload]]
        ~
      ==
    ::
        %clear-queue
      =.  thread-queue  ~
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  thread-queue
      ~(thread-queue make-update-vase:zig-lib update-info)
    ::
        %stop-pyro-ships
      =/  =project:zig  (~(got by projects) project-name.act)
      =.  projects
        %+  ~(put by projects)  project-name.act
        project(pyro-ships ~)
      =.  status  [%uninitialized ~]
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  status
      %~  status  make-update-vase:zig-lib
      update-info
    ::
        %start-pyro-ships
      =/  =project:zig
        (~(gut by projects) project-name.act *project:zig)
      =?  ships.act  ?=(~ ships.act)  default-ships:zig-lib
      =/  new-ships=(list @p)
        ?:  ?&  =('zig' project-name.act)
                ?=(~ pyro-ships.project)
            ==
          ::  special case for initial setup of %zig project
          default-ships:zig-lib
        %+  diff-ship-lists:zig-lib
          ?^  pyro-ships.project  pyro-ships.project
          default-ships:zig-lib
        ships.act
      =.  pyro-ships.project
        ?~  pyro-ships.project  default-ships:zig-lib
        (weld pyro-ships.project new-ships)
      =.  projects
        (~(put by projects) project-name.act project)
      :_  state
      :: %+  turn  new-ships
      %+  turn  ships.act
      |=  who=@p
      %+  ~(poke-our pass:io /self-wire)  %pyro
      [%pyro-action !>([%init-ship who])]
    ::
        %take-snapshot
      =/  maybe-project=(unit project:zig)
        (~(get by projects) project-name.act)
      ?~  maybe-project  `state  ::  TODO
      =*  project  u.maybe-project
      =/  snap-path=path
        ?^  update-project-snaps.act
          u.update-project-snaps.act
        /[project-name.act]/(scot %da now.bowl)
      :-  :_  ~
          %+  ~(poke-our pass:io /pyro-poke)  %pyro
          :-  %pyro-action
          !>  ^-  action:pyro
          [%snap-ships snap-path pyro-ships.project]
      %=  state
          projects
        ?^  update-project-snaps.act  projects
        %+  ~(put by projects)  project-name.act
        project(most-recent-snap snap-path)
      ==
    ::
        %publish-app
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =*  repo-host    (scot %p repo-host.repo-info.desk)
      =*  repo-name    desk-name.act
      =*  branch-name  branch-name.repo-info.desk
      =*  commit-hash  commit-hash.repo-info.desk
      =*  commit=@ta
        ?~  commit-hash  %head
        (scot %ux u.commit-hash)
      =*  scry-prefix
        :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
        /[repo-host]/[repo-name]/[branch-name]/[commit]
      =|  cards=(list card)
      ::  make desk.bill if it does not exist
      =/  desk-bill-current-contents=(unit @t)
        .^((unit @t) %gx (weld scry-prefix /desk/bill/noun))
      =?  cards  ?=(~ desk-bill-current-contents)
        :_  cards
        %-  %~  arvo  pass:io
            [%save project-name.act desk-name.act /desk/bill]
        :^  %k  %lard  q.byk.bowl
        (save-file:zig-threads /desk/bill '~')
      ::  make desk.ship if it does not exist
      =/  desk-ship-current-contents=(unit @t)
        .^((unit @t) %gx (weld scry-prefix /desk/ship/noun))
      =?  cards  ?=(~ desk-ship-current-contents)
        :_  cards
        %-  %~  arvo  pass:io
            [%save project-name.act desk-name.act /desk/ship]
        :^  %k  %lard  q.byk.bowl
        %+  save-file:zig-threads  /desk/ship
        (crip "{<our.bowl>}")
      ::  make docket if it does not exist
      =/  desk-docket-current-contents=(unit @t)
        .^((unit @t) %gx (weld scry-prefix /desk/docket-0/noun))
      =?  cards  ?=(~ desk-ship-current-contents)
        :_  cards
        %-  %~  arvo  pass:io
            :^  %save  project-name.act  desk-name.act
            /desk/docket-0
        :^  %k  %lard  q.byk.bowl
        %+  save-file:zig-threads  /desk/docket-0
        %-  crip
        """
        :~  title+{<title.act>}
            info+{<info.act>}
            color+{<color.act>}
            glob-ames+[{<our.bowl>} 0v0]
            base+{<`@t`project-name.act>}
            image+{<image.act>}
            version+{<version.act>}
            website+{<website.act>}
            license+{<license.act>}
        ==
        """
      ::  put files into our clay
      =.  cards
        :_  cards
        %+  ~(poke-our pass:io /treaty-wire)  %linedb
        :-  %linedb-action
        !>
        :^  %install  repo-host.repo-info.desk  repo-name
        [branch-name commit-hash]
      ::  publish via treaty
      =.  cards
        :_  cards
        %+  ~(poke-our pass:io /treaty-wire)  %treaty
        [%alliance-update-0 !>([%add our.bowl repo-name])]
      [(flop cards) state]
    ::
        %add-user-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        desk(user-files (~(put in user-files.desk) file.act))
      :_
        %=  state
          projects  (~(put by projects) project-name.act project)
        ==
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  file.act
      %~  add-user-file  make-update-vase:zig-lib
      update-info
    ::
        %delete-user-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        desk(user-files (~(del in user-files.desk) file.act))
      :_
        %=  state
          projects  (~(put by projects) project-name.act project)
        ==
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  file.act
      %~  delete-user-file  make-update-vase:zig-lib
      update-info
    ::
        %send-pyro-dojo
      :_  state
      :_  ~
      %+  %~  poke-our  pass:io
          :+  %dojo  (scot %p who.act)
          /(scot %ux `@ux`(jam command.act))
        %pyro
      :-  %pyro-events
      !>  ^-  (list pyro-event:pyro)
      (dojo-events:pyro-lib [who command]:act)
    ::
        %pyro-agent-state
      =/  who=@ta  (scot %p who.act)
      =*  app      app.act
      =?  grab.act  =('' grab.act)  '-'
      =/  now=@ta  (scot %da now.bowl)
      =/  state-error
        %~  pyro-agent-state  make-error-vase:zig-lib
        [update-info %error]
      ?.  .^  ?
              %gx
              :-  (scot %p our.bowl)
              /pyro/[now]/i/[who]/gu/[who]/[app]/[now]/$/noun
          ==
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %-  crip
        "%pyro ship {<who.act>} not running agent {<`@tas`app>}"
      =/  [wex=boat:gall sup=bitt:gall]
        .^  [boat:gall bitt:gall]
            %gx
            :+  (scot %p our.bowl)  %pyro
            /[now]/[who]/[app]/dbug/subscriptions/noun/noun
        ==
      =+  .^  agent-state=vase
              %gx
              :+  (scot %p our.bowl)  %pyro
              /[now]/[who]/[app]/dbug/state/noun/noun
          ==
      :_  state
      :_  ~
      %-  %~  arvo  pass:io
          /pyro-agent-state
      :^  %k  %lard  q.byk.bowl
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  subject=(each vase @t)  bind:m
        (compile-imports ~(tap by imports.act))
      ?:  ?=(%| -.subject)
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          :-  %send-update
          !<  update:zig
          %-  state-error
          %^  cat  3  'compilation of imports failed:\0a'
          p.subject
        (pure:m !>(~))
      =.  p.subject
        ;:(slop agent-state !>(who=(slav %p who)) p.subject)
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      ::  %shown-pyro-agent-state over %pyro-agent-state
      ::   because there are casts deep in vanes that don't
      ::   take too kindly to vases within vases
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        :-  %send-update
        !<  update:zig
        %.  [(show-state:zig-lib modified-state) wex sup]
        %~  shown-pyro-agent-state  make-update-vase:zig-lib
        update-info
      (pure:m !>(~))
    ::
        %pyro-chain-state
      =?  grab.act  =('' grab.act)  '-'
      ::  %shown-pyro-chain-state over %pyro-chain-state
      ::   because there are casts deep in vanes that don't
      ::   take too kindly to vases within vases
      =/  state-error
        %~  pyro-chain-state  make-error-vase:zig-lib
        [update-info %error]
      =/  chain-state=(each (map @ux batch:ui) @t)
        (get-chain-state:zig-lib project-name.act configs)
      ?:  ?=(%| -.chain-state)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        (state-error p.chain-state)
      :_  state
      :_  ~
      %-  %~  arvo  pass:io
          /pyro-chain-state
      :^  %k  %lard  q.byk.bowl
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  subject=(each vase @t)  bind:m
        (compile-imports ~(tap by imports.act))
      ?:  ?=(%| -.subject)
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          :-  %send-update
          !<  update:zig
          %-  state-error
          %^  cat  3  'compilation of imports failed:\0a'
          p.subject
        (pure:m !>(~))
      =.  p.subject
        ;:(slop !>(p.chain-state) !>(who=~nec) p.subject)
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        :-  %send-update
        !<  update:zig
        %.  (show-state:zig-lib modified-state)
        %~  shown-pyro-chain-state  make-update-vase:zig-lib
        update-info
      (pure:m !>(~))
    ::
        %change-settings
      `state(settings settings.act)
    ::
        %get-dev-desk
      :_  state
      :+  (make-new-desk:zig-lib desk-name.act)
        (get-dev-desk:zig-lib [who desk-name]:act)
      ~
    ::
        %set-repo-info
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      :-  ~
      %=  state
          projects
        %+  ~(put by projects)  project-name.act
        %^  put-desk:zig-lib  project  desk-name.act
        desk(repo-info repo-info.act)
      ==
    ==
    ::
    ++  compile-imports
      |=  imports=(list [face=@tas =path])
      =/  m  (strand ,(each vase @t))
      ^-  form:m
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  repo-infos=(list repo-info:zig)
        (project-to-repo-infos:zig-lib project)
      |^
      ;<  subject=(each vase tang)  bind:m  build-subject
      ?:  ?=(%| -.subject)
        %-  pure:m
        :-  %|
        (reformat-compiler-error:zig-lib p.subject)
      %-  pure:m
      :-  %&
      ;:(slop !>(configs=configs) !>(bowl=bowl) p.subject)
      ::
      ++  build-subject
        =/  m  (strand ,(each vase tang))
        ^-  form:m
        =/  working-subject=vase  !>(..zuse)
        |-
        ?~  imports  (pure:m [%& working-subject])
        =*  face         face.i.imports
        =*  import-path  (snoc path.i.imports %hoon)
        =/  repo-info=(unit repo-info:zig)
          %+  find-file-in-repos:zig-lib  import-path
          repo-infos
        ?~  repo-info
          %-  pure:m
          :-  %|
          [%leaf "could not find import {<import-path>}"]~
        ;<  result-vase=vase  bind:m
          (build:zig-threads u.repo-info import-path)
        =+  !<(result=(each vase tang) result-vase)
        ?:  ?=(%| -.result)  (pure:m [%| p.result])
        %=  $
            imports  t.imports
            working-subject
          %-  slop  :_  working-subject
          p.result(p [%face face p.p.result])
        ==
      --
    ::
    ++  setup-project-desk
      |=  $:  repo-host=@p
              branch-name=@tas
              commit-hash=(unit @ux)
              =update-info:zig
              special-configuration-args=vase
          ==
      ^-  (list card)
      =*  project-name  project-name.update-info
      =*  desk-name     desk-name.update-info
      =*  request-id    request-id.update-info
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      =/  =long-operation-info:zig
        :+  ~  %new-project
        :_  `%get-dependency-repos
        %-  zing
        :^    fetch-repo:make-operation-steps:zig-lib
            setup-project:make-operation-steps:zig-lib
          commit-install-start:make-operation-steps:zig-lib
        ~
      =*  commit=@ta
        ?~  commit-hash  %head  (scot %ux u.commit-hash)
      =*  repo-path-prefix=path
        :-  (scot %p repo-host)
        /[desk-name]/[branch-name]/[commit]
      =/  config-file-path=path
        /zig/configuration/[desk-name]/hoon
      =*  does-config-exist=?
        %+  does-linedb-have-file:zig-lib  repo-path-prefix
        config-file-path
      ~&  %z^%np^%does-config-exist^does-config-exist
      ?:  does-config-exist
        :_  ~
        %-  %~  arvo  pass:io
          /setup-project-desk/yes-configuration
        :^  %k  %lard  q.byk.bowl
        %+  skip-queue:zig-threads  request-id.act
        =/  m  (strand ,vase)
        ^-  form:m
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name  desk-name  request-id
          :^    %queue-thread
              (cat 3 'zig-configuration-' desk-name)
            %lard
          =/  m  (strand ,vase)
          ^-  form:m
          ;<  empty-vase=vase  bind:m
            %-  send-long-operation-update:zig-threads
            ?~  long-operation-info  ~
            %=  long-operation-info
                current-step.u  `%uild-configuration-thread
            ==
          ;<  configuration-thread-vase=vase  bind:m
            %-  build:zig-threads  :_  config-file-path
            [repo-host desk-name branch-name commit-hash]
          =+  !<  configuration-thread=(each vase tang)
              configuration-thread-vase
          ?:  ?=(%| -.configuration-thread)
            ;<  ~  bind:m
              %+  poke-our:strandio  %ziggurat
              :-  %ziggurat-action
              !>  ^-  action:zig
              :^  project-name  desk-name  request-id
              :-  %send-update
              !<  update:zig
              %-  new-project-error
              %^  cat  3
              '\0afailed to build configuration file\0a'
              %-  reformat-compiler-error:zig-lib
              p.configuration-thread
            (pure:m !>(~))
          ~&  %zspfc^%3
          ;<  empty-vase=vase  bind:m
            !<  shed:khan
            %+  slam
              (slap p.configuration-thread (ream '$'))
            !>  ^-  vase
            ?:  =(!>(~) special-configuration-args)
              !>
              :^  ~  project-name  desk-name
              [request-id repo-host long-operation-info]
            ;:  slop
                !>(~)
                !>(project-name)
                !>(desk-name)
                !>(request-id)
                !>(repo-host)
                !>(long-operation-info)
                special-configuration-args
            ==
          ~&  %zspfc^%5
          ;<  empty-vase=vase  bind:m
            %-  send-long-operation-update:zig-threads
            ?~  long-operation-info  ~
            %=  long-operation-info
                current-step.u  ~
            ==
          (pure:m !>(~))
        (pure:m !>(~))
      :_  ~
      %-  %~  arvo  pass:io
        /setup-project-desk/no-configuration
      :^  %k  %lard  q.byk.bowl
      %+  skip-queue:zig-threads  request-id.act
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  empty-vase=vase  bind:m
        ?:  %.  desk-name
            %~  has  in
            .^  (set @tas)
                %cd
                /(scot %p our.bowl)//(scot %da now.bowl)
            ==
          (pure:m !>(~))
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name  desk-name  request-id
          :^  %queue-thread
            (cat 3 'create-desk-' desk-name)  %lard
          (create-desk:zig-threads update-info)
        (pure:m !>(~))
      ;<  ~  bind:m
        %+  poke-our:strandio  %ziggurat
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name  desk-name  request-id
        :^  %queue-thread
          (cat 3 'zig-configuration-' desk-name)  %lard
        =/  m  (strand ,vase)
        ^-  form:m
        ;<  empty-vase=vase  bind:m
          %:  setup-project:zig-threads
              repo-host
              request-id
              [our.bowl desk-name %master ~]~
              ~
              default-ships:zig-lib
              ~
              ~
              long-operation-info
          ==
        %-  send-long-operation-update:zig-threads
        ?~  long-operation-info  ~
        %=  long-operation-info
            current-step.u  ~
        ==
      (pure:m !>(~))
    --
  --
::
++  on-agent
  |=  [w=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-agent:def w sign)
      [%pyro-load-failed ~]
    ?:  ?=(%watch-ack -.sign)  `this
    ?>  ?=([%fact %noun ^] sign)
    =^  cards=(list card)  this  on-init
    :_  this
    :_  cards
    (~(leave-our pass:io w) %pyro)
  ::
      [%linedb @ @ @ @ ~]
    ?:  ?=(%watch-ack -.sign)  `this
    ?>  ?=([%fact %linedb-update ^] sign)
    =*  project-name  i.t.w
    =*  repo-host     (slav %p i.t.t.w)
    =*  repo-name     i.t.t.t.w
    =*  branch-name   i.t.t.t.t.w
    :_  this
    :_  ~
    %-  %~  arvo  pass:io  w
    :^  %k  %lard  q.byk.bowl
    %~  update-pyro-desks-to-repo  ziggurat-threads
    :+  project-name  repo-name
    %+  get-ship-to-address-map:zig-lib
    project-name  configs
  ==
::
++  on-arvo
  |=  [w=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-arvo:def w sign-arvo)
      [%new-project-from-remote @ ~]  `this
      [%sync @ @ @ @ @ @ ~]           `this
      [%save-thread @ @ ~]            `this
      [%add-sync-desk-vships ~]       `this
      [%queue-thread-result @ @ ^]    `this
      [%update-pyro-desk @ @ ~]       `this
      [%linedb @ @ @ @ ~]             `this
      [%pyro-agent-state ~]           `this
      [%pyro-chain-state ~]           `this
      [%add-sync-desk-vships ~]       `this
      [%deploy-contract ~]            `this
      [%setup-project-desk @ ~]       `this
      [%save @ @ ^]                   ::`this
    ~&  sign-arvo  `this
  ::
      [%on-init-zig-setup ~]
    =*  our  (scot %p our.bowl)
    =*  now  (scot %da now.bowl)
    ~&  %z^%on-init-zig-setup
    :_  this
    ?:  .^(? %gu /[our]/subscriber/[now]/$)  ~
    :_  ~
    %-  ~(poke-self pass:io /self-wire)
    :-  %ziggurat-action
    !>  ^-  action:zig
    :^  'zig-dev'  %zig-dev  ~
    :^    %new-project
        ?:  .^(? %j /[our]/fake/[now])  our.bowl
        make-canonical-distribution-ship:zig-lib
      %master
    :-  ~  !>(~)
  ::
      [%build-result @ @ ^]
    =*  project-name  i.t.w
    =*  desk-name     i.t.t.w
    =*  file-path     t.t.t.w
    ?.  ?&  ?=(%khan -.sign-arvo)
            ?=(%arow -.+.sign-arvo)
        ==
      (on-arvo:def w sign-arvo)
    =*  update-info  [project-name desk-name %build-result ~]
    =/  build-error
      %~  build-result  make-error-vase:zig-lib
      [update-info %error]
    :_  this
    ?:  ?=(%| -.p.+.sign-arvo)
      :_  ~
      %-  update-vase-to-card:zig-lib
      %-  build-error
      (reformat-compiler-error:zig-lib p.p.+.sign-arvo)
    =+  !<(result=(each vase tang) q.p.p.+.sign-arvo)
    :_  ~
    %-  update-vase-to-card:zig-lib
    ?:  ?=(%& -.result)
      %.  file-path
      ~(build-result make-update-vase:zig-lib update-info)
    %-  build-error
    (reformat-compiler-error:zig-lib p.result)
  ::
      [%thread-result @ @ @ ~]
    =*  project-name  i.t.w
    =*  desk-name     i.t.t.w
    =*  thread-name   i.t.t.t.w
    ?.  ?&  ?=(%khan -.sign-arvo)
            ?=(%arow -.+.sign-arvo)
        ==
      (on-arvo:def w sign-arvo)
    ~&  %z^%thread-result^thread-name
    =.  status  [%ready ~]
    ?:  ?=(%| -.p.+.sign-arvo)
      =*  error-message  (reformat-compiler-error:zig-lib p.p.+.sign-arvo)
      ~&  %thread-result^w^error-message
      =*  update-info
        [project-name desk-name %thread-result ~]
      =/  thread-error
        %~  thread-result  make-error-vase:zig-lib
        [update-info %error]
      :_  this(status status)
      :_  ~
      %-  update-vase-to-card:zig-lib
      (thread-error error-message thread-name)
    =/  cards=(list card)
      ?.  ?=(%zig-configuration (end [3 17] thread-name))
        ~
      =*  snap-path=path
        ?:  ?=(%zig desk-name)  default-snap-path:zig-lib
        /[project-name]/(scot %da now.bowl)
      :_  ~
      %-  ~(poke-self pass:io /self-wire)
      :-  %ziggurat-action
      !>  ^-  action:zig
      :^  project-name  desk-name  ~
      [%take-snapshot `snap-path]
    :_  this(status status)
    ?~  thread-queue
      %+  snoc  cards
      %-  update-vase-to-card:zig-lib
      %.  status
      %~  status  make-update-vase:zig-lib
      [project-name desk-name %thread-result ~]
    %+  snoc  cards
    %-  ~(poke-self pass:io /self-wire)
    :-  %ziggurat-action
    !>  ^-  action:zig
    [project-name desk-name ~ [%run-queue ~]]
  ::
      [%get-dev-desk @ ~]
    ?:  ?=([%clay %mere %.y ~] sign-arvo)  `this
    :_  this
    :_  ~
    %-  update-vase-to-card:zig-lib
    %.  (crip "merge fail: {<sign-arvo>}")
    %~  get-dev-desk  make-error-vase:zig-lib
    [['' i.t.w %get-dev-desk ~] %error]
  ==
::
++  on-peek
  |=  p=path
  ^-  (unit (unit cage))
  ?.  =(%x -.p)  ~
  =,  format
  ?+    +.p  (on-peek:def p)
      [%get-ship-to-address-map @ ~]
    :^  ~  ~  %ziggurat-update
    %.  (get-ship-to-address-map:zig-lib i.t.t.p configs)
    %~  ship-to-address-map  make-update-vase:zig-lib
    ['' %$ %get-ship-to-address-map ~]
  ::
      [%get-configs ~]
    :^  ~  ~  %ziggurat-update
    %.  configs
    %~  configs  make-update-vase:zig-lib
    ['' %$ %get-configs ~]
  ::
      [%get-ziggurat-state ~]
    :^  ~  ~  %ziggurat-update
    %.  -.state
    %~  ziggurat-state  make-update-vase:zig-lib
    ['' %$ %get-ziggurat-state ~]
  ::
      [%focused-project ~]
    :^  ~  ~  %ziggurat-update
    %.  focused-project
    %~  focused-project  make-update-vase:zig-lib
    ['' %$ %focused-project ~]
  ::
      [%project-names ~]
    :^  ~  ~  %ziggurat-update
    !>  ^-  update:zig
    :^  %project-names  ['' %$ %project-names ~]  [%& ~]
    ~(key by projects)
  ::
      [%projects ~]
    :^  ~  ~  %ziggurat-update
    %.  projects
    ~(projects make-update-vase:zig-lib ['' %$ %projects ~])
  ::
      [%project @ ~]
    =*  project-name  i.t.t.p
    =/  project=(unit project:zig)
      (~(get by projects) project-name)
    :^  ~  ~  %ziggurat-update
    ?~  project  !>(`update:zig`~)
    %.  u.project
    ~(project make-update-vase:zig-lib [project-name %$ %project ~])
  ::
      [%thread-queue ~]
    :^  ~  ~  %ziggurat-update
    %.  thread-queue
    %~  thread-queue  make-update-vase:zig-lib
    ['' %$ %thread-queue ~]
  ::
      [%sync-desk-to-vship ~]
    =/  p=(unit project:zig)
      (~(get by projects) focused-project)
    ?~  p  ``ziggurat-update+!>(~)
    =/  pyro-ships-app-states=(map @p (map @tas (set [@tas ?])))
      (get-pyro-ships-app-states:zig-lib pyro-ships.u.p)
    :^  ~  ~  %ziggurat-update
    %.  [sync-desk-to-vship.u.p pyro-ships-app-states]
    %~  sync-desk-to-vship  make-update-vase:zig-lib
    [focused-project %$ %sync-desk-to-vship ~]
  ::
      [%status ~]
    :^  ~  ~  %ziggurat-update
    %.  status
    %~  status  make-update-vase:zig-lib
    ['' %$ %status ~]
  ::
      [%settings ~]
    :^  ~  ~  %ziggurat-update
    %.  settings
    %~  settings  make-update-vase:zig-lib
    ['' %$ %settings ~]
  ::
      [%state-views @ @ ~]  ::  TODO: generalize from [%master ~]
    =*  repo-host          (slav %p i.t.t.p)
    =*  project-desk-name  i.t.t.t.p
    =*  update-info
      [project-desk-name project-desk-name %state-views ~]
    =/  state-views=(unit state-views:zig)
      %-  make-state-views:zig-lib
      [repo-host project-desk-name %master ~]
    ?~  state-views  ``json+!>(~)
    :^  ~  ~  %json
    !>  ^-  json
    %-  update:enjs:zig-lib
    !<  update:zig
    %.  u.state-views
    %~  state-views  make-update-vase:zig-lib  update-info
  ::
      [%get-smart-lib-vase ~]
    ``noun+!>(`vase`smart-lib-vase)
  ::
      [%file-exists @ ^]
    =*  desk-name=@tas   i.t.t.p
    =*  scry-path=path
      :^  (scot %p our.bowl)  desk-name  (scot %da now.bowl)
      t.t.t.p
    ``json+!>(`json`[%b .^(? %cu scry-path)])
  ::
      [%file-exists-in-project @ ^]
    =*  project-name=@tas  i.t.t.p
    =*  file-path=path     t.t.t.p
    =/  =project:zig  (~(got by projects) project-name)
    =/  import-desk=(unit @tas)
      %+  find-file-in-desks:zig-lib  file-path
      (turn desks.project head)
    ``json+!>(`json`[%b ?=(^ import-desk)])
  ::
      [%read-file @ @ ^]
    =*  project-name    i.t.t.p
    =*  desk-name       i.t.t.t.p
    =*  file-path=path  t.t.t.t.p
    =/  =project:zig  (~(got by projects) project-name)
    =/  =desk:zig  (got-desk:zig-lib project desk-name)
    =*  repo-host    (scot %p repo-host.repo-info.desk)
    =*  repo-name    repo-name.repo-info.desk
    =*  branch-name  branch-name.repo-info.desk
    =*  commit-hash  commit-hash.repo-info.desk
    =*  commit
      ?~  commit-hash  %head  (scot %ux u.commit-hash)
    =*  scry-path=path
      %-  weld  :_  (snoc file-path %noun)
      :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
      /[repo-host]/[repo-name]/[branch-name]/[commit]
    =+  .^(file-contents=(unit @t) %gx scry-path)
    ?~  file-contents  ``json+!>(~)
    ``json+!>(s+u.file-contents)
  ::
      [%read-desks ~]
    =*  p  /(scot %p our.bowl)//(scot %da now.bowl)
    :^  ~  ~  %json
    !>  ^-  json
    =/  desks  .^((set @t) %cd p)
    (set-cords:enjs:zig-lib desks)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
