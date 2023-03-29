/-  spider,
    pyro=zig-pyro,
    wallet=zig-wallet,
    zig=zig-ziggurat
/+  strandio,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart,
    zig-lib=zig-ziggurat
::
=*  strand         strand:spider
=*  get-bowl       get-bowl:strandio
=*  get-time       get-time:strandio
=*  poke-our       poke-our:strandio
=*  scry           scry:strandio
=*  send-raw-card  send-raw-card:strandio
=*  sleep          sleep:strandio
=*  take-poke-ack  take-poke-ack:strandio
=*  wait           wait:strandio
::
|_  $:  project-name=@t
        desk-name=@tas
        ship-to-address=(map @p @ux)
    ==
++  send-discrete-pyro-dojo
  |=  [project-name=@t who=@p payload=@t]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  empty-vase=vase  bind:m  (send-pyro-dojo who payload)
  ::  ensure %pyro dojo send has completed before moving on
  ;<  ~  bind:m  (block-on-previous-operation `project-name)
  (pure:m !>(~))
::
++  send-pyro-dojo
  |=  [who=@p payload=@t]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  ~  bind:m  (dojo:pyro-lib who (trip payload))
  (pure:m !>(~))
::
++  send-pyro-scry
  |*  [who=@p =mold care=@tas app=@tas =path]
  =/  m  (strand ,mold)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  =*  w    (scot %p who)
  =*  now  (scot %da now.bowl)
  %+  scry  mold
  (weld /gx/pyro/i/[w]/[care]/[w]/[app]/[now] path)
::
++  send-pyro-scry-with-expectation
  |=  [who=@p =mold care=@tas app=@tas =path expected=*]
  =/  m  (strand ,[mold ?])
  ^-  form:m
  ;<  result=mold  bind:m
    (send-pyro-scry who mold care app path)
  (pure:m [result =(expected result)])
::
:: ++  read-pyro-subscription  ::  TODO
::   |=  [payload=read-sub-payload:zig expected=@t]
::   =/  m  (strand ,vase)
::   ;<  =bowl:strand  bind:m  get-bowl
::   =/  now=@ta  (scot %da now.bowl)
::   =/  scry-noun=*
::     .^  *
::         %gx
::         ;:  weld
::           /(scot %p our.bowl)/pyro/[now]/i/(scot %p who.payload)/gx
::           /(scot %p who.payload)/subscriber/[now]
::           /facts/(scot %p to.payload)/[app.payload]
::           path.payload
::           /noun
::         ==
::     ==
::   =+  ;;(fact-set=(set @t) scry-noun)
::   ?:  (~(has in fact-set) expected)  (pure:m !>(expected))
::   (pure:m !>((crip (noah !>(~(tap in fact-set))))))
:: ::
:: ++  send-pyro-subscription
::   |=  payload=sub-payload:zig
::   =/  m  (strand ,~)
::   ^-  form:m
::   ;<  ~  bind:m  (subscribe:pyro-lib payload)
::   (pure:m ~)
::
++  send-discrete-pyro-poke
  |=  $:  project-name=@t
          who=@p
          to=@p
          app=@tas
          mark=@tas
          payload=vase
      ==
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  empty-vase=vase  bind:m  (send-pyro-poke who to app mark payload)
  ::  ensure %pyro poke send has completed before moving on
  ;<  ~  bind:m  (block-on-previous-operation `project-name)
  (pure:m !>(~))
