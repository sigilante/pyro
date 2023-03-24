/-  spider,
    ui=zig-indexer,
    w=zig-wallet,
    zig=zig-ziggurat
/+  zig-threads=zig-ziggurat-threads
::
=*  strand     strand:spider
::
=/  m  (strand ,vase)
|^  ted
::
+$  arg-mold
  $:  project-name=@t
      desk-name=@tas
      request-id=(unit @t)
  ==
::
++  make-config
  ^-  config:zig
  %-  ~(gas by *config:zig)
  [[~nec %sequencer] 0x0]~
::
++  make-state-views
  ^-  state-views:zig
  ::  app=~ -> chain view, not an agent view
  =/  pfix  (cury welp `path`/zig/state-views)
  :~  [~nec ~ (pfix /chain/transactions/hoon)]
      [~nec ~ (pfix /chain/chain/hoon)]
      [~nec ~ (pfix /chain/holder-our/hoon)]
      [~nec ~ (pfix /chain/source-zigs/hoon)]
  ::
      [~nec `%wallet (pfix /agent/wallet-metadata-store/hoon)]
      [~nec `%wallet (pfix /agent/wallet-our-items/hoon)]
  ==
::
++  make-virtualships-to-sync
  ^-  (list @p)
  ~[~nec ~bud ~wes]
::
++  make-install
  ^-  ?
  %.y
::
++  make-start-apps
  ^-  (list @tas)
  ~[%subscriber]
::
++  run-setup-desk
  |=  [project-name=@t desk-name=@tas request-id=(unit @t)]
  =/  m  (strand ,vase)
  ^-  form:m
  %:  setup-desk:zig-threads
      project-name
      desk-name
      request-id
      make-config
      make-state-views
      make-virtualships-to-sync
      make-install
      make-start-apps
  ==
::
++  setup-virtualship-state
  |=  project-name=@t
  =/  m  (strand ,vase)
  ^-  form:m
  |^
  ;<  ~  bind:m  setup-nec
  ;<  ~  bind:m  setup-bud
  ;<  ~  bind:m  setup-wes
  (pure:m !>(~))
  ::
  ++  setup-nec
    =/  who=@p  ~nec
    ;<  ~  bind:m
      %+  send-discrete-pyro-dojo:zig-threads  who
      ':rollup|activate'
    ;<  ~  bind:m
      %-  send-pyro-poke
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-sequencer ~nec %sequencer])
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-rollup ~nec %rollup])
    ;<  ~  bind:m
      %+  send-discrete-pyro-dojo:zig-threads  who
      %-  crip
      ":sequencer|init our {<twn-id>} {<sequencer-address>}"
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed nec-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  setup-bud
    =/  who=@p  ~bud
    ;<  ~  bind:m  (make-setup-chain-user who)
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed bud-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  setup-wes
    =/  who=@p  ~wes
    ;<  ~  bind:m  (make-setup-chain-user who)
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed wes-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  make-setup-chain-user
    |=  who=@p
    ;<  ~  bind:m
      %-  send-pyro-poke
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-sequencer ~nec %sequencer])
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-rollup ~nec %rollup])
    ;<  ~  bind:m
      %-  send-discrete-pyro-poke
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%btstrap ~nec %indexer])
    (pure:m ~)
  ::
  ++  town-id
    ^-  @ux
    0x0
  ::
  ++  sequencer-address
    ^-  @ux
    0xc9f8.722e.78ae.2e83.0dd9.e8b9.db20.f36a.1bc4.c704.4758.6825.c463.1ab6.daee.e608
  ::
  ++  nec-seed-phrase
    ^-  @t
    'uphold apology rubber cash parade wonder shuffle blast delay differ help priority bleak ugly fragile flip surge shield shed mistake matrix hold foam shove'
  ::
  ++  bud-seed-phrase
    ^-  @t
    'post fitness extend exit crack question answer fruit donkey quality emotion draw section width emotion leg settle bulb zero learn solution dutch target kidney'
  ::
  ++  wes-seed-phrase
    ^-  @t
    'flee alter erode parrot turkey harvest pass combine casual interest receive album coyote shrug envelope turtle broken purity wear else fluid transaction theme buyer'
  --
::
++  ted
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-configuration-zig project-name=@t desk-name=@tas request-id=(unit @t)"
    (pure:m !>(~))
  =*  project-name  project-name.u.args
  =*  desk-name     desk-name.u.args
  =*  request-id    request-id.u.args
  ::
  ;<  setup-desk-result=vase  bind:m
    (run-setup-desk project-name desk-name request-id)
  ;<  ~  bind:m  (setup-virtualship-state project-name)
  %-  pure:m
  !>(`(each ~ @t)`[%.y ~])
--
