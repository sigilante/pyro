/-  spider,
    pyro=zig-pyro,
    wallet=zig-wallet,
    zig=zig-ziggurat
/+  strandio,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart
::
=*  strand    strand:spider
=*  get-bowl  get-bowl:strandio
=*  poke-our  poke-our:strandio
=*  scry      scry:strandio
=*  sleep     sleep:strandio
=*  wait      wait:strandio
::
|_  $:  project-name=@t
        desk-name=@tas
        ship-to-address=(map @p @ux)
    ==
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
--