::
++  send-pyro-poke
  |=  [who=@p to=@p app=@tas mark=@tas payload=vase]
  =/  m  (strand ,vase)
  ^-  form:m
  ::  if mark is not found poke will fail
  ;<  =bowl:strand  bind:m  get-bowl
  |^
  ?:  is-mar-found
    ::  found mark: proceed
    ;<  ~  bind:m  (poke:pyro-lib who to app mark q.payload)
    (pure:m !>(~))
  ::  mark not found: warn and attempt to fallback to
  ::   equivalent %dojo step rather than failing outright
  ~&  %ziggurat-test-run^%poke-mark-not-found^mark
  (send-pyro-dojo convert-poke-to-dojo-payload)
  ::
  ++  is-mar-found
    ^-  ?
    =/  our=@ta  (scot %p our.bowl)
    =/  w=@ta  (scot %p who)
    =/  now=@ta  (scot %da now.bowl)
    ?~  desk=(find-desk-running-app app our w now)
      ~&  %ziggurat-test-run^%no-desk-running-app^app
      %.n
    =/  mar-paths=(list path)
      .^  (list path)
          %gx
          %+  weld  /[our]/pyro/[now]/i/[w]/ct
          /[w]/[u.desk]/[now]/mar/file-list
      ==
    =/  mars=(set @tas)
      %-  ~(gas in *(set @tas))
      %+  murn  mar-paths
      |=  p=path
      ?~  p  ~
      [~ `@tas`(rap 3 (join '-' (snip t.p)))]
    (~(has in mars) mark)
  ::
  ++  find-desk-running-app
    |=  [app=@tas our=@ta who=@ta now=@ta]
    ^-  (unit @tas)
    =/  desks-scry=(set @tas)
      .^  (set @tas)
          %gx
          /[our]/pyro/[now]/i/[who]/cd/[who]/base/[now]/noun
      ==
    =/  desks=(list @tas)  ~(tap in desks-scry)
    |-
    ?~  desks  ~
    =*  desk  i.desks
    =/  apps=(set [@tas ?])
      .^  (set [@tas ?])
          %gx
          %+  weld  /[our]/pyro/[now]/i/[who]/ge/[who]/[desk]
          /[now]/apps
      ==
    ?:  %.  app
        %~  has  in
        %-  ~(gas in *(set @tas))
        (turn ~(tap in apps) |=([a=@tas ?] a))
      `desk
    $(desks t.desks)
  ::
  ++  convert-poke-to-dojo-payload
    ^-  [@p @t]
    :-  who
    %+  rap  3
    :~  ':'
        ?:(=(who to) app (rap 3 to '|' app ~))
        ' &'
        mark
        ' '
        (crip (noah payload))
    ==
  --
::
++  take-snapshot
  |=  $:  test-id=(unit @ux)
          step=@ud
          snapshot-ships=(list @p)
      ==
  =/  m  (strand ,~)
  ^-  form:m
  ?~  snapshot-ships  (pure:m ~)
  ;<  ~  bind:m
    %+  poke-our  %pyro
    :-  %pyro-action
    !>  ^-  action:pyro
    :+  %snap-ships
      ?~  test-id  /[project-name]/(scot %ud step)
      /[project-name]/(scot %ux u.test-id)/(scot %ud step)
    snapshot-ships
  (pure:m ~)
::
++  deploy-contract
  |=  $:  who=@p
          contract-jam-path=path
          mutable=?
          publish-contract-id=(unit @ux)  ::  ~ -> 0x1111.1111
      ==
  =/  m  (strand ,vase)
  ^-  form:m
  =/  address=@ux  (~(got by ship-to-address) who)
  ;<  code-atom=@  bind:m
    (scry @ [%cx desk-name contract-jam-path])
  =/  code  [- +]:(cue code-atom)
  |^
  ;<  empty-vase=vase  bind:m
    %-  send-pyro-poke
    :^  who  who  %uqbar
    :-  %wallet-poke 
    !>  ^-  wallet-poke:wallet
        :*  %transaction
            origin=~
            from=address
            contract=pci
            town=town-id
            [%noun %deploy mutable code interface=~]
        ==
  (pure:m !>(`@ux`compute-contract-hash))
  ::
  ++  town-id
    ^-  @ux
    0x0  ::  hardcode
  ::
  ++  pci
    ^-  @ux
    (fall publish-contract-id 0x1111.1111)
  ::
  ++  compute-contract-hash
    ^-  @ux
    %-  hash-pact:smart
    [?.(mutable 0x0 pci) address town-id code]
  --
::
++  send-wallet-transaction
  =/  m  (strand ,vase)
  |=  $:  project-name=@t
          who=@p
          sequencer-host=@p
          gate=vase
          gate-args=*
      ==
  ^-  form:m
  ~&  ship-to-address
  =/  address=@ux  (~(got by ship-to-address) who)
  ;<  old-scry=(map @ux *)  bind:m
    %^  send-pyro-scry  who  (map @ux *)
    :+  %gx  %wallet
    /pending-store/(scot %ux address)/noun/noun
  ::
  ;<  gate-output=vase  bind:m
    !<(form:m (slym gate gate-args))
  ;<  ~  bind:m  (block-on-previous-operation `project-name)
  ::
  ;<  new-scry=(map @ux *)  bind:m
    %^  send-pyro-scry  who  (map @ux *)
    :+  %gx  %wallet
    /pending-store/(scot %ux address)/noun/noun
  ::
  =*  old-pending  ~(key by old-scry)
  =*  new-pending  ~(key by new-scry)
  =/  diff-pending=(list @ux)
    ~(tap in (~(dif in new-pending) old-pending))
  ?.  ?=([@ ~] diff-pending)
    ~&  %ziggurat-threads^%diff-pending-not-length-one^diff-pending
    !!
  ;<  empty-vase=vase  bind:m
    %-  send-discrete-pyro-poke
    :-  project-name
    :^  who  who  %uqbar
    :-  %wallet-poke
    !>  ^-  wallet-poke:wallet
    :^  %submit  from=address  hash=i.diff-pending
    gas=[rate=1 bud=1.000.000]
  ;<  ~  bind:m  (sleep ~s3)  ::  TODO: tune time
  ;<  empty-vase=vase  bind:m
    %^  send-discrete-pyro-dojo  project-name
    sequencer-host  ':sequencer|batch'
  (pure:m gate-output)
