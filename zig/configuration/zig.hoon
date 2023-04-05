/-  spider,
    ui=zig-indexer,
    w=zig-wallet,
    zig=zig-ziggurat
/+  strandio,
    ziggurat-threads=zig-ziggurat-threads
::
=*  strand     strand:spider
=*  build-file  build-file:strandio
=*  get-bowl    get-bowl:strandio
=*  get-time    get-time:strandio
::
=/  m  (strand ,vase)
=|  project-name=@t
=|  desk-name=@tas
=|  ship-to-address=(map @p @ux)
=*  zig-threads
  ~(. ziggurat-threads project-name desk-name ship-to-address)
|%
::
+$  arg-mold
  $:  project-name=@t
      desk-name=@tas
      request-id=(unit @t)
  ==
::
++  make-desk-dependencies
  |=  =bowl:strand
  ^-  desk-dependencies:zig
  :_  ~
  [our.bowl %zig [%da now.bowl] ~]
::
++  make-config
  ^-  config:zig
  %-  ~(gas by *config:zig)
  [[~nec %sequencer] 0x0]~
::
++  make-virtualships-to-sync
  ^-  (list @p)
  ~[~nec ~bud ~wes]
::
++  make-install
  ^-  (map desk-name=@tas whos=(list @p))
  %-  ~(gas by *(map @tas (list @p)))
  :_  ~
  [%zig make-virtualships-to-sync]
::
++  make-start-apps
  ^-  (map desk-name=@tas (list @tas))
  %-  ~(gas by *(map @tas (list @tas)))
  :_  ~
  [%zig ~[%subscriber]]
::
++  run-setup-project
  |=  request-id=(unit @t)
  =/  m  (strand ,vase)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  %:  setup-project:zig-threads
      request-id
      :: !>(~)
      (make-desk-dependencies bowl)
      make-config
      make-virtualships-to-sync
      make-install
      make-start-apps
  ==
::
++  setup-virtualship-state
  =/  m  (strand ,vase)
  ^-  form:m
  |^
  ;<  ~  bind:m  setup-nec
  ;<  ~  bind:m  setup-bud
  ;<  ~  bind:m  setup-wes
  (pure:m !>(~))
  ::
  ++  setup-nec
    =/  m  (strand ,~)
    ^-  form:m
    =/  who=@p  ~nec
    ;<  empty-vase=vase  bind:m
      %^  send-discrete-pyro-dojo:zig-threads  project-name
      who  ':rollup|activate'
    ;<  empty-vase=vase  bind:m
      %-  send-pyro-poke:zig-threads
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-sequencer ~nec %sequencer])
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-rollup ~nec %rollup])
    ;<  empty-vase=vase  bind:m
      %^  send-discrete-pyro-dojo:zig-threads  project-name
        who
      %-  crip
      ":sequencer|init our {<town-id>} {<sequencer-address>}"
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed nec-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  setup-bud
    =/  m  (strand ,~)
    ^-  form:m
    =/  who=@p  ~bud
    ;<  ~  bind:m  (make-setup-chain-user who)
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed bud-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  setup-wes
    =/  m  (strand ,~)
    ^-  form:m
    =/  who=@p  ~wes
    ;<  ~  bind:m  (make-setup-chain-user who)
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %uqbar
      :-  %wallet-poke
      !>  ^-  wallet-poke:w
      [%import-seed wes-seed-phrase 'squid' 'nickname']
    (pure:m ~)
  ::
  ++  make-setup-chain-user
    |=  who=@p
    =/  m  (strand ,~)
    ^-  form:m
    ;<  empty-vase=vase  bind:m
      %-  send-pyro-poke:zig-threads
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-sequencer ~nec %sequencer])
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%set-rollup ~nec %rollup])
    ;<  empty-vase=vase  bind:m
      %-  send-discrete-pyro-poke:zig-threads
      :-  project-name
      :^  who  who  %indexer
      :-  %indexer-action
      !>(`action:ui`[%bootstrap ~nec %indexer])
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
++  $
  ^-  thread:spider
  |=  args-vase=vase
  ^-  form:m
  =/  args  !<((unit arg-mold) args-vase)
  ?~  args
    ~&  >>>  "Usage:"
    ~&  >>>  "-zig!ziggurat-configuration-zig project-name=@t desk-name=@tas request-id=(unit @t)"
    (pure:m !>(~))
  =.  project-name  project-name.u.args
  =.  desk-name     desk-name.u.args
  =*  request-id    request-id.u.args
  ::
  ~&  %zcz^%top^%0
  ;<  setup-project-result=vase  bind:m
    (run-setup-project request-id)
  ~&  %zcz^%top^%1
  ;<  setup-ships-result=vase  bind:m  setup-virtualship-state
  ~&  %zcz^%top^%2
  (pure:m !>(`(each ~ @t)`[%.y ~]))
--
