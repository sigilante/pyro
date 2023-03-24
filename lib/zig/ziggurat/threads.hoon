/-  spider,
    pyro=zig-pyro,
    wallet=zig-wallet,
    zig=zig-ziggurat
/+  strandio,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart,
    zig-lib=zig-ziggurat
::
=*  strand    strand:spider
=*  get-bowl  get-bowl:strandio
=*  get-time  get-time:strandio
=*  poke-our  poke-our:strandio
=*  scry      scry:strandio
=*  sleep     sleep:strandio
=*  wait      wait:strandio
::
|_  $:  project-name=@t
        desk-name=@tas
        ship-to-address=(map @p @ux)
    ==
++  send-discrete-pyro-dojo
  |=  [who=@p payload=@t project-name=@t]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (send-pyro-dojo who payload)
  ::  ensure %pyro dojo send has completed before moving on
  ;<  ~  bind:m  (block-on-previous-step prject-name)
  (pure:m ~)
::
++  send-pyro-dojo
  |=  [who=@p payload=@t]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (dojo:pyro-lib who (trip payload))
  (pure:m ~)
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
  |=  $:  who=@p
          to=@p
          app=@tas
          mark=@tas
          payload=vase
          project-name=@t
      ==
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m  (send-pyro-poke who to app mark payload)
  ::  ensure %pyro poke send has completed before moving on
  ;<  ~  bind:m  (block-on-previous-step project-name)
  (pure:m ~)
::
++  send-pyro-poke
  |=  [who=@p to=@p app=@tas mark=@tas payload=vase]
  =/  m  (strand ,~)
  ^-  form:m
  ::  if mark is not found poke will fail
  ;<  =bowl:strand  bind:m  get-bowl
  |^
  ?:  is-mar-found
    ::  found mark: proceed
    (poke:pyro-lib who to app mark q.payload)
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
  =/  m  (strand ,@ux)
  ^-  form:m
  =/  address=@ux  (~(got by ship-to-address) who)
  ;<  code-atom=@  bind:m
    (scry @ [%cx desk-name contract-jam-path])
  =/  code  [- +]:(cue code-atom)
  |^
  ;<  ~  bind:m
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
  (pure:m compute-contract-hash)
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
  |=  $:  who=@p
          sequencer-host=@p
          gate=$-(* form:m)
          gate-args=*
      ==
  ^-  form:m
  =/  address=@ux  (~(got by ship-to-address) who)
  ;<  old-scry=(map @ux *)  bind:m
    %^  send-pyro-scry  who  (map @ux *)
    [%gx %uqbar /pending-store/(scot %ux address)/noun/noun]
  ::
  ;<  gate-output=vase  bind:m  (gate gate-args)
  ;<  ~  bind:m  (block-on-previous-step project-name)
  ::
  ;<  new-scry=(map @ux *)  bind:m
    %^  send-pyro-scry  who  (map @ux *)
    [%gx %uqbar /pending-store/(scot %ux address)/noun/noun]
  ::
  =*  old-pending  ~(key by old-scry)
  =*  new-pending  ~(key by new-scry)
  =/  diff-pending=(list @ux)
    ~(tap in (~(dif in new-pending) old-pending))
  ?.  ?=([@ ~] diff-pending)
    ~&  %ziggurat-threads^%diff-pending-not-length-one^diff-pending
    !!
  ;<  ~  bind:m
    %-  send-pyro-poke
    :^  who  who  %uqbar
    :-  %wallet-poke
    !>  ^-  wallet-poke:wallet
    :^  %submit  from=address  hash=i.diff-pending
    gas=[rate=1 bud=1.000.000]
  ;<  ~  bind:m  (sleep ~s1)  ::  TODO: tune time
  ;<  ~  bind:m
    (send-pyro-dojo sequencer-host ':sequencer|batch')
  (pure:m gate-output)
::
++  block-on-previous-step
  =+  done-duration=`@dr`~m1
  |=  project-name=@t
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
    |=  [project-name=@t our=@p now=@da]
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
    |=  [project-name=@t our=@p now=@da]
    ^-  (list @p)
    =+  .^  =update:zig
            %gx
            :-  (scot %p our)
            /ziggurat/(scot %da now)/sync-desk-to-vship/noun
        ==
    ?~  update                            ~
    ?.  ?=(%sync-desk-to-vship -.update)  ~  ::  TODO: throw error?
    ?:  ?=(%| -.payload.update)           ~  ::  "
    =*  sync-desk-to-vship  p.payload.update
    ~(tap in (~(get ju sync-desk-to-vship) project-name))
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
    |=  [project-name=@t our=@p now=@da]
    ^-  (list [@da duct])
    %-  sort
    :_  |=([a=(pair @da duct) b=(pair @da duct)] (lth p.a p.b))
    %+  weld
      %^  filter-timers  now  ignored-realship-timer-prefixes
      (get-realship-timers our now)
    %^  filter-timers  now  ignored-virtualship-timer-prefixes
    (get-virtualship-timers project-name our now)
  --
++  setup-desk
  |=  $:  project-name=@t
          desk-name=@tas
          request-id=(unit @t)
          =config:zig
          =state-views:zig
          whos=(list @p)
          install=?
          start-apps=(list @tas)
      ==
  =/  commit-poll-duration=@dr   ~s1
  =/  install-poll-duration=@dr  ~s1
  =/  start-poll-duration=@dr    (div ~s1 10)
  |^
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:ziggurat
    [project-name desk-name request-id %set-config config]
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:ziggurat
    :^  project-name  desk-name  request-id
    [%set-sync-desk-to-vship whos]
  ;<  ~  bind:m
    %+  poke-our  %ziggurat
    :-  %ziggurat-action
    !>  ^-  action:ziggurat
    :^  project-name  desk-name  request-id
    [%send-state-views state-views]
  ;<  =bowl:strand  bind:m  get-bowl
  ;<  ~  bind:m
    (commit:pyro-lib whos our.bowl desk-name %da now.bowl)
  ;<  ~  bind:m  (iterate-over-whos block-on-commit)
  ?.  install  finish
  ;<  ~  bind:m  (iterate-over-whos install-desk)
  ;<  ~  bind:m  (iterate-over-whos do-start-apps)
  finish
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
    %+  send-pyro-dojo  who
    (crip "|install our {<desk-name>}")
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
    ;<  ~  bind:m
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
  ++  finish
    =/  m  (strand ,vase)
    ^-  form:m
    (pure:m !>(~))
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