::
++  block-on-previous-operation
  =+  done-duration=`@dr`~m1
  |=  project-name=(unit @t)
  |^
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (sleep `@dr`1)
  |-
  ;<  is-stack-empty=?  bind:m  get-is-stack-empty
  ?.  is-stack-empty
    ;<  ~  bind:m  (sleep (div ~s1 4))
    $
  ;<  =bowl:strand  bind:m  get-bowl
  =/  timers=(list [@da duct])
    %+  get-real-and-virtual-timers  project-name
    [our now]:bowl
  ?~  timers  (pure:m ~)
  =*  soonest-timer  -.i.timers
  ?:  (lth (add now.bowl done-duration) soonest-timer)
    (pure:m ~)
  ;<  ~  bind:m  (wait +(soonest-timer))
  $
  ::
  ++  get-is-stack-empty
    =/  m  (strand ,?)
    ^-  form:m
    ::  /i//whey from sys/vane/iris/hoon:386
    ;<  maz=(list mass)  bind:m  (scry (list mass) /i//whey)
    =/  by-id  (snag 2 maz)
    (pure:m ?=(~ p.q.by-id))
  ::
  ++  ignored-virtualship-timer-prefixes
    ^-  (list path)
    :_  ~
    /ames/pump
  ::
  ++  ignored-realship-timer-prefixes
    ^-  (list path)
    :~  /ames/pump
        /eyre/channel
        /eyre/sessions
        /gall/use/eth-watcher
        /gall/use/hark-system-hook
        /gall/use/hark
        /gall/use/notify
        /gall/use/ping
        /gall/use/pyre
    ==
  ::
  ++  filter-timers
    |=  $:  now=@da
            ignored-prefixes=(list path)
            timers=(list [@da duct])
        ==
    ^-  (list [@da duct])
    %+  murn  timers
    |=  [time=@da d=duct]
    ?~  d               `[time d]  ::  ?
    ?:  (gth now time)  ~
    =*  p  i.d
    %+  roll  ignored-prefixes
    |:  [ignored-prefix=`path`/ timer=`(unit [@da duct])``[time d]]
    ?:  =(ignored-prefix (scag (lent ignored-prefix) p))  ~
    timer
  ::
  ++  get-virtualship-timers
    |=  [project-name=(unit @t) our=@p now=@da]
    ^-  (list [@da duct])
    =/  now-ta=@ta  (scot %da now)
    =/  ships=(list @p)
      (get-virtualships-synced-for-project project-name our now)
    %+  roll  ships
    |=  [who=@p all-timers=(list [@da duct])]
    =/  who-ta=@ta  (scot %p who)
    =/  timers=(list [@da duct])
      .^  (list [@da duct])
          %gx
          %+  weld  /(scot %p our)/pyro/[now-ta]/i/[who-ta]
          /bx/[who-ta]//[now-ta]/debug/timers/noun
      ==
    (weld timers all-timers)
  ::
  ++  get-virtualships-synced-for-project
    |=  [project-name=(unit @t) our=@p now=@da]
    ^-  (list @p)
    ?~  project-name  ~
    =+  .^  =update:zig
            %gx
            :-  (scot %p our)
            /ziggurat/(scot %da now)/sync-desk-to-vship/noun
        ==
    ?~  update                            ~
    ?.  ?=(%sync-desk-to-vship -.update)  ~  ::  TODO: throw error?
    ?:  ?=(%| -.payload.update)           ~  ::  "
    =*  sync-desk-to-vship  p.payload.update
    ~(tap in (~(get ju sync-desk-to-vship) u.project-name))
  ::
  ++  get-realship-timers
    |=  [our=@p now=@da]
    ^-  (list [@da duct])
    .^  (list [@da duct])
        %bx
        /(scot %p our)//(scot %da now)/debug/timers
    ==
  ::
  ++  get-real-and-virtual-timers
    |=  [project-name=(unit @t) our=@p now=@da]
    ^-  (list [@da duct])
    %-  sort
    :_  |=([a=(pair @da duct) b=(pair @da duct)] (lth p.a p.b))
    %+  weld
      %^  filter-timers  now  ignored-realship-timer-prefixes
      (get-realship-timers our now)
    %^  filter-timers  now  ignored-virtualship-timer-prefixes
    (get-virtualship-timers project-name our now)
  --
