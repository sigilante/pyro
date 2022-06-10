::  wallet [uqbar-dao]
::
::  Uqbar wallet agent. Stores private key and facilitates signing
::  transactions, holding nonce values, and keeping track of owned data.
::
/-  ui=indexer
/+  *ziggurat, *wallet-util, wallet-parsing, default-agent, dbug, verb, bip32, bip39
/*  smart-lib  %noun  /lib/zig/compiled/smart-lib/noun
|%
+$  card  card:agent:gall
+$  state-0
  $:  %0
      seed=[mnem=@t pass=@t address-index=@ud]
      keys=(map pub=@ux [priv=(unit @ux) nick=@t])  ::  keys created from master seed
      nodes=(map town=@ud =ship)  ::  the sequencer you submit txs to for each town
      nonces=(map pub=@ux (map town=@ud nonce=@ud))
      tokens=(map pub=@ux =book)
      =transaction-store
      pending=(unit [yolk-hash=@ =egg:smart args=supported-args])
      =metadata-store
      indexer=(unit ship)
  ==
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init  `this(state [%0 ['' '' 0] ~ ~ ~ ~ ~ ~ ~ `our.bowl])
::
++  on-save  !>(state)
++  on-load
  |=  =old=vase
  ^-  (quip card _this)
  =/  old-state  !<(state-0 old-vase)
  `this(state old-state)
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  !!
      [%book-updates ~]
    ?>  =(src.bowl our.bowl)
    ::  send frontend updates along this path
    :_  this
    ~[[%give %fact ~ %zig-wallet-update !>([%new-book tokens.state])]]
  ::
      [%tx-updates ~]
    ?>  =(src.bowl our.bowl)
    ::  provide updates about submitted transactions
    `this
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  ?+    mark  !!
      %zig-wallet-poke
    =^  cards  state
      (poke-wallet !<(wallet-poke vase))
    [cards this]
  ==
  ::
  ++  poke-wallet
    |=  act=wallet-poke
    ^-  (quip card _state)
    ?>  =(src.bowl our.bowl)
    ?-    -.act
        %import-seed
      ::  will lose seed in current wallet, should warn on frontend!
      ::  stores the default keypair in map
      ::  import takes in a seed phrase and password to encrypt with
      =+  seed=(to-seed:bip39 (trip mnemonic.act) (trip password.act))
      =+  core=(from-seed:bip32 [64 seed])
      ::  keep any addresses not generated by our hot wallet, ie imported HW addresses
      =+  %-  ~(gas by *(map @ux [(unit @ux) @t]))
          %+  murn  ~(tap by keys.state)
          |=  [pub=@ux [priv=(unit @ux) nick=@t]]
          ?^  priv  ~
          `[pub [~ nick]]
      :-  %+  weld  (clear-all-holder-and-id-subs wex.bowl)
          (create-holder-and-id-subs ~(key by -) (need indexer.state))
      %=  state
        transaction-store  ~
        seed  [mnemonic.act password.act 0]
        keys  (~(put by -) public-key:core [`private-key:core nick.act])
      ==
    ::
        %generate-hot-wallet
      ::  will lose seed in current wallet, should warn on frontend!
      ::  creates a new wallet from entropy derived on-urbit
      =+  mnem=(from-entropy:bip39 [32 eny.bowl])
      =+  core=(from-seed:bip32 [64 (to-seed:bip39 mnem (trip password.act))])
      ::  keep any addresses not generated by our hot wallet, ie imported HW addresses
      =+  %-  ~(gas by *(map @ux [(unit @ux) @t]))
          %+  murn  ~(tap by keys.state)
          |=  [pub=@ux [priv=(unit @ux) nick=@t]]
          ?^  priv  ~
          `[pub [~ nick]]
      :-  %+  weld  (clear-all-holder-and-id-subs wex.bowl)
          (create-holder-and-id-subs ~(key by (~(put by -) public-key:core [`private-key:core nick.act])) (need indexer.state))
      %=  state
        transaction-store  ~
        seed  [(crip mnem) password.act 0]
        keys  (~(put by -) public-key:core [`private-key:core nick.act])
      ==
    ::
        %derive-new-address
      ::  if hdpath input is empty, use address-index+1 to get next
      =+  (from-seed:bip32 [64 (to-seed:bip39 (trip mnem.seed.state) (trip pass.seed.state))])
      =+  %-  derive-path:-
          ?:  !=("" hdpath.act)  hdpath.act
          (weld "m/44'/60'/0'/0/" (scow %ud address-index.seed.state))
      :-  (create-holder-and-id-subs (silt ~[public-key:-]) (need indexer.state))
      %=  state
        seed  seed(address-index +(address-index.seed))
        keys  (~(put by keys) public-key:- [`private-key:- nick.act])
      ==
    ::
        %add-tracked-address
      :-  (create-holder-and-id-subs (silt ~[address.act]) (need indexer.state))
      state(keys (~(put by keys) address.act [~ nick.act]))
    ::
        %delete-address
      ::  can recover by re-deriving same path
      :-  (clear-holder-and-id-sub address.act wex.bowl)
      %=  state
        keys    (~(del by keys) address.act)
        nonces  (~(del by nonces) address.act)
        tokens  (~(del by tokens) address.act)
      ==
    ::
        %edit-nickname
      =+  -:(~(got by keys.state) address.act)
      `state(keys (~(put by keys) address.act [- nick.act]))
    ::
        %set-node
      `state(nodes (~(put by nodes) town.act ship.act))
    ::
        %set-indexer
      ::  defaults to our ship, so for testing, just run indexer on same ship
      :_  state(indexer `ship.act)
      %+  weld  (clear-asset-subscriptions wex.bowl)
      (create-asset-subscriptions tokens.state ship.act)
    ::
        %set-nonce  ::  for testing/debugging
      =+  acc=(~(got by nonces.state) address.act)
      `state(nonces (~(put by nonces) address.act (~(put by acc) town.act new.act)))
    ::
        %populate
      ::  populate wallet with fake data for testing
      ::  will WIPE previous wallet state!!
      ::
      =+  mnem=(from-entropy:bip39 [32 seed.act])
      =+  core=(from-seed:bip32 [64 (to-seed:bip39 mnem "")])
      =+  pub=public-key:core
      =+  (malt ~[[pub [`private-key:core (scot %ux seed.act)]]])
      :-  (create-holder-and-id-subs ~(key by -) (need indexer.state))
      %=  state
        seed    [(crip mnem) '' 0]
        keys    -
        nonces  ~
        tokens  ~
        transaction-store  ~
        metadata-store  ~
        nodes   (malt ~[[0 our.bowl] [1 our.bowl] [2 our.bowl]])
      ==
    ::
        %submit-signed
      ?~  pending.state  !!
      =*  p  u.pending.state
      ?>  =(hash.act yolk-hash.p)
      =:  sig.p.egg.p  sig.act
          eth-hash.p.egg.p  `eth-hash.act
      ==
      ?>  ?=(account:smart from.p.egg.p)
      =*  from   id.from.p.egg.p
      =*  nonce  nonce.from.p.egg.p
      =/  node=ship  (~(gut by nodes.state) town-id.p.egg.p our.bowl)
      =+  egg-hash=(hash-egg egg.p)
      =/  our-txs
        ?~  o=(~(get by transaction-store) from)
          [(malt ~[[egg-hash [egg.p args.p]]]) ~]
        u.o(sent (~(put by sent.u.o) egg-hash [egg.p args.p]))
      ~&  >>  "%wallet: submitting self-signed tx"
      ~&  >>  "with eth-hash {<eth-hash.act>}"
      ~&  >>  "with signature {<v.sig.act^r.sig.act^s.sig.act>}"
      :_  %=  state
            pending  ~
            transaction-store  (~(put by transaction-store) from our-txs)
          ==
      :~  (tx-update-card egg.p `args.p)
          :*  %pass  /submit-tx/(scot %ux egg-hash)
              %agent  [node ?:(=(0 town-id.p.egg.p) %ziggurat %sequencer)]
              %poke  %zig-weave-poke
              !>([%forward (silt ~[egg.p])])
          ==
      ==
    ::
        %submit-custom
      ::  submit a transaction, with frontend-defined everything
      =/  our-nonces     (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud      (~(gut by our-nonces) town.act 0)
      =/  node=ship      (~(gut by nodes.state) town.act our.bowl)
      =/  =caller:smart  :+  from.act  +(nonce)
                         (fry-rice:smart from.act `@ux`'zigs-contract' town.act `@`'zigs')
      =/  =yolk:smart    [caller `q:(slap !>(+:(cue q.q.smart-lib)) (ream args.act)) my-grains.act cont-grains.act]
      =/  keypair        (~(got by keys.state) from.act)
      =/  =egg:smart
        :_  yolk
        :*  caller
            ?~  priv.keypair
              [0 0 0]
            %+  ecdsa-raw-sign:secp256k1:secp:crypto
              (sham (jam yolk))
            u.priv.keypair
            ~
            to.act
            rate.gas.act
            bud.gas.act
            town.act
            status=%100
        ==
      ?~  priv.keypair
        ::  if we don't have private key for this address, set as pending
        ::  and allow frontend to sign with HW wallet or otherwise
        ~&  >>  "%wallet: storing unsigned tx"
        `state(pending `[(sham (jam yolk)) egg [%custom args.act]])
      ::  if we have key, use signature and submit
      =+  egg-hash=(hash-egg egg)
      =/  our-txs
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[egg-hash [egg [%custom args.act]]]]) ~]
        u.o(sent (~(put by sent.u.o) egg-hash [egg [%custom args.act]]))
      ~&  >>  "%wallet: submitting tx"
      :_  %=  state
            transaction-store  (~(put by transaction-store) from.act our-txs)
            nonces  (~(put by nonces) from.act (~(put by our-nonces) town.act +(nonce)))
          ==
      :~  (tx-update-card egg `[%custom args.act])
          :*  %pass  /submit-tx/(scot %ux from.act)/(scot %ux egg-hash)
              %agent  [node ?:(=(0 town.act) %ziggurat %sequencer)]
              %poke  %zig-weave-poke
              !>([%forward (silt ~[egg])])
          ==
      ==
    ::
        %submit
      ::  submit a transaction
      ::  create an egg and sign it, then poke a sequencer
      ::
      ::  things to expose on frontend:
      ::  'from' address, contract 'to' address, town select,
      ::  gas (rate & budget), transaction type (acquired from ABI..?)
      ::
      =/  our-nonces     (~(gut by nonces.state) from.act ~)
      =/  nonce=@ud      (~(gut by our-nonces) town.act 0)
      =/  node=ship      (~(gut by nodes.state) town.act our.bowl)
      ~|  "wallet: can't find tokens for that address!"
      =/  =book          (~(got by tokens.state) from.act)
      =/  =caller:smart  :+  from.act  +(nonce)
                        (fry-rice:smart from.act `@ux`'zigs-contract' town.act `@`'zigs')
      ::  need to check transaction type and collect rice based on it
      ::  only supporting small subset of contract calls, for tokens and NFTs
      =/  formatted=[args=(unit *) our-grains=(set @ux) cont-grains=(set @ux)]
        ?-    -.args.act
            %give
          ~|  "wallet can't find metadata for that token!"
          =/  metadata  (~(got by metadata-store.state) salt.args.act)
          ~|  "wallet can't find our zigs account for that town!"
          =/  our-account=grain:smart  +:(~(got by book) [town.act to.act salt.metadata])
          =/  their-account-id  (fry-rice:smart to.args.act to.act town.act salt.metadata)
          =/  exists  .^(? %gx /(scot %p our.bowl)/indexer/(scot %da now.bowl)/has-grain/(scot %ux their-account-id)/noun)
          ?.  exists
            ::  they don't have an account for this token
            ?:  =(to.act `@ux`'zigs-contract')  ::  zigs special case
              [`[%give to.args.act ~ amount.args.act bud.gas.act] (silt ~[id.our-account]) ~]
            [`[%give to.args.act ~ amount.args.act] (silt ~[id.our-account]) ~]
          ::  they have an account for this token, include it in transaction
          :+  ?:  =(to.act `@ux`'zigs-contract')  ::  zigs special case
                `[%give to.args.act `their-account-id amount.args.act bud.gas.act]
              `[%give to.args.act `their-account-id amount.args.act]
            (silt ~[id.our-account])
          (silt ~[their-account-id])
        ::  ONLT difference between this and token give is amount vs. item-id.
        ::  therefore should figure out way to just unify them.
            %give-nft
          ~|  "wallet can't find metadata for that token!"
          =/  metadata  (~(got by metadata-store.state) salt.args.act)
          ~|  "wallet can't find our zigs account for that town!"
          =/  our-account=grain:smart  +:(~(got by book) [town.act to.act salt.metadata])
          =/  their-account-id  (fry-rice:smart to.args.act to.act town.act salt.metadata)
          =/  exists  .^(? %gx /(scot %p our.bowl)/indexer/(scot %da now.bowl)/has-grain/(scot %ux their-account-id)/noun)
          ?.  exists
            [`[%give to.args.act ~ item-id.args.act] (silt ~[id.our-account]) ~]
          :+  `[%give to.args.act `their-account-id item-id.args.act]
            (silt ~[id.our-account])
          (silt ~[their-account-id])
        ::
          %become-validator  [`args.act ~ (silt ~[`@ux`'ziggurat'])]
          %stop-validating   [`args.act ~ (silt ~[`@ux`'ziggurat'])]
          %init  [`args.act ~ (silt ~[`@ux`'world'])]
          %join  [`args.act ~ (silt ~[`@ux`'world'])]
          %exit  [`args.act ~ (silt ~[`@ux`'world'])]
          %custom  !!
        ==
      =/  keypair       (~(got by keys.state) from.act)
      =/  =yolk:smart   [caller args.formatted our-grains.formatted cont-grains.formatted]
      =/  sig           ?~  priv.keypair
                          [0 0 0]
                        (ecdsa-raw-sign:secp256k1:secp:crypto (sham (jam yolk)) u.priv.keypair)
      =/  =egg:smart    [[caller sig ~ to.act rate.gas.act bud.gas.act town.act status=%100] yolk]
      ?~  priv.keypair
        ::  if we don't have private key for this address, set as pending
        ::  and allow frontend to sign with HW wallet or otherwise
        ~&  >>  "%wallet: storing unsigned tx"
        `state(pending `[(shax (jam yolk)) egg args.act])
      ::  if we have key, use signature and submit
      =+  egg-hash=(hash-egg egg)
      =/  our-txs
        ?~  o=(~(get by transaction-store) from.act)
          [(malt ~[[egg-hash [egg args.act]]]) ~]
        u.o(sent (~(put by sent.u.o) egg-hash [egg args.act]))
      ~&  >>  "wallet: submitting tx"
      :_  %=  state
            transaction-store  (~(put by transaction-store) from.act our-txs)
            nonces  (~(put by nonces) from.act (~(put by our-nonces) town.act +(nonce)))
          ==
      :~  (tx-update-card egg `args.act)
          :*  %pass  /submit-tx/(scot %ux from.act)/(scot %ux egg-hash)
              %agent  [node ?:(=(0 town.act) %ziggurat %sequencer)]
              %poke  %zig-weave-poke
              !>([%forward (silt ~[egg])])
          ==
      ==
    ==
  --
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ^-  (quip card _this)
  ?+    wire  (on-agent:def wire sign)
      [%submit-tx @ @ ~]
    ::  check to see if our tx was received by sequencer
    =/  from=@ux  (slav %ux i.t.wire)
    =/  hash=@ux  (slav %ux i.t.t.wire)
    ?:  ?=(%poke-ack -.sign)
      =/  our-txs  (~(got by transaction-store) from)
      =/  this-tx  (~(got by sent.our-txs) hash)
      =.  this-tx
        ?~  p.sign
          ::  got it
          ~&  >>  "wallet: tx was received by sequencer"
          this-tx(status.p.egg %101)
        ::  failed
        ~&  >>>  "wallet: tx was rejected by sequencer"
        this-tx(status.p.egg %103)
      :-  ~[(tx-update-card egg.this-tx `args.this-tx)]
      %=    this
          transaction-store
        %-  ~(put by transaction-store)
        [from our-txs(sent (~(put by sent.our-txs) hash this-tx))]
      ::
          nonces
        ?:  =(status.p.egg.this-tx %101)
          nonces
        ::  dec nonce on this town, tx was rejected
        (~(put by nonces) from (~(jab by (~(got by nonces) from)) town-id.p.egg.this-tx |=(n=@ud (dec n))))
      ==
    `this
  ::
      [%holder @ ~]
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ?.  ?=(%indexer-update p.cage.sign)  (on-agent:def wire sign)
    =+  pub=(slav %ux i.t.wire)
    =/  =update:ui  !<(=update:ui q.cage.sign)
    ::  TODO: this is awful, replace with scrys to contract that give token types. see wallet/util.hoon
    =/  found=book
      (indexer-update-to-books update pub metadata-store.state)
    =/  metadata-search  (find-new-metadata found our.bowl metadata-store.state [our now]:bowl)
    =/  found-again=book
      (indexer-update-to-books update pub metadata-search)
    =/  curr=(unit book)  (~(get by tokens.state) pub)
    =+  %+  ~(put by tokens.state)  pub
        ?~  curr  found-again
        (~(uni by u.curr) found-again)
    :-  ~[[%give %fact ~[/book-updates] %zig-wallet-update !>([%new-book -])]]
    %=  this
      tokens  -
      metadata-store  metadata-search
    ==
  ::
      [%id @ ~]
    ::  update to a transaction from a tracked account
    ?:  ?=(%watch-ack -.sign)  (on-agent:def wire sign)
    ?.  ?=(%fact -.sign)       (on-agent:def wire sign)
    ?.  ?=(%indexer-update p.cage.sign)  (on-agent:def wire sign)
    =/  =update:ui  !<(=update:ui q.cage.sign)
    ?.  ?=(%egg -.update)  `this
    =/  our-id=@ux  (slav %ux i.t.wire)
    =+  our-txs=(~(gut by transaction-store.state) our-id [sent=~ received=~])
    =/  eggs=(list [@ux =egg:smart])
      %+  turn  ~(val by eggs.update)
      |=  [@da =egg-location:ui =egg:smart]
      [(hash-egg egg) egg]
    =^  tx-status-cards=(list card)  our-txs
      %^  spin  eggs  our-txs
      |=  [[hash=@ux =egg:smart] _our-txs]
      ::  update status code and send to frontend
      ::  following error code spec in smart.hoon
      ^-  [card _our-txs] 
      :-  ?~  this-tx=(~(get by sent.our-txs) hash)
            (tx-update-card egg ~)
          (tx-update-card egg `args.u.this-tx)
      %=    our-txs
          sent
        ?.  (~(has by sent.our-txs) hash)  sent
        %+  ~(jab by sent.our-txs)  hash
        |=([p=egg:smart q=supported-args] [p(status.p status.p.egg) q])
      ::
          ::  TODO update nonce for town if tx was rejected for bad nonce (code 3)
          ::  or for lack of budget (code 4)
      ==
    :-  tx-status-cards
    this(transaction-store (~(put by transaction-store) our-id our-txs))
  ==
::
++  on-arvo  on-arvo:def
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?.  =(%x -.path)  ~
  ?+    +.path  (on-peek:def path)
      [%seed ~]
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    :~  ['mnemonic' [%s mnem.seed.state]]
        ['password' [%s pass.seed.state]]
    ==
  ::
      [%accounts ~]
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by keys.state)
    |=  [pub=@ux [priv=(unit @ux) nick=@t]]
    :-  (scot %ux pub)
    %-  pairs
    :~  ['pubkey' [%s (scot %ux pub)]]
        ['privkey' ?~(priv [%s ''] [%s (scot %ux u.priv)])]
        ['nick' [%s nick]]
        :-  'nonces'
        %-  pairs
        %+  turn  ~(tap by (~(gut by nonces.state) pub ~))
        |=  [town=@ud nonce=@ud]
        [(scot %ud town) (numb nonce)]
    ==
      [%keys ~]
    ``noun+!>(~(key by keys.state))
  ::
      [%account @ @ ~]
    ::  returns our account for the pubkey and town-id given
    ::  for validator & sequencer use, to execute mill
    =/  pub  (slav %ux i.t.t.path)
    =/  town-id  (slav %ud i.t.t.t.path)
    =/  nonce  (~(gut by (~(gut by nonces.state) pub ~)) town-id 0)
    =+  (fry-rice:smart pub `@ux`'zigs-contract' town-id `@`'zigs')
    ``noun+!>(`account:smart`[pub nonce -])
  ::
      [%book ~]
    ::  return entire book map for wallet frontend
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by tokens.state)
    |=  [pub=@ux =book]
    :-  (scot %ux pub)
    %-  pairs
    %+  turn  ~(tap by book)
    |=  [* [=token-type =grain:smart]]
    (parse-asset:wallet-parsing token-type grain)
  ::
      [%token-metadata ~]
    ::  return entire metadata-store
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by metadata-store.state)
    |=  [id=@ud d=asset-metadata]
    :-  (scot %ud id)
    %-  pairs
    :~  ['name' [%s name.d]]
        ['symbol' [%s symbol.d]]
        ?-  -.d
          %token  ['decimals' (numb decimals.d)]
          %nft  ['attributes' [%s 'TODO...']]
        ==
        ['supply' (numb supply.d)]
        ['cap' (numb (fall cap.d 0))]
        ['mintable' [%b mintable.d]]
        ['deployer' [%s (scot %ux deployer.d)]]
        ['salt' [%s (scot %ux salt.d)]]
    ==
  ::
      [%transactions @ ~]
    ::  return transaction store for given pubkey
    =/  pub  (slav %ux i.t.t.path)
    =/  our-txs=[sent=(map @ux [=egg:smart args=supported-args]) received=(map @ux =egg:smart)]
      (~(gut by transaction-store.state) pub [~ ~])
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  weld
      %+  turn  ~(tap by sent.our-txs)
      |=  [hash=@ux [t=egg:smart args=supported-args]]
      (parse-transaction:wallet-parsing hash t `args)
    %+  turn  ~(tap by received.our-txs)
    |=  [hash=@ux t=egg:smart]
    (parse-transaction:wallet-parsing hash t ~)
  ::
      [%pending ~]
    ?~  pending.state  [~ ~]
    =*  p  u.pending.state
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    :~  ['hash' [%s (scot %ux yolk-hash.p)]]
        ['egg' +:(parse-transaction:wallet-parsing 0x0 egg.p `args.p)]
    ==
  ::
      [%nodes ~]
    ::  provides a JSON array of towns we have ships known to be sequencing on
    =;  =json  ``json+!>(json)
    =,  enjs:format
    %-  pairs
    %+  turn  ~(tap by nodes.state)
    |=  [id=@ud =^ship]
    [(scot %ud id) [%s (scot %p ship)]]
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
