::  ziggurat [UQ| DAO]
::
::  Contract Playground
::
/-  spider,
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
    conq=zink-conq,
    dock=docket,
    engine=zig-sys-engine,
    pyro-lib=pyro-pyro,
    seq=zig-sequencer,
    smart=zig-sys-smart,
    zig-threads=zig-ziggurat-threads,
    ziggurat-lib=zig-ziggurat
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun   %noun  /lib/zig/sys/hash-cache/noun
::
|%
+$  card  card:agent:gall
--
::
=|  inflated-state-0:zig
=*  state  -
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
  :-  :_  ~
      %.  (add now.bowl ~s5)
      ~(wait pass:io /on-init-zig-setup)
  %_    this
      state
    :_  [eng smart-lib ~]
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
        ~
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
  ::  on-load: pre-cue our compiled smart contract library
  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
  =/  =eng:zig
    %~  engine  engine
    ::  sigs off, hints off
    [smart-lib ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun))) jets:zink %.y %.n]
  `this(state [!<(state-0:zig old-vase) eng smart-lib ~])
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
  ::  TODO handle app project pokes in their own arm
  =^  cards  state
    ?+  m  (on-poke:def m v)
      %ziggurat-action  (handle-poke !<(action:zig v))
    ==
  [cards this]
  ::
  :: ++  update-project-from-desk-change
  ::   |=  [=update-info:zig =project:zig]
  ::   ^-  [(list card) _state]
  ::   =*  project-name  project-name.update-info
  ::   =*  desk-name     desk-name.update-info
  ::   =/  [[cards=(list card) project-cis-running=(mip:mip @tas @p [@t ?]) ships=(set @p)] modified-state=_state]
  ::     %+  roll  (turn desks.project |=([p=@tas *] p))
  ::     |=  [current-desk-name=@tas [[cards=(list card) project-cis-running=(mip:mip @tas @p [@t ?]) ships=(set @p)] modified-state=_state]]
  ::     =/  [[iteration-cards=(list card) cfo=(unit configuration-file-output:zig)] modified-state=_state]
  ::       %+  load-configuration-file:zig-lib
  ::         update-info(desk-name current-desk-name)
  ::       ?.  =(*_state modified-state)  modified-state
  ::       %=  state
  ::           projects
  ::         (~(put by projects.state) project-name project)
  ::       ==
  ::     ?>  ?=(%commit-install-starting -.status.modified-state)
  ::     =/  [request-id=@t ?]
  ::       %-  ~(got by cis-running.status.modified-state)
  ::       -:?^(cfo ships.u.cfo default-ships:zig-lib)
  ::     :_  modified-state
  ::     :+  :_  (weld cards iteration-cards)
  ::         %^  make-read-desk:zig-lib  project-name
  ::         current-desk-name  `request-id
  ::       %+  ~(put by project-cis-running)  current-desk-name
  ::       cis-running.status.modified-state
  ::     %-  ~(gas in ships)
  ::     %+  weld  ?~(cfo ~ ships.u.cfo)
  ::     =<  pyro-ships
  ::     (~(gut by projects) project-name *project:zig)
  ::   =/  ships-to-run=(list @p)
  ::     ~(tap in (~(dif in ships) default-ships-set:zig-lib))
  ::   =.  project
  ::     (~(got by projects.modified-state) project-name)
  ::   =.  project
  ::     ?~  ships-to-run  project
  ::     project(pyro-ships (sort ~(tap in ships) lth))
  ::   :_  %=  modified-state
  ::           status
  ::         [%changing-project-desks project-cis-running]
  ::       ::
  ::           projects
  ::         %+  ~(put by projects.modified-state)
  ::         project-name  project
  ::       ==
  ::   %-  weld  :_  cards
  ::   :-  %+  ~(poke-our pass:io /pyro-poke)  %pyro
  ::       :-  %pyro-action
  ::       !>  ^-  action:pyro
  ::       [%restore-snap default-snap-path:zig-lib]
  ::   %+  turn  ships-to-run
  ::   |=  who=@p
  ::   %+  ~(poke-our pass:io /self-wire)  %pyro
  ::   [%pyro-action !>([%init-ship who])]
  ::
  ++  handle-poke
    |=  act=action:zig
    ^-  (quip card _state)
    ?>  =(our.bowl src.bowl)
    =*  tag  -.+.+.+.act
    :: ?:  =(tag %cis-panic)
    ::   ~^state(status [%ready ~])
    =/  =update-info:zig
      [project-name.act desk-name.act tag request-id.act]
    :: ?:  ?|  ?&  ?=(%commit-install-starting -.status)
    ::             !=(0 ~(wyt by cis-running.status))
    ::             ?|  ?=(~ request-id.act)
    ::             ::
    ::                 ?!
    ::                 %.  u.request-id.act
    ::                 %~  has  in
    ::                 %-  ~(gas in *(set @t))
    ::                 %+  turn  ~(val by cis-running.status)
    ::                 |=([cis-name=@t ?] cis-name)
    ::         ==  ==
    ::     ::
    ::         ?&  ?=(%changing-project-desks -.status)
    ::             !=(0 ~(wyt by project-cis-running.status))
    ::             ?|  ?=(~ request-id.act)
    ::             ::
    ::                 ?!
    ::                 %.  u.request-id.act
    ::                 %~  has  in
    ::                 %-  ~(gas in *(set @t))
    ::                 %+  turn
    ::                   ~(tap bi:mip project-cis-running.status)
    ::                 |=([@tas @p cis-name=@t ?] cis-name)
    ::             ==
    ::         ==
    ::     ==
    ::   :_  state
    ::   :_  ~
    ::   %-  update-vase-to-card:zig-lib
    ::   %-  %~  poke  make-error-vase:zig-lib
    ::       [update-info %error]
    ::   ?:  ?=(%commit-install-starting -.status)
    ::     'setting up new project; try again later'
    ::   'adding desk to project; try again later'
    ?-    tag
        %new-project
      ::  TODO: add to queue and run queue
      ~&  %z^%np^%0
      =/  new-project-error
        %~  new-project  make-error-vase:zig-lib
        [update-info %error]
      ::  is requested desk remote?
      ?^  fetch-desk-from-remote-ship.act
        :_  state
        :_  ~
        %-  %~  arvo  pass:io
            /new-project-from-remote/[desk-name.act]
        :^  %k  %lard  q.byk.bowl
        =/  m  (strand ,vase)
        ^-  form:m
        ;<  ~  bind:m
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  ''  desk-name.act  request-id.act
          [%get-dev-desk u.fetch-desk-from-remote-ship.act]
        ::  if no sleep, get crash;
        ::   TODO: replace sleep with non-hacky solution
        ;<  ~  bind:m  (sleep:strandio ~s1)
        ;<  ~  bind:m  
          %+  poke-our:strandio  %ziggurat
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          :^  %new-project  sync-ships.act  ~
          special-configuration-args.act
        (pure:m !>(~))
      ::
      ~&  %z^%np^%1
      =*  configuration-args
        !>([project-name desk-name request-id]:act)
      =/  config-file-path=path
        %+  weld  /(scot %p our.bowl)/[desk-name.act]
        /(scot %da now.bowl)/zig/configs/[desk-name.act]/hoon
      =/  does-config-exist=?  .^(? %cu config-file-path)
      ~&  %z^%np^%does-config-exist^does-config-exist
      :_  %=  state
              projects
            ?:  =('' focused-project)  projects
            ?~  thread-queue           projects
            %+  ~(jab by projects)     focused-project
            |=  =project:zig
            project(saved-thread-queue thread-queue)
          ==
      :+  %-  ~(poke-self pass:io /self-wire)
          :-  %ziggurat-action
          !>  ^-  action:zig
          :^  project-name.act  desk-name.act  request-id.act
          :+  %queue-thread
            (cat 3 'ziggurat-configuration-' desk-name.act)
          ?:  =(!>(~) special-configuration-args.act)
            !>(`[project-name desk-name request-id]:act)
          ;:  slop
              !>(~)
              !>(project-name.act)
              !>(desk-name.act)
              !>(request-id.act)
              special-configuration-args.act
          ==
        %-  ~(poke-self pass:io /self-wire)
        :-  %ziggurat-action
        !>  ^-  action:zig
        :^  project-name.act  desk-name.act  request-id.act
        [%run-queue ~]
      ~
      :: %-  %~  arvo  pass:io
      ::     :+  %setup-desk  `@`does-config-exist
      ::     /[project-name.act]/[desk-name.act]
      :: :-  %k
      :: ?:  does-config-exist
      ::   :^  %fard  desk-name.act
      ::     (cat 3 'ziggurat-configuration-' desk-name.act)
      ::   :-  %noun
      ::   %+  slop  !>(~)
      ::   ?:  =(!>(~) special-configuration-args.act)
      ::     configuration-args
      ::   %+  slop  configuration-args
      ::   special-configuration-args.act
      :: :+  %lard  q.byk.bowl
      :: %:  setup-desk:zig-threads
      ::     project-name.act
      ::     desk-name.act
      ::     request-id.act
      ::     config=~
      ::     state-views=~
      ::     whos=default-ships:zig-lib
      ::     install=%.n
      ::     start-apps=~
      :: ==
    ::
        %delete-project
      ::  should show a warning on frontend before performing this one ;)
      `state(projects (~(del by projects) project-name.act))
    ::
        %cis-panic  :: we handle this above, not here. ignore
      ~^state
    ::
        %save-config-to-file
      !!
      :: ::  frontend should warn about overwriting
      :: =/  file-text=@t
      ::   %+  make-configs-file:zig-lib  ~
      ::   %+  build-default-configuration:zig-lib
      ::   (~(got by configs) project-name.act)  desk-name.act
      :: =/  file-path=path  /zig/configs/[project-name.act]/hoon
      :: :_  state
      :: :+  %^  make-save-file:zig-lib  update-info
      ::     file-path  file-text
      ::   %-  make-read-desk:zig-lib
      ::   [project-name desk-name request-id]:act
      :: ~
    ::
        %add-sync-desk-vships
      !!
      :: =*  project-name  project-name.act
      :: =*  desk-name     desk-name.act
      :: =*  ships         ships.act
      :: =*  install       install.act
      :: =*  start-apps    start-apps.act
      :: =^  cards  state
      ::   %-  handle-poke
      ::   :^  project-name  desk-name  request-id.act
      ::   [%read-desk ~]
      :: =.  status
      ::   :-  %commit-install-starting
      ::   (make-cis-running:zig-lib ships desk-name)
      :: :_  %=  state
      ::         sync-desk-to-vship
      ::       %-  ~(gas ju sync-desk-to-vship)
      ::       %+  turn  ships
      ::       |=(who=@p [desk-name who])
      ::     ==
      :: :-  %-  update-vase-to-card:zig-lib
      ::     %.  status
      ::     %~  status  make-update-vase:zig-lib
      ::     update-info
      :: |-
      :: ?~  ships.act  cards
      :: =*  who   i.ships
      :: =/  cis-cards=(list card)
      ::   :_  ~
      ::   %+  cis-thread:zig-lib
      ::     /cis-done/(scot %p who)/[project-name]/[desk-name]
      ::   [who desk-name install start-apps status]
      :: %=  $
      ::     ships.act  t.ships.act
      ::     cards      (weld cards cis-cards)
      :: ==
    ::
        %delete-sync-desk-vships
      :-  :_  ~
          %-  make-cancel-watch-for-file-changes:zig-lib
          [project-name desk-name]:act
      %=  state
          sync-desk-to-vship
        |-
        ?~  ships.act  sync-desk-to-vship
        %=  $
            ships.act  t.ships.act
        ::
            sync-desk-to-vship
          %-  ~(del ju sync-desk-to-vship)
          [project-name i.ships]:act
        ==
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
      =/  old=@t  focused-project
      =*  new=@t  project-name.act
      =/  old-project=project:zig  (~(got by projects) old)
      =/  new-project=project:zig  (~(got by projects) new)
      =/  old-snap-path=path
        /[new]/(scot %da now.bowl)
      =*  new-snap-path  most-recent-snap.new-project
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
      :+  %+  ~(poke-our pass:io /pyro-wire)  %pyro
          :-  %pyro-action
          !>  ^-  action:pyro
          :+  %snap-ships  old-snap-path
          pyro-ships.old-project
        %+  ~(poke-our pass:io /pyro-wire)  %pyro
        :-  %pyro-action
        !>  ^-  action:pyro
        [%restore-snap new-snap-path]
      ~
    ::
        %add-project-desk
      !!
      :: =/  add-project-desk-error
      ::   %~  add-project-desk  make-error-vase:zig-lib
      ::   [update-info %error]
      :: ?.  =(focused-project project-name.act)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %-  add-project-desk-error
      ::   %-  crip
      ::   ;:  weld
      ::       "focused-project ({<`@tas`focused-project>})"
      ::       " must be same as project-name"
      ::       " ({<`@tas`project-name.act>}); retry after"
      ::       " %change-focus"
      ::   ==
      :: =/  =project:zig  (~(got by projects) project-name.act)
      :: ?:  (has-desk:zig-lib project desk-name.act)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %-  add-project-desk-error(level %warning)
      ::   %-  crip
      ::   %+  weld  "project {<`@tas`project-name.act>}"
      ::   " already has desk {<`@tas`desk-name.act>}"
      :: =*  desk-names-scry-path
      ::   /(scot %p our.bowl)//(scot %da now.bowl)
      :: =+  .^(desk-names=(set @t) %cd desk-names-scry-path)
      :: ?.  (~(has in desk-names) desk-name.act)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %-  add-project-desk-error
      ::   (crip "desk {<`@tas`desk-name.act>} does not exist")
      :: =.  desks.project
      ::   ?~  index.act
      ::     (snoc desks.project [desk-name.act *desk:zig])
      ::   %^  into  desks.project  u.index.act
      ::   [desk-name.act *desk:zig]
      :: (update-project-from-desk-change update-info project)
    ::
        %delete-project-desk
      !!
      :: =/  delete-project-desk-error
      ::   %~  delete-project-desk  make-error-vase:zig-lib
      ::   [update-info %error]
      :: ?.  =(focused-project project-name.act)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %-  delete-project-desk-error(level %warning)
      ::   %-  crip
      ::   ;:  weld
      ::       "focused-project ({<`@tas`focused-project>})"
      ::       " must be same as project-name"
      ::       " ({<`@tas`project-name.act>}); retry after"
      ::       " %change-focus"
      ::   ==
      :: =/  =project:zig  (~(got by projects) project-name.act)
      :: ?.  (has-desk:zig-lib project desk-name.act)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %-  delete-project-desk-error(level %warning)
      ::   %-  crip
      ::   %+  weld  "project {<`@tas`project-name.act>}"
      ::   " doesn't have desk {<`@tas`desk-name.act>}"
      :: =.  project  (del-desk:zig-lib project desk-name.act)
      :: (update-project-from-desk-change update-info project)
    ::
        %save-file
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =.  project
        %^  put-desk:zig-lib  project  desk-name.act
        desk(user-files (~(put in user-files.desk) file.act))
      :-  :_  ~
          (make-save-file:zig-lib update-info [file text]:act)
      state(projects (~(put by projects) project-name.act project))
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
        %register-contract-for-compilation
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
          %-  make-compile-contracts:zig-lib
          [project-name desk-name request-id]:act
      state(projects (~(put by projects) project-name.act project))
    ::
        %unregister-contract-for-compilation
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
        %deploy-contract
      !!
      :: =/  =project:zig  (~(got by projects) project-name.act)
      :: =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      :: =/  add-test-error
      ::   %~  add-test  make-error-vase:zig-lib
      ::   [update-info %error]
      :: =/  who=(unit @p)
      ::   %^  town-id-to-sequencer-host:zig-lib  project-name.act
      ::   town-id.act  configs
      :: ?~  who
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %+  add-test-error  0x0
      ::   %-  crip
      ::   %+  weld  "could not find host for town-id"
      ::   " {<town-id.act>} amongst {<configs>}"
      :: =/  address=@ux
      ::   (~(got bi:mip configs) 'global' [u.who %address])
      :: =/  test-name=@tas  `@tas`(rap 3 %deploy path.act)
      :: =/  imports=(list [@tas path])
      ::   :^    [%indexer /sur/zig/indexer]
      ::       [%zig /sur/zig/ziggurat]
      ::     [%mip /lib/mip]
      ::   ~
      :: =^  subject=(each vase @t)  state
      ::   %-  compile-imports:zig-lib
      ::   :^  project-name.act  desk-name.act  imports  state
      :: ?:  ?=(%| -.subject)
      ::   :_  state
      ::   :_  ~
      ::   %-  update-vase-to-card:zig-lib
      ::   %+  add-test-error  0x0
      ::   %^  cat  3  'compilation of imports failed:\0a'
      ::   p.subject
      :: =*  service-host  ~nec  ::  TODO: remove hardcode
      :: =.  path.act
      ::   ?+    (rear path.act)  !!  ::  TODO: error handle
      ::       %jam   path.act
      ::       %hoon
      ::     %-  need  ::  TODO: error handle
      ::     (convert-contract-hoon-to-jam:zig-lib path.act)
      ::   ==
      :: =/  =test:zig
      ::   :*  `test-name
      ::       ~
      ::       (~(gas by *imports:zig) imports)
      ::       subject
      ::       ~
      ::   ::
      ::       :_  ~
      ::       :-  %custom-write
      ::       :^  %send-wallet-transaction  ~
      ::         %-  crip
      ::         %-  noah
      ::         !>  ^-  [@p @p test-write-step:zig]
      ::         :+  u.who  service-host
      ::         :-  %custom-write
      ::         :^  %deploy-contract  ~
      ::           %-  crip
      ::           "[{<u.who>} {<service-host>} {<path.act>} %.n ~]"
      ::         ~
      ::       ~
      ::   ::
      ::       ~
      ::   ==
      :: =^  cards=(list card)  test
      ::   %^  add-custom-step:zig-lib  test  project-name.act
      ::   :^  desk-name.act  %deploy-contract
      ::     /zig/custom-step-definitions/deploy-contract/hoon
      ::   request-id.act
      :: =/  all-cards=(list card)  cards
      :: =^  cards=(list card)  test
      ::   %^  add-custom-step:zig-lib  test  project-name.act
      ::   :^  desk-name.act  %send-wallet-transaction
      ::     /zig/custom-step-definitions/send-wallet-transaction/hoon
      ::   request-id.act
      :: =/  test-id=@ux  `@ux`(sham test)
      :: =.  tests.desk  (~(put by tests.desk) test-id test)
      :: =.  test-queue
      ::   %^  ~(put to test-queue)  project-name.act
      ::   desk-name.act  test-id
      :: :_  %=  state
      ::         projects
      ::       %+  ~(put by projects)  project-name.act
      ::       (put-desk:zig-lib project desk-name.act desk)
      ::     ==
      :: :-  %-  %~  arvo  pass:io
      ::         :+  %delete-test  project-name.act
      ::         /[desk-name.act]/(scot %ux test-id)
      ::     :^  %k  %lard  q.byk.bowl
      ::     =/  m  (strand ,vase)
      ::     ^-  form:m
      ::     ;<  ~  bind:m
      ::       %^  watch-our:strandio  /updates  %ziggurat
      ::       /project
      ::     |-
      ::     ;<  update-cage=cage  bind:m
      ::       (take-fact:strandio /updates)
      ::     ?.  ?=(%ziggurat-update -.update-cage)  $
      ::     =+  !<(=update:zig q.update-cage)
      ::     ?~  update                              $
      ::     ?.  ?=(%test-results -.update)          $
      ::     ?.  =(test-id test-id.update)           $
      ::     (pure:m !>(`?`-.payload.update))
      :: ^-  (list card)
      :: :^    %-  make-run-queue:zig-lib
      ::       [project-name desk-name request-id]:act
      ::     %-  update-vase-to-card:zig-lib
      ::     %.  test-queue
      ::     ~(test-queue make-update-vase:zig-lib update-info)
      ::   %-  update-vase-to-card:zig-lib
      ::   %.  [test test-id]
      ::   %~  add-test  make-update-vase:zig-lib
      ::   update-info
      :: (weld cards all-cards)
    ::
        %compile-contracts
      ::  for internal use
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig  (got-desk:zig-lib project desk-name.act)
      =/  compile-contract-error
        %~  compile-contract  make-error-vase:zig-lib
        [update-info %error]
      =/  build-results=(list (pair path build-result:zig))
        %^  build-contract-projects:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[project-name.act]/(scot %da now.bowl)
        to-compile.desk
      =/  error-cards=(list card)
        %+  murn  build-results
        |=  [p=path =build-result:zig]
        ?:  ?=(%& -.build-result)  ~
        :-  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "contract compilation failed at"
            "{<`path`p>} with error:\0a"
            (trip p.build-result)
        ==
      =/  [cards=(list card) errors=(list [path @t])]
        %+  save-compiled-contracts:zig-lib  desk-name.act
        build-results
      :_  state
      :_  (weld cards error-cards)
      %-  make-read-desk:zig-lib
      [project-name desk-name request-id]:act
    ::
        %compile-contract
      ::  for internal use
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  compile-contract-error
        %~  compile-contract  make-error-vase:zig-lib
        [update-info %error]
      ?~  path.act
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        'contract path must not be empty'
      ::
      =/  =build-result:zig
        %^  build-contract-project:zig-lib  smart-lib-vase
          /(scot %p our.bowl)/[project-name.act]/(scot %da now.bowl)
        path.act
      ?:  ?=(%| -.build-result)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "contract compilation failed at"
            "{<`path`path.act>} with error:\0a"
            (trip p.build-result)
        ==
      ::
      =/  save-result=(each card (pair path @t))
        %^  save-compiled-contract:zig-lib  desk-name.act
        path.act  build-result
      ?:  ?=(%| -.save-result)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  compile-contract-error
        %-  crip
        ;:  weld
            "failed to save newly compiled contract"
            " {<`path`p.p.save-result>} with error:\0a"
            (trip q.p.save-result)
        ==
      ::
      :_  state
      :+  p.save-result
        %-  make-read-desk:zig-lib
        [project-name desk-name request-id]:act
      ~
    ::
        %read-desk
      ::  for internal use -- app calls itself to scry clay
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  =desk:zig
        (gut-desk:zig-lib project desk-name.act *desk:zig)
      =.  dir.desk
        =-  .^((list path) %ct -)
        /(scot %p our.bowl)/(scot %tas desk-name.act)/(scot %da now.bowl)
      :_  %=  state
              projects
            %+  ~(put by projects)  project-name.act
            (put-desk:zig-lib project desk-name.act desk)
          ==
      :+  %-  make-watch-for-file-changes:zig-lib
          [project-name desk-name]:act
        %-  update-vase-to-card:zig-lib
        %.  dir.desk
        %~  dir  make-update-vase:zig-lib
        update-info
      ~
    ::
        %queue-thread
      =.  thread-queue
        %-  ~(put to thread-queue)
        [project-name desk-name thread-name thread-args]:act
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  thread-queue
      ~(thread-queue make-update-vase:zig-lib update-info)
    ::
        %run-queue
      =/  run-queue-error
        %~  run-queue  make-error-vase:zig-lib
        [update-info %error]
      =/  s=status:zig  status  ::  TODO: remove this hack
      ?-    -.s
          %changing-project-desks   !!
          %commit-install-starting  !!
          %uninitialized
        =/  top=(unit thread-queue-item:zig)
          ~(top to thread-queue)
        ?:  ?&  ?=(^ top)
                =('zig' project-name.u.top)
                ?=(%zig desk-name.u.top)
                ?=(%ziggurat-configuration-zig thread-name.u.top)
            ==
          =.  status  [%ready ~]
          $
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %warning)
        'must run %start-pyro-ships before threads'
      ::
          %running-thread
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  run-queue-error(level %info)
        'queue already running'
      ::
          %ready
        ?:  =(~ thread-queue)
          :_  state
          :_  ~
          %-  update-vase-to-card:zig-lib
          %-  run-queue-error(level %warning)
          'no threads in queue'
        ~&  %z^%run-queue^%ready
        =^  top=thread-queue-item:zig  thread-queue
          ~(get to thread-queue)
        =*  next-project-name  project-name.top
        =*  next-desk-name     desk-name.top
        =*  next-thread-name   thread-name.top
        =*  next-thread-args   thread-args.top
        =.  status  [%running-thread ~]
        :_  state
        :_  ~
        %-  %~  arvo  pass:io
            ^-  path
            :^  %thread-result  next-project-name
            next-desk-name  /[next-thread-name]
        :^  %k  %fard  desk-name.act
        :-  next-thread-name
        [%noun next-thread-args]
        ::  TODO: status, etc updates
        :: =/  =project:zig  (~(got by projects) next-project-name)
        :: =/  =desk:zig  (got-desk:zig-lib project next-desk-name)
        :: =/  =test:zig  (~(got by tests.desk) next-test-id)
        :: ?:  ?=(%| -.subject.test)
        ::   :_  state
        ::   :_  ~
        ::   %-  update-vase-to-card:zig-lib
        ::   %-  run-queue-error
        ::   'test subject must compile before test can be run'
        :: =/  tid=@ta
        ::   %+  rap  3
        ::   :~  'ted-'
        ::       next-project-name
        ::       '-'
        ::       ?^(name.test u.name.test (scot %ux next-test-id))
        ::       '-'
        ::       (scot %uw (sham eny.bowl))
        ::   ==
        :: =/  =start-args:spider
        ::   :-  ~
        ::   :^  `tid  byk.bowl(r da+now.bowl)
        ::     %ziggurat-test-run
        ::   !>  ^-  (unit [@t @tas @ux test-steps:zig vase (list @p)])
        ::   :*  ~
        ::       next-project-name
        ::       next-desk-name
        ::       next-test-id
        ::       steps.test
        ::       p.subject.test
        ::       default-ships:zig-lib  :: TODO: remove hardcode and allow input of for-snapshot
        ::   ==
        :: =/  w=wire
        ::   :^  %test  next-project-name  next-desk-name
        ::   /(scot %ux next-test-id)/[tid]
        :: =.  status  [%running-test-steps ~]
        :: :_  state
        :: :-  %-  update-vase-to-card:zig-lib
        ::     %.  status
        ::     %~  status  make-update-vase:zig-lib
        ::     update-info
        :: :^    %-  update-vase-to-card:zig-lib
        ::       %.  test-queue
        ::       %~  test-queue  make-update-vase:zig-lib
        ::       update-info
        ::     %+  ~(watch-our pass:io w)  %spider
        ::     /thread-result/[tid]
        ::   %+  ~(poke-our pass:io w)  %spider
        ::   [%spider-start !>(start-args)]
        :: ~
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
      =.  pyro-ships.project
        (weld pyro-ships.project ships.act)
      =.  projects
        (~(put by projects) project-name.act project)
      :_  state
      %+  turn  ships.act
      |=  who=@p
      %+  ~(poke-our pass:io /self-wire)  %pyro
      [%pyro-action !>([%init-ship who])]
    ::
        %start-pyro-snap  !!  ::  TODO
    ::
        %take-snapshot
      =/  =project:zig  (~(got by projects) project-name.act)
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
        %publish-app  :: TODO
      ::  [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::  should assert that desk.bill contains only our agent name,
      ::  and that clause has been filled out at least partially,
      ::  then poke treaty agent with publish
      =/  =project:zig  (~(got by projects) project-name.act)
      =/  bill
        ;;  (list @tas)
        .^(* %cx /(scot %p our.bowl)/(scot %tas desk-name.act)/(scot %da now.bowl)/desk/bill)
      ~|  "desk.bill should only contain our agent"
      ?>  =(bill ~[project-name.act])
      =/  docket-0
        :*  %1
            'Foo'
            'An app that does a thing.'
            0xf9.8e40
            [%glob `@tas`project-name.act [0v0 [%ames our.bowl]]]
            `'https://example.com/tile.svg'
            [0 0 1]
            'https://example.com'
            'MIT'
        ==
      =/  docket-task
        [%info `@tas`project-name.act %& [/desk/docket-0 %ins %docket-0 !>(docket-0)]~]
      :_  state
      :^    (~(arvo pass:io /save-wire) %c [docket-task])
          %-  make-compile-contracts:zig-lib
          [project-name desk-name request-id]:act
        %+  ~(poke-our pass:io /treaty-wire)  %treaty
        [%alliance-update-0 !>([%add our.bowl `@tas`project-name.act])]
      ~
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
      (send-pyro-dojo-card:zig-lib [who command]:act)^~
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
              /pyro/[now]/i/[who]/gu/[who]/[app]/[now]/noun
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
      =^  subject=(each vase @t)  state
        %-  compile-imports:zig-lib
        :^  project-name.act  desk-name.act
        ~(tap by imports.act)  state
      ?:  ?=(%| -.subject)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %^  cat  3  'compilation of imports failed:\0a'
        p.subject
      =.  p.subject
        (slop agent-state (slop !>(bowl=bowl) p.subject))
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      ::  %shown-pyro-agent-state over %pyro-agent-state
      ::   because there are casts deep in vanes that don't
      ::   take too kindly to vases within vases
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  [(show-state:zig-lib modified-state) wex sup]
      %~  shown-pyro-agent-state  make-update-vase:zig-lib
      update-info
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
      =^  subject=(each vase @t)  state
        %-  compile-imports:zig-lib
        :^  project-name.act  desk-name.act
        ~(tap by imports.act)  state
      ?:  ?=(%| -.subject)
        :_  state
        :_  ~
        %-  update-vase-to-card:zig-lib
        %-  state-error
        %^  cat  3  'compilation of imports failed:\0a'
        p.subject
      =.  p.subject
        (slop !>(p.chain-state) (slop !>(bowl=bowl) p.subject))
      =/  modified-state=vase
        (slap p.subject (loud-ream:zig-lib grab.act /))
      :_  state
      :_  ~
      %-  update-vase-to-card:zig-lib
      %.  (show-state:zig-lib modified-state)
      %~  shown-pyro-chain-state  make-update-vase:zig-lib
      update-info
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
        %suspend-uninstall-to-make-dev-desk
      :_  state
      :^    (suspend-desk:zig-lib desk-name.act)
          (uninstall-desk:zig-lib desk-name.act)
        %-  update-vase-to-card:zig-lib
        %.  'suspending and unsyncing dev desk'
        %~  suspend-uninstall-to-make-dev-desk
        make-error-vase:zig-lib  [update-info %warning]
      ~
    ==
  --
::
++  on-agent
  |=  [w=wire =sign:agent:gall]
  ^-  (quip card _this)
  (on-agent:def w sign)
::
++  on-arvo
  |=  [w=wire =sign-arvo:agent:gall]
  ^-  (quip card _this)
  ?+    w  (on-arvo:def w sign-arvo)
      [%new-project-from-remote @ ~]  `this
      :: [%new-project-uninstall @ ~]    `this
  ::
    ::   [%setup-desk @ @ @ ~]
    :: =*  does-config-exist  `?`i.t.w
    :: =*  project-name       i.t.t.w
    :: =*  desk-name          i.t.t.t.w
    :: ?.  ?&  ?=(%khan -.sign-arvo)
    ::         ?=(%arow -.+.sign-arvo)
    ::     ==
    ::   (on-arvo:def w sign-arvo)
    :: ?:  ?=(%| -.p.+.sign-arvo)
    ::   ~&  (reformat-compiler-error:zig-lib p.p.+.sign-arvo)
    ::   !!  :: TODO
    :: =/  snap-path=path
    ::   ?:  ?=(%zig desk-name)  default-snap-path:zig-lib
    ::   /[project-name]/(scot %da now.bowl)
    :: =.  status  [%ready ~]
    :: :_  this(status status)
    :: :+  %-  ~(poke-self pass:io /self-wire)
    ::     :-  %ziggurat-action
    ::     !>  ^-  action:zig
    ::     :^  project-name  desk-name  ~
    ::     [%take-snapshot `snap-path]
    ::   %-  update-vase-to-card:zig-lib
    ::   %.  status
    ::   %~  status  make-update-vase:zig-lib
    ::   [project-name desk-name %setup-desk ~]
    :: ~
  ::
      [%thread-result @ @ @ ~]
    =*  project-name  i.t.w
    =*  desk-name     i.t.t.w
    =*  thread-name   i.t.t.t.w
    ?.  ?&  ?=(%khan -.sign-arvo)
            ?=(%arow -.+.sign-arvo)
        ==
      (on-arvo:def w sign-arvo)
    =.  status  [%ready ~]
    ?:  ?=(%| -.p.+.sign-arvo)
      ~&  (reformat-compiler-error:zig-lib p.p.+.sign-arvo)
      `this(status status)
    =/  cards=(list card)
      ?.  ?=(%ziggurat-configuration (end [3 22] thread-name))
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
      [%on-init-zig-setup ~]
    =*  our  (scot %p our.bowl)
    =*  now  (scot %da now.bowl)
    ~&  %z^%on-init-zig-setup
    :_  this
    ?:  .^(? %gu /[our]/subscriber/[now])  ~
    :_  ~
    %-  ~(poke-self pass:io /self-wire)
    :-  %ziggurat-action
    !>(`action:zig`['zig' %zig ~ %new-project ~ ~ !>(~)])
  ::
    ::   [%on-new-project-ship-rerun @ @ ~]
    :: =*  mark           i.t.w
    :: =*  jammed-action  i.t.t.w
    :: :_  this
    :: :_  ~
    :: %+  ~(poke-self pass:io /self-wire)
    :: mark  !>(;;(action:zig (cue jammed-action)))
  ::
      [%merge-wire @ @ ~]
    ?>  ?=([%clay %mere *] sign-arvo)
    ?:  -.p.+.sign-arvo
      =*  desk-name  i.t.w
      =*  jammed-sync-ships  i.t.t.w
      =/  sync-ships=(list @p)
        ;;  (list @p)  (cue (slav %ud jammed-sync-ships))
        :_  this
        %+  turn  sync-ships
        |=  who=@p
        %+  sync-desk-to-virtualship-card:zig-lib  who
        desk-name
    ~&  >>>  "failed to make new desk"
    `this
  ::
      [%get-dev-desk @ ~]
    ?:  ?=([%clay %mere %.y ~] sign-arvo)  `this
    :_  this
    :_  ~
    %-  update-vase-to-card:zig-lib
    %.  (crip "merge fail: {<sign-arvo>}")
    %~  get-dev-desk  make-error-vase:zig-lib
    [['' i.t.w %get-dev-desk ~] %error]
  ::
      [%clay @ @ ~]
    ?>  ?=([%clay %writ *] sign-arvo)
    =*  project-name  i.t.w
    =*  desk-name     i.t.t.w
    =/  =project:zig  (~(got by projects) project-name)
    =/  =desk:zig  (got-desk:zig-lib project desk-name)
    ?~  p.sign-arvo
      :_  this
      :_  ~
      %+  make-watch-for-file-changes:zig-lib  project-name
      desk-name
    =/  updated-files=(set path)
      =+  !<(=dome:clay q.r.u.p.sign-arvo)
      =/  =tako:clay  (~(got by hit.dome) let.dome)
      =+  .^  =yaki:clay
              %cs
              %+  weld  /(scot %p our.bowl)/[desk-name]
              /(scot %da now.bowl)/yaki/(scot %uv tako)
          ==
      ~(key by q.yaki)
    :: |^
    :: =^  cards  state  update-tests-from-file
    :_  this
    :-  ?:  .=  0
            %~  wyt  in
            (~(int in updated-files) to-compile.desk)
          (make-read-desk:zig-lib project-name desk-name ~)
        %^  make-compile-contracts:zig-lib  project-name
        desk-name  ~
    :: %-  weld  :_  cards
    %+  turn
      %~  tap  in
      (~(get ju sync-desk-to-vship) desk-name)
    |=  who=@p
    (sync-desk-to-virtualship-card:zig-lib who desk-name)
    :: ::
    :: ::  check if any test-steps loaded from file were
    :: ::   updated; if yes, reload them under same id.
    :: ::   however, this only will update if the test-steps
    :: ::   file itself is updated, not any of its dependencies.
    :: ::   TODO: replace with a more full-featured dependency
    :: ::   rebuilding/updating system
    :: ++  update-tests-from-file
    ::   ^-  (quip card _state)
    ::   %+  roll  ~(tap by projects)
    ::   |:  :-  [project-name=`@t`'' project=`project:zig`*project:zig]
    ::       [outer-cards=`(list card)`~ outer-state=`_state`state]
    ::   =;  [=tests:zig inner-cards=(list card) inner-state=_state]
    ::     :-  (weld outer-cards inner-cards)
    ::     %=  inner-state
    ::         projects
    ::       %+  ~(put by projects)  project-name
    ::       %^  put-desk:zig-lib  project  desk-name
    ::       desk(tests tests)
    ::     ==
    ::   %+  roll  ~(tap by tests.desk)
    ::   |:  :-  [test-id=`@ux`0x0 test=`test:zig`*test:zig]
    ::       :+  tests=`tests:zig`tests.desk
    ::         inner-cards=`(list card)`~
    ::       inner-state=`_state`outer-state
    ::   ?.  (~(has in updated-files) test-steps-file.test)
    ::     [tests inner-cards inner-state]
    ::   =^  result  inner-state
    ::     %-  read-test-file:zig-lib
    ::     :^  project-name  desk-name  test-steps-file.test
    ::     inner-state
    ::   ?:  ?=(%| -.result)
    ::     :+  tests
    ::       :_  inner-cards
    ::       %-  update-vase-to-card:zig-lib
    ::       %.  p.result
    ::       %~  sync-desk-to-vship  make-error-vase:zig-lib
    ::       [[project-name desk-name %clay-sync ~] %error]
    ::     inner-state
    ::   :_  [inner-cards inner-state]
    ::   %+  ~(put by tests)  test-id
    ::   %=  test
    ::       subject       [%& q.p.result]
    ::       steps         r.p.result
    ::       imports
    ::     (~(gas in *imports:zig) p.p.result)
    ::   ==
    :: --
  ::
    ::   [%cis-done @ @ @ ~]
    :: ?.  ?&  ?=(%khan -.sign-arvo)
    ::         ?=(%arow -.+.sign-arvo)
    ::     ==
    ::   (on-arvo:def w sign-arvo)
    :: ?:  ?=(%| -.p.+.sign-arvo)
    ::   ~&  (reformat-compiler-error:zig-lib p.p.+.sign-arvo)
    ::   !!  :: TODO
    :: =*  project-name  i.t.t.w
    :: =*  desk-name     i.t.t.t.w
    :: =*  cage          p.p.+.sign-arvo
    :: =.  status        !<(status:zig q.cage)
    :: ?.  ?|  ?&  ?=(%commit-install-starting -.status)
    ::             (is-cis-done cis-running.status)
    ::         ==
    ::     ::
    ::         ?&  ?=(%changing-project-desks -.status)
    ::             (is-cpd-done project-cis-running.status)
    ::         ==
    ::     ==
    ::   :_  this
    ::   :_  ~
    ::   %^  make-status-card:zig-lib  status  project-name
    ::   desk-name
    :: =/  new-status=status:zig  [%ready ~]
    :: :_  this(status new-status)
    :: (make-done-cards:zig-lib status project-name desk-name)
  ::
    ::   [%delete-test @ @ @ ~]
    :: ?.  ?&  ?=(%khan -.sign-arvo)
    ::         ?=(%arow -.+.sign-arvo)
    ::         ?=(%& -.p.+.sign-arvo)
    ::     ==
    ::   (on-arvo:def w sign-arvo)
    :: =*  project-name  i.t.w
    :: =*  desk-name     i.t.t.w
    :: =*  test-id=@ux   (slav %ux i.t.t.t.w)
    :: :_  this
    :: ~[(make-delete-test:zig-lib test-id project-name desk-name ~)]
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
    :^  ~  ~  %ziggurat-update
    %.  sync-desk-to-vship
    %~  sync-desk-to-vship  make-update-vase:zig-lib
    ['' %$ %sync-desk-to-vship ~]
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
      [%state-views @ ~]
    !!
    :: =*  desk-name     i.t.t.p
    :: =*  update-info  ['' desk-name %state-views ~]
    :: =/  [[* cfo=(unit configuration-file-output:zig)] *]
    ::   (load-configuration-file:zig-lib update-info state)
    :: :^  ~  ~  %json
    :: !>  ^-  json
    :: ?~  cfo  ~
    :: %-  update:enjs:zig-lib
    :: !<  update:zig
    :: %.  state-views.u.cfo
    :: %~  state-views  make-update-vase:zig-lib  update-info
  ::
      [%file-exists @ ^]
    =/  des=@ta    i.t.t.p
    =/  pat=path  `path`t.t.t.p
    =/  pre=path  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    ``json+!>(`json`[%b .^(? %cu (weld pre pat))])
  ::
      [%thread-queue ~]
    ``noun+!>(thread-queue)
  ::
  ::  APP-PROJECT JSON
  ::
      [%read-file @ ^]
    =/  des=@ta    i.t.t.p
    =/  pat=path  `path`t.t.t.p
    =/  pre  /(scot %p our.bowl)/(scot %tas des)/(scot %da now.bowl)
    =/  padh  (weld pre pat)
    =/  =mark  (rear pat)
    :^  ~  ~  %json  !>
    ^-  json
    :-  %s
    ?+    mark  =-  q.q.-
        !<(mime (.^(tube:clay %cc (weld pre /[mark]/mime)) .^(vase %cr padh)))
      %hoon    .^(@t %cx padh)
      %kelvin  (crip ~(ram re (cain !>(.^([@tas @ud] %cx padh)))))
      %ship    (crip ~(ram re (cain !>(.^(@p %cx padh)))))
      %bill    (crip ~(ram re (cain !>(.^((list @tas) %cx padh)))))
        %docket-0
      =-  (crip (spit-docket:mime:dock -))
      .^(docket:dock %cx padh)
    ==
  ::
      [%read-desks ~]
    =/  pat  /(scot %p our.bowl)//(scot %da now.bowl)
    :^  ~  ~  %json  !>
    ^-  json
    =/  desks  .^((set @t) %cd pat)
    (set-cords:enjs:zig-lib desks)
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