::
::
++  fetch-desk-from-remote-ship
  |=  [who=@p desk-name=@tas followup-action=(unit vase)]
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    ['' desk-name ~ [%get-dev-desk who]]
  ::  if no sleep, get crash;
  ::   TODO: replace sleep with non-hacky solution
  ::   TODO: test on live network
  ;<  ~  bind:m  (sleep:strandio ~s1)
  ?~  followup-action  (pure:m !>(~))
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    [%ziggurat-action u.followup-action]
  (pure:m !>(~))
::
++  create-desk
  |=  =update-info:zig
  =/  m  (strand ,vase)
  =*  desk-name  desk-name.update-info
  |^  ^-  form:m
  ;<  ~  bind:m  make-merge
  ;<  ~  bind:m  make-mount
  ;<  ~  bind:m  make-bill
  ;<  ~  bind:m  make-deletions
  :: ;<  ~  bind:m  make-read-desk
  ;<  ~  bind:m  make-configuration-file
  ;<  ~  bind:m  (sleep ~s1)
  (pure:m !>(~))
  ::
  ++  make-merge
    =/  m  (strand ,~)
    ^-  form:m
    ;<  =bowl:strand  bind:m  get-bowl
    %^  send-clay-card  /merge  %merg
    [desk-name our.bowl q.byk.bowl da+now.bowl %init]
  ::
  ++  make-mount
    =/  m  (strand ,~)
    ^-  form:m
    ;<  =bowl:strand  bind:m  get-bowl
    %^  send-clay-card  /mount  %mont
    [desk-name [our.bowl desk-name da+now.bowl] /]
  ::
  ++  make-bill
    =/  m  (strand ,~)
    ^-  form:m
    %^  send-clay-card  /bill  %info
    :+  desk-name  %&
    [/desk/bill %ins %bill !>(~[desk-name])]~
  ::
  ++  make-deletions
    =/  m  (strand ,~)
    ^-  form:m
    %^  send-clay-card  /delete  %info
    [desk-name %& (clean-desk:zig-lib desk-name)]
  ::
  ++  make-configuration-file
    =/  m  (strand ,~)
    ^-  form:m
    ;<  ~  bind:m
    %-  send-raw-card
    %^  make-save-file:zig-lib  update-info
      /ted/ziggurat/configuration/[desk-name]/hoon
    make-configuration-template:zig-lib
    (pure:m ~)
  ::
  ++  send-clay-card
    |=  [w=wire =task:clay]
    =/  m  (strand ,~)
    ^-  form:m
    (send-raw-card %pass w %arvo %c task)
  --
::
++  make-snap
  |=  [project-name=@t request-id=(unit @t)]
  =/  m  (strand ,vase)
  ^-  form:m
  ?:  =('zig' project-name)  (pure:m !>(~))
  ;<  =update:zig  bind:m
    (scry update:zig /gx/ziggurat/focused-project/noun)
  =/  focused-project=@t
    ?>  ?=(^ update)  :: TODO: ?
    ?>  ?=(%focused-project -.update)
    ?>  ?=(%& -.payload.update)
    p.payload.update
  ?:  =('' focused-project)  (pure:m !>(~))
  ;<  ~  bind:m
    :: ?:  =('' focused-project)  (pure:m ~)
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    [focused-project %$ request-id %take-snapshot ~]
  ;<  ~  bind:m
    %+  poke-our  %pyro
    :-  %pyro-action
    !>  ^-  action:pyro
    [%restore-snap default-snap-path:zig-lib]
  (pure:m !>(~))
::
++  get-state
  =/  m  (strand ,state-0:zig)
  ^-  form:m
  ;<  =update:zig  bind:m
    %+  scry  update:zig
    /gx/ziggurat/get-ziggurat-state/noun
  ?>  ?=(^ update)
  ?>  ?=(%ziggurat-state -.update)
  ?>  ?=(%& -.payload.update)
  (pure:m p.payload.update)
::
++  setup-desk
  |=  $:  project-name=@t
          desk-name=@tas
          request-id=(unit @t)
          special-configuration-args=vase
          =config:zig
          =state-views:zig
          whos=(list @p)
          install=?
          start-apps=(list @tas)
      ==
  =/  commit-poll-duration=@dr   ~s1
  =/  install-poll-duration=@dr  ~s1
  =/  start-poll-duration=@dr    (div ~s1 10)
  =/  m  (strand ,vase)
  ^-  form:m
  ~&  %sd^%0
  ;<  state=state-0:zig  bind:m  get-state
  |^
  ?:  =('global' project-name)
    ;<  ~  bind:m
      %-  send-error
      (crip "{<`@tas`project-name>} face reserved")
    return-failure
  =/  p=(unit project:zig)
    (~(get by projects.state) project-name)
  ~&  %sd^p
  ?:  ?&  ?=(^ p)
          (has-desk:zig-lib u.p desk-name)
          ?=(^ (~(int in (~(gas in *(set @p)) pyro-ships.u.p)) (~(gas in *(set @p)) whos)))
      ==
    ;<  ~  bind:m
      %-  send-error
      %-  crip
      %+  weld  "project {<`@tas`project-name>} already has"
      " desk {<`@tas`desk-name>}"
    return-failure
  ;<  new-state=state-0:zig  bind:m  update-project
  =.  state  new-state
  ~&  %sd^%1
  :: ;<  ~  bind:m  start-new-ships
  ~&  %sd^%2
  ;<  ~  bind:m  make-dev-desk
  ~&  %sd^%3
  ;<  new-state=state-0:zig  bind:m  set-initial-state
  =.  state  new-state
  ~&  %sd^%4
  ;<  desk-names=(set desk)  bind:m  (scry (set desk) /cd/$)
  ~&  %sd^%5
  ;<  ~  bind:m  make-read-desk
  :: ;<  ~  bind:m  make-snap
  ;<  ~  bind:m  start-new-ships
  ;<  ~  bind:m  (block-on-previous-operation ~)
  :: ;<  ~  bind:m  (block-on-previous-operation `project-name)
  ~&  %sd^%6
  ;<  ~  bind:m  send-new-project-update
  ~&  %sd^%7
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    :^  project-name  desk-name  request-id
    [%send-state-views state-views]
  ~&  %sd^%8
  ;<  =bowl:strand  bind:m  get-bowl
  ;<  ~  bind:m
    (commit:pyro-lib whos our.bowl desk-name %da now.bowl)
  ~&  %sd^%9
  ;<  ~  bind:m  (iterate-over-whos block-on-commit)
  ?.  install  return-success
  ~&  %sd^%10
  ;<  ~  bind:m  (iterate-over-whos install-desk)
  ~&  %sd^%11
  ;<  ~  bind:m  (iterate-over-whos do-start-apps)
  ~&  %sd^%12
  return-success
  ::
  ++  send-error
    |=  message=@t
    =/  m  (strand ,~)
    ^-  form:m
    =*  new-project-error
      %~  new-project  make-error-vase:zig-lib
      :_  %error
      [project-name desk-name %setup-desk request-id]
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    :^  project-name  desk-name  request-id
    :-  %send-update
    !<(update:zig (new-project-error message))
  ::
  ++  send-new-project-update
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    :^  project-name  desk-name  request-id
    :-  %send-update
    !<  update:zig
    %.  make-sync-desk-to-vship
    %~  new-project  make-update-vase:zig-lib
    [project-name desk-name %setup-desk request-id]
  ::
  ++  start-new-ships
    =/  m  (strand ,~)
    ^-  form:m
    ;<  ~  bind:m
      %+  poke-our  %ziggurat
      :-  %ziggurat-action
      !>  ^-  action:zig
      :-  project-name
      [desk-name request-id %start-pyro-ships whos]
    (sleep ~s1)
  ::
  ++  make-dev-desk
    =/  m  (strand ,~)
    ^-  form:m
    ;<  apps-running=(set [@tas ?])  bind:m
      (scry ,(set [@tas ?]) /ge/desk-name)
    ?.  ?&  !=(0 ~(wyt in apps-running))
            (~(any in apps-running) |=([@tas r=?] r))
        ==
      (pure:m ~)
    ::  TODO: should this be interactive?
    ;<  ~  bind:m
      %+  poke-our  %ziggurat
      :-  %ziggurat-action
      !>  ^-  action:zig
      :^  project-name  desk-name  request-id
      [%suspend-uninstall-to-make-dev-desk ~]
    ::  if no sleep, get crash;
    ::   TODO: replace sleep with non-hacky solution
    (sleep ~s1)
  ::
  ++  make-sync-desk-to-vship
    ^-  sync-desk-to-vship:zig
    %-  ~(gas ju sync-desk-to-vship.state)
    (turn whos |=(who=@p [desk-name who]))
  ::
  ++  update-project
    =/  m  (strand ,state-0:zig)
    ^-  form:m
    =|  =desk:zig
    =/  =project:zig
      (~(gut by projects.state) project-name *project:zig)
    =.  projects.state
      %+  ~(put by projects.state)  project-name
      %^  put-desk:zig-lib  project  desk-name
      desk(special-configuration-args special-configuration-args)
    ;<  ~  bind:m
      %+  poke-our  %ziggurat
      :-  %ziggurat-action
      !>  ^-  action:zig
      :-  project-name
      [desk-name request-id %set-ziggurat-state state]
    (pure:m state)
  ::
  ++  set-initial-state
    =/  m  (strand ,state-0:zig)
    ^-  form:m
    =.  state
      %=  state
          sync-desk-to-vship  make-sync-desk-to-vship
      ::
          configs
        %+  ~(put by configs.state)  project-name
        %.  ~(tap by config)
        ~(gas by (~(gut by configs.state) project-name ~))
      ==
    ;<  ~  bind:m
      %+  poke-our  %ziggurat
      :-  %ziggurat-action
      !>  ^-  action:zig
      :-  project-name
      [desk-name request-id %set-ziggurat-state state]
    (pure:m state)
  ::
  ++  make-read-desk
    =/  m  (strand ,~)
    ^-  form:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:zig
    [project-name desk-name request-id %read-desk ~]
  ::
  ++  iterate-over-whos
    =/  m  (strand ,~)
    |=  gate=$-(@p form:m)
    ^-  form:m
    |-
    ?~  whos  (pure:m ~)
    =*  who  i.whos
    ;<  ~  bind:m  (gate who)
    $(whos t.whos)
  ::
  ++  block-on-commit
    |=  who=@p
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep commit-poll-duration)
    :: ;<  now=@da  bind:m  get-time
    :: ?.  (virtualship-desk-exists who now desk-name)  $
    ;<  does-exist=?  bind:m
      (virtualship-desk-exists who desk-name)
    ?.  does-exist  $
    (pure:m ~)
  ::
  ++  install-desk
    |=  who=@p
    =/  m  (strand ,~)
    ^-  form:m
    ;<  empty-vase=vase  bind:m
      %+  send-pyro-dojo  who
      (crip "|install our {<desk-name>}")
    (pure:m ~)
  ::
  ++  block-on-install
    |=  who=@p
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep install-poll-duration)
    ;<  =bowl:strand  bind:m  get-bowl
    =/  app=(unit @tas)
      (get-final-app-to-install desk-name [our now]:bowl)
    ::  if no desk.bill (i.e. get ~), -> install done
    ?~  app  (pure:m)
    ::  if the final app is installed -> install done
    ;<  is-running=?  bind:m
      (virtualship-is-running-app who u.app)
    ?.  is-running  $
    (pure:m ~)
  ::
  ++  do-start-apps
    |=  who=@p
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ?~  start-apps  (pure:m ~)
    =*  next-app  i.start-apps
    ;<  empty-vase=vase  bind:m
      %+  send-pyro-dojo  who
      (crip "|start {<`@tas`desk-name>} {<`@tas`next-app>}")
    ;<  ~  bind:m  (block-on-start who next-app)
    $(start-apps t.start-apps)
  ::
  ++  block-on-start
    |=  [who=@p next-app=@tas]
    =/  m  (strand ,~)
    ^-  form:m
    |-
    ;<  ~  bind:m  (sleep start-poll-duration)
    ;<  is-running=?  bind:m
      (virtualship-is-running-app who next-app)
    ?.  is-running  $
    (pure:m ~)
  ::
  ++  return-failure
    =/  m  (strand ,vase)
    ^-  form:m
    (pure:m !>(`?`%.n))
  ::
  ++  return-success
    =/  m  (strand ,vase)
    ^-  form:m
    ;<  state=state-0:zig  bind:m  get-state
    =.  state  state(focused-project project-name)
    ;<  ~  bind:m
      %+  poke-our  %ziggurat
      :-  %ziggurat-action
      !>  ^-  action:zig
      :-  project-name
      [desk-name request-id %set-ziggurat-state state]
    ;<  ~  bind:m  (block-on-previous-operation `project-name)
    (pure:m !>(`?`%.y))
  ::
  ++  scry-virtualship-desks
    |=  who=@p
    =/  m  (strand ,(set @tas))
    ^-  form:m
    =/  w=@ta  (scot %p who)
    (scry (set @tas) /gx/pyro/i/[w]/cd/[w]//0/noun)
  ::
  ++  virtualship-desk-exists
    :: |=  [who=@p now=@da desk=@tas]
    |=  [who=@p desk-name=@tas]
    =/  m  (strand ,?)
    ^-  form:m
    ;<  desk-names=(set @tas)  bind:m
      (scry-virtualship-desks who)
    (pure:m (~(has in desk-names) desk-name))
  ::
  ++  virtualship-is-running-app
    |=  [who=@p app=@tas]
    =/  m  (strand ,?)
    ^-  form:m
    =/  w=@ta    (scot %p who)
    (scry ? /gx/pyro/i/[w]/gu/[w]/[app]/0/noun)
  ::
  ++  get-final-app-to-install
    |=  [desk-name=@tas our=@p now=@da]
    ^-  (unit @tas)
    =/  bill-path=path
      /(scot %p our)/[desk-name]/(scot %da now)/desk/bill
    ?.  .^(? %cu bill-path)  ~
    `(rear .^((list @tas) %cx bill-path))
  --
--
