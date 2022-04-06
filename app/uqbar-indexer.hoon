::  uqbar-indexer:
::
::  Index blocks
::
::    Receive new blocks, index them,
::    and update subscribers with full blocks
::    or with hashes of interest
::
::
::    ## Scry paths
::
::    /x/block-height:
::      The current block height
::    /x/block-hash/[@ux]:
::      The slot with given block hash
::    /x/chunk-num/[@ud]/[@ud]:
::      The chunk with given block number/chunk number
::    /x/chunk-hash/[@ux]/[@ud]:
::      The chunk with given block hash/chunk number
::    /x/egg/[@ux]:
::      Info about egg (transaction) with the given hash
::    /x/from/[@ux]:
::      History of sender with the given hash
::    /x/grain/[@ux]:
::      State of grain with given hash
::    /x/hash/[@ux]:
::      Info about hash
::    /x/id/[@ux]:
::      History of id with the given hash
::    /x/slot:
::      The most recent slot
::    /x/slot-num/[@ud]:
::      The slot with given block number
::    /x/to/[@ux]:
::      History of receiver with the given hash
::
::
::    ## Subscription paths
::
::    /chunk/[@ud]:
::      A stream of each new chunk for a given town.
::
::    /id/[@ux]:
::      A stream of new activity of given id.
::
::    /grain/[@ux]:
::      A stream of changes to given grain.
::
::    /slot:
::      A stream of each new slot.
::
::
::    ##  Pokes
::
::    %set-chain-source:
::      Set source and subscribe to it for new blocks.
::
::    %consume-indexer-update:
::      Add a block or chunk to the index.
::
::    %serve-update:
::
::
/-  uqbar-indexer,
    zig=ziggurat
/+  agentio,
    dbug,
    default-agent,
    verb,
    smart=zig-sys-smart
::
|%
+$  card  card:agent:gall
::
+$  versioned-state
  $%  state-0
  ==
::
+$  base-state-0
  $:  chain-source=(unit dock)
      =slots:zig
      future-slots=slots:zig
      :: future-chunks=chunks:zig
      chunk-subs=(jug town-id=@ud sub=@p)
      id-subs=(jug id-hash=@ux sub=@p)
      grain-subs=(jug grain-hash=@ux sub=@p)
  ==
+$  indices-0
  $:  block-index=(jug @ux block-location:uqbar-indexer)
      egg-index=(jug @ux egg-location:uqbar-indexer)
      from-index=(jug @ux egg-location:uqbar-indexer)
      grain-index=(jug @ux town-location:uqbar-indexer)
      to-index=(jug @ux egg-location:uqbar-indexer)
  ==
+$  state-0  [%0 base-state-0 indices-0]
::
--
::
=|  state-0
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this                .
      def                 ~(. (default-agent this %|) bowl)
      io                  ~(. agentio bowl)
      uqbar-indexer-core  +>
      uic                 ~(. uqbar-indexer-core bowl)
  ::
  ++  on-init  `this
  ++  on-save  !>(state)
  ++  on-load
    |=  =old=vase
    =/  old  !<(versioned-state old-vase)
    ?-  -.old
      %0  `this(state old)
    ==
  ::
  ++  on-poke  ::  on-poke:def
    |=  [=mark =vase]
    ^-  (quip card _this)
    =^  cards  state
      ?+    mark  (on-poke:def mark vase)
      ::
          %set-chain-source
        ?>  (team:title our.bowl src.bowl)
        (set-chain-source:uic !<(dock vase))
      ::
          %consume-indexer-update
        ?>  (team:title our.bowl src.bowl)
        %-  consume-indexer-update:uic
        !<(update:uqbar-indexer vase)
      ::
      ::     %serve-update
      ::   =/  update=(unit update:uqbar-indexer)
      ::     %-  serve-update:uic
      ::     !<  :-  query-type:uqbar-indexer
      ::         query-payload:uqbar-index
      ::     vase
      ::   :_  this
      ::   ?~  update  ~  update
      ::  :: TODO: make this poke reply to src.bowl
      ::
      ==
    [cards this]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:def path)
    ::
        [%chunk @ ~]
      =/  town-id=@ud  (slav %ud i.t.path)
      `this(chunk-subs (~(put ju chunk-subs) town-id src.bowl))
    ::
        [%id @ ~]
      =/  id-hash  (slav %ux i.t.path)
      `this(id-subs (~(put ju id-subs) id-hash src.bowl))
    ::
        [%grain @ ~]
      =/  grain-hash  (slav %ux i.t.path)
      `this(grain-subs (~(put ju grain-subs) grain-hash src.bowl))
    ::
        [%slot ~]
      `this
    ::
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:def path)
    ::
        [%chunk @ ~]
      =/  town-id=@ud  (slav %ud i.t.path)
      `this(chunk-subs (~(del ju chunk-subs) town-id src.bowl))
    ::
        [%id @ ~]
      =/  id-hash  (slav %ux i.t.path)
      `this(id-subs (~(del ju id-subs) id-hash src.bowl))
    ::
        [%grain @ ~]
      =/  grain-hash  (slav %ux i.t.path)
      `this(grain-subs (~(del ju grain-subs) grain-hash src.bowl))
    ::
        [%slot ~]
      `this
    ::
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+    path  (on-peek:def path)
        [%x %block-height ~]
      ``noun+!>(`@ud`(lent slots))
    ::
        [%x %chunk-num @ @ ~]
      =/  block-num=@ud  (slav %ud i.t.t.path)
      =/  town-id=@ud  (slav %ud i.t.t.t.path)
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      (serve-update %chunk [block-num town-id])
    ::
        $?  [%x %block-hash @ ~]
            :: [%x %chunk-hash @ @ ~]
            [%x %egg @ ~]
            [%x %from @ ~]
            [%x %grain @ ~]
            [%x %to @ ~]
        ==
      =/  =query-type:uqbar-indexer  i.t.path
      =/  hash=@ux  (slav %ux i.t.t.path)
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      (serve-update query-type hash)
    ::
        [%x %slot ~]
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      ?:  =(0 (lent slots))  ~
      ?~  slot=(pry:sot:zig slots)  ~
      `[%slot val.u.slot]
    ::
        [%x %slot-num @ ~]
      =/  block-num=@ud  (slav %ud i.t.t.path)
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      (serve-update %slot block-num)
    ::
        [%x %id @ ~]
        ::  search over from and to and return all hits
      =/  hash=@ux  (slav %ux i.t.t.path)
      =/  from=(unit update:uqbar-indexer)
        (serve-update %from hash)
      =/  to=(unit update:uqbar-indexer)
        (serve-update %to hash)
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      %-  combine-update-sets:uic
      ;;  %-  list
        %-  unit
        [%egg eggs=(set [egg-location:uqbar-indexer egg:smart])]
      ~[from to]
    ::
        [%x %hash @ ~]
        ::  search over all hashes and return all hits
        ::  TODO: make blocks and grains play nice with eggs
        ::        so we can return all hits together
      =/  hash=@ux  (slav %ux i.t.t.path)
      :: =/  block-hash=(unit update:uqbar-indexer)
      ::   (serve-update %block-hash hash)
      =/  egg=(unit update:uqbar-indexer)
        (serve-update %egg hash)
      =/  from=(unit update:uqbar-indexer)
        (serve-update %from hash)
      :: =/  grain=(unit update:uqbar-indexer
      ::   (serve-update %grain hash)
      =/  to=(unit update:uqbar-indexer)
        (serve-update %to hash)
      :^  ~  ~  %noun
      !>  ^-  (unit update:uqbar-indexer)
      %-  combine-update-sets:uic
      ;;  %-  list
        %-  unit
        [%egg eggs=(set [egg-location:uqbar-indexer egg:smart])]
      ~[egg from to]
      :: (combine-update-sets:uic ~[block-hash egg from grain to])
    ::
    ==
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
    ::
        [%chain-update ~]
      ?+    -.sign  (on-agent:def wire sign)
      ::
          %kick
        :_  this
        =/  wcs=(unit card)  (watch-chain-source:uic ~)
        ?~  wcs  ~  ~[u.wcs]
      ::
          %fact
        =^  cards  state
          %-  consume-ziggurat-update:uic
          !<(update:zig q.cage.sign)
        [cards this]
      ::
      ==
    ::
    ==
  ++  on-arvo  on-arvo:def
  ++  on-fail   on-fail:def
  ::
  --
::
|_  =bowl:gall
+*  io   ~(. agentio bowl)
::
++  watch-chain-source
  |=  d=(unit dock)
  ^-  (unit card)
  =/  source=(unit dock)  (mate d chain-source)
  ?~  source  ~
  :-  ~
  %+  %~  watch  pass:io
  /chain-update  u.source  /fisherman/updates  ::  TODO: do this right
::
++  leave-chain-source
  ^-  (unit card)
  ?~  chain-source  ~
  :-  ~
  %-  %~  leave  pass:io
  /chain-update  u.chain-source
::
++  set-chain-source  :: TODO: is this properly generalized?
  |=  d=dock
  ^-  (quip card _state)
  :_  state(chain-source `d)
  ?~  watch=(watch-chain-source `d)  ~
  ~[u.watch]
:: ::  TODO: make blocks and grains play nice with eggs
:: ::        so we can return all hits together
:: ::
:: ++  combine-update-sets
::   |*  updates=(list (unit update:uqbar-indexer))
::   ^-  (unit update:uqbar-indexer)
::   ?~  updates  ~
::   =/  query-type=(unit @tas)
::     %+  roll  updates
::     |=  [update=(unit update:uqbar-indexer) query-type=(unit @tas)]
::     ?~  update  query-type
::     ?~  query-type  `-.u.update
::     ?>  =(u.query-type -.u.update)
::     u.query-type
::   ?~  query-type  ~
::   =/  combined
::     %-  silt
::     %-  zing
::     %+  murn  updates
::     |=  update=(unit update:uqbar-indexer)
::     ?~  update  ~
::     ?:  ?=(%egg -.u.update)
::       `~(tap in eggs.u.update)
::     ?:  ?=(%grain -.u.update)
::       `~(tap in grains.u.update)
::     ~
::   `[u.query-type combined]
::
++  combine-update-sets
  |=  updates=(list (unit [%egg eggs=(set [egg-location:uqbar-indexer egg:smart])]))
  ^-  (unit update:uqbar-indexer)
  ?~  updates  ~
  =/  combined=(set [egg-location:uqbar-indexer egg:smart])
    %-  %~  gas  in  *(set [egg-location:uqbar-indexer egg:smart])
    %-  zing
    %+  murn  updates
    |=  update=(unit [%egg eggs=(set [egg-location:uqbar-indexer egg:smart])])
    ?~  update  ~
    `~(tap in eggs.u.update)
  `[%egg combined]
::
++  serve-update
  |=  [=query-type:uqbar-indexer =query-payload:uqbar-indexer]
  |^  ^-  (unit update:uqbar-indexer)
  ?+    query-type  !!
  ::
      %chunk
    ?>  ?=([@ @] query-payload)
    =/  update=(unit update:uqbar-indexer)
      (get-slot block-num.query-payload)
    ?~  update  ~
    ?>  ?=(%slot -.u.update)
    ?~  q.slot.u.update  ~
    =*  chunks  q.u.q.slot.u.update
    =/  chunk=(unit chunk:zig)
      (~(get by chunks) town-id.query-payload)
    ?~  chunk  ~
    `[%chunk query-payload u.chunk]
  ::
  ::     %chunk-hash
  ::   get-chunk-update
  ::
      ?(%block-hash %egg %from %grain %to)
    get-from-index
  ::
      %slot
    ?>  ?=(@ud query-payload)
    (get-slot query-payload)
  ::
  ==
  ::
  ++  get-slot
    |=  block-num=@ud
    ^-  (unit update:uqbar-indexer)
    ?.  (lth block-num (lent slots))  ~
    ?~  slot=(get:sot:zig slots block-num)  ~
    `[%slot u.slot]
  ::
  ++  get-chunk-update
    ^-  (unit update:uqbar-indexer)
    =/  locations=(list location:uqbar-indexer)
      ~(tap in get-locations)
    ?>  =(1 (lent locations))
    =/  =location:uqbar-indexer  (snag 0 locations)
    ?>  ?=(town-location:uqbar-indexer location)
    ?~  chunk=(get-chunk block-num.location town-id.location)  ~
    `[%chunk location u.chunk]
  ::
  ++  get-from-index
    ^-  (unit update:uqbar-indexer)
    ?>  ?=(@ux query-payload)
    =/  locations=(list location:uqbar-indexer)
      ~(tap in get-locations)
    ?+    query-type  !!
    ::
        %block-hash
      ?>  =(1 (lent locations))
      =/  =location:uqbar-indexer  (snag 0 locations)
      ?>  ?=(@ location)
      (get-slot location)
    ::
        %grain
      =|  grains=(set [town-location:uqbar-indexer grain:smart])
      |-
      ?~  locations
        ?~  grains  ~
        `[%grain grains]
      =*  location  i.locations
      ?>  ?=([@ @] location)
      ?~  chunk=(get-chunk block-num.location town-id.location)
        $(locations t.locations)  :: TODO: can we do better here?
      =*  granary  p.+.u.chunk
      ?~  grain=(~(get by granary) query-payload)
        $(locations t.locations)
      %=  $
          locations  t.locations
          grains     (~(put in grains) [location u.grain])
      ==
    ::
        ?(%egg %from %to)
      =|  eggs=(set [egg-location:uqbar-indexer egg:smart])
      |-
      ?~  locations
        ?~  eggs  ~
        `[%egg eggs]
      =*  location  i.locations
      ?>  ?=([@ @ @] location)
      ?~  chunk=(get-chunk block-num.location town-id.location)
        $(locations t.locations)  :: TODO: can we do better here?
      =*  egg-num  egg-num.location
      =*  txs  -.u.chunk
      ?>  (lth egg-num (lent txs))
      =+  [hash=@ux =egg:smart]=(snag egg-num txs)
      ?>  =(query-payload hash)
      %=  $
          locations  t.locations
          eggs       (~(put in eggs) [location egg])
      ==
    ::
    ==
  ::
  ++  get-locations
    ^-  (set location:uqbar-indexer)
    ?>  ?=(@ux query-payload)
    ?+    query-type  !!
    ::
        %block-hash
      (~(get ju block-index) query-payload)
    ::
        %egg
      (~(get ju egg-index) query-payload)
    ::
        %from
      (~(get ju from-index) query-payload)
    ::
        %grain
      (~(get ju grain-index) query-payload)
    ::
        %to
      (~(get ju to-index) query-payload)
    ::
    ==
  ::
  ++  get-chunk
    |=  [block-num=@ud town-id=@ud]
    ^-  (unit chunk:zig)
    ?>  (lth block-num (lent slots))
    ?~  slot=(get:sot:zig slots block-num)  ~
    ?~  block=q.u.slot  ~
    =*  chunks  q.u.block
    (~(get by chunks) town-id)
  ::
  --
::  parse a given block into hash:location
::  pairs to be added to *-index
::
++  parse-block
  |=  [block-num=@ud =block-header:zig =block:zig]
  ^-  $:  (list [@ux block-num=@ud])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
      ==
  =/  block-hash=(list [@ux block-num=@ud])
    ~[[`@ux`data-hash.block-header block-num]]  :: TODO: should key be @uvH?
  =|  egg=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =|  from=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =|  grain=(list [@ux [block-num=@ud town-id=@ud]])
  =|  to=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =/  chunks=(list [town-id=@ud =chunk:zig])  ~(tap by q.block)
  :-  block-hash
  |-
  ?~  chunks  [egg from grain to]
  =*  town-id  town-id.i.chunks
  =*  chunk    chunk.i.chunks
  ::
  =+  [new-egg new-from new-grain new-to]=(parse-chunk block-num town-id chunk)
  %=  $
      chunks  t.chunks
      egg     (weld egg new-egg)
      from    (weld from new-from)
      grain   (weld grain new-grain)
      to      (weld to new-to)
  ==
::
++  parse-chunk
  |=  [block-num=@ud town-id=@ud =chunk:zig]
  ^-  $:  (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
      ==
  =*  txs      -.chunk
  =*  granary  p.+.chunk
  ::
  =+  new-grain=(parse-granary block-num town-id granary)
  =+  [new-egg new-from new-to]=(parse-transactions block-num town-id txs)
  [new-egg new-from new-grain new-to]
::
++  parse-granary
  |=  [block-num=@ud town-id=@ud =granary:smart]
  ^-  (list [@ux [block-num=@ud town-id=@ud]])
  =|  parsed-grain=(list [@ux [block-num=@ud town-id=@ud]])
  =/  grains=(list [@ux grain:smart])
    ~(tap by granary)
  |-
  ?~  grains  [parsed-grain]
  =*  id     id.i.grains
  =*  grain  grain.i.grains
  %=  $
      grains  t.grains
      parsed-grain
        [[id [block-num town-id]] parsed-grain]
  ==
::
++  parse-transactions
  |=  [block-num=@ud town-id=@ud txs=(list [@ux egg:smart])]
  ^-  $:  (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
          (list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
      ==
  =|  parsed-egg=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =|  parsed-from=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =|  parsed-to=(list [@ux [block-num=@ud town-id=@ud egg-num=@ud]])
  =/  egg-num=@ud  0
  |-
  ?~  txs  [parsed-egg parsed-from parsed-to]
  =*  tx-hash  -.i.txs
  =*  egg      +.i.txs
  =*  to       to.p.egg
  =*  from
    ?:  ?=(@ux from.p.egg)  from.p.egg
    id.from.p.egg
  =/  location=[@ud @ud @ud]  [block-num town-id egg-num]
  %=  $
      txs          t.txs
      parsed-egg   [[tx-hash location] parsed-egg]
      parsed-from  [[from location] parsed-from]
      parsed-to    [[to location] parsed-to]
      egg-num      +(egg-num)
  ==
::
++  consume-indexer-update
  |=  =update:uqbar-indexer
  |^  ^-  (quip card _state)
  ?+    -.update  !!  :: TODO: can we do better here?
  ::
      %slot
    =*  block-num   num.p.slot.update
    =*  new-slot    slot.update
    ?~  previous=(pry:sot:zig slots)
      :-  ~
      ?:  =(0 block-num)
        %=  state
            slots
              (put:sot:zig slots block-num new-slot)
        ==
      %=  state
          future-slots
            %^  put:sot:zig
            future-slots  block-num  new-slot
      ==
    =*  previous-block-num  key.u.previous
    ?:  (gth block-num +(previous-block-num))
      :-  ~
      %=  state
          future-slots
            %^  put:sot:zig
            future-slots  block-num  new-slot
      ==
    ::
    ?:  (lth block-num +(previous-block-num))
      ::  TODO: check if input slot has new
      ::  data and if so, add to cache and index it
      `state
    ::
    =/  previous-hash  (sham p.val.u.previous)  ::  TODO: keep up to date w current hashing method
    =*  next-hash      prev-header-hash.p.new-slot
    ?>  =(previous-hash next-hash)
    ::  store and index the new block
    ::
    ?>  ?=(^ q.new-slot)  ::  TODO: do better here
    =+  [block-hash egg from grain to]=(parse-block block-num p.new-slot u.q.new-slot)
    =:  block-index  (~(gas ju block-index) block-hash)
        egg-index    (~(gas ju egg-index) egg)
        from-index   (~(gas ju from-index) from)
        grain-index  (~(gas ju grain-index) grain)
        to-index     (~(gas ju to-index) to)
    ==
    =^  cards  future-slots
      (make-future-slots-cards block-num)
    ::  publish to subscribers
    ::
    =.  cards
      %-  zing
      :^    :_  ~  %+  fact:io
              :-  %uqbar-indexer-update
              !>(`update:uqbar-indexer`update)
            ~[/block]
          (make-all-sub-cards block-num)
        cards
      ~
    :-  cards
    state(slots (put:sot:zig slots block-num new-slot))
  ::
  ::     %chunk
  ::   =*  block-num  block-num.location.update
  ::   =*  town-id    town-id.location.update
  ::   =*  chunk      chunk.update
  ::   ::  TODO: chunk already exists?
  ::   =+  [egg from grain to]=(parse-chunk block-num town-id chunk)
  ::   =:  egg-index    (~(gas ju egg-index) egg)
  ::       from-index   (~(gas ju from-index) from)
  ::       grain-index  (~(gas ju grain-index) grain)
  ::       to-index     (~(gas ju to-index) to)
  ::   ==
  ::   ::  publish to subscribers
  ::   ::
  ::   :-  (make-all-sub-cards block-num)
  ::   state(slots (put:sot:zig slots block-num new-slot))
  ::
  ==
  ::
  ++  make-future-slots-cards
    |=  block-num=@ud
    ^-  (quip card _future-slots)
    ?~  next-slot=(get:sot:zig future-slots block-num)
      `future-slots
    =+  [* new-future-slots]=(del:sot:zig future-slots block-num)
    :_  new-future-slots
    :_  ~
    %-  %~  poke-self  pass:io  /future-slots-poke
    :-  %uqbar-indexer-update
    !>(`update:uqbar-indexer`[%slot u.next-slot])
  ::
  ++  make-all-sub-cards
    |=  block-num=@ud
    ^-  (list card)
    %-  zing
    :~  (make-sub-cards chunk-subs %ud `block-num %chunk /chunk)
        (make-sub-cards id-subs %ux ~ %from /id)
        (make-sub-cards id-subs %ux ~ %to /id)
        (make-sub-cards grain-subs %ux ~ %grain /grain)
    ==
  ::  TODO: if this is slow, could optimize by
  ::  passing in and searching over only newest
  ::  additions to index
  ::
  ++  make-sub-cards
    |=  $:  subs=(jug id=@u sub=@p)
            id-type=?(%ux %ud)
            payload-prefix=(unit @ud)
            =query-type:uqbar-indexer
            path-prefix=path
        ==
    ^-  (list card)
    %+  murn  ~(tap in ~(key by subs))
    |=  id=@u
    =/  payload=?(@u [@ud @u])
      ?~  payload-prefix  id  [u.payload-prefix id]
    ?~  update=(serve-update query-type payload)  ~
    :-  ~
    %+  fact:io
      :-  %uqbar-indexer-update
      !>(`update:uqbar-indexer`u.update)
    ~[(snoc path-prefix (scot id-type id))]
  ::
  --
::  TODO: refactor and consolidate with +consume-indexer-update
::
++  consume-ziggurat-update
  |=  =update:zig
  |^  ^-  (quip card _state)
  ?+    -.update  !!  :: TODO: can we do better here?
  ::
      %new-block
    =*  block-num   num.header.update
    ~&  >  "uqbar-indexer: got block {<block-num>}"
    ~&  >  "uqbar-indexer:  with header {<header.update>}"
    ~&  >  "uqbar-indexer:  with hash {<(sham header.update)>}"
    =/  new-slot=slot:zig  [header.update `block.update]
    ?~  previous=(pry:sot:zig slots)
      :-  ~
      ?:  =(0 block-num)
        ~&  >  "uqbar-indexer: 0"
        %=  state
            slots
              (put:sot:zig slots block-num new-slot)
        ==
      ~&  >  "uqbar-indexer: 1"
      %=  state
          future-slots
            %^  put:sot:zig
            future-slots  block-num  new-slot
      ==
    =*  previous-block-num  key.u.previous
    ?:  (gth block-num +(previous-block-num))
      ~&  >  "uqbar-indexer: 2"
      :-  ~
      %=  state
          future-slots
            %^  put:sot:zig
            future-slots  block-num  new-slot
      ==
    ::
    ?:  (lth block-num +(previous-block-num))
      ~&  >  "uqbar-indexer: 3"
      ::  TODO: check if input slot has new
      ::  data and if so, add to cache and index it
      `state
    ::
    =/  previous-hash  (sham p.val.u.previous)  ::  TODO: keep up to date w current hashing method
    =*  next-hash      prev-header-hash.p.new-slot
    ?>  =(previous-hash next-hash)
    ~&  >  "uqbar-indexer: 4"
    ::  store and index the new block
    ::
    ?>  ?=(^ q.new-slot)  ::  TODO: do better here
    =+  [block-hash egg from grain to]=(parse-block block-num p.new-slot u.q.new-slot)
    =:  block-index  (~(gas ju block-index) block-hash)
        egg-index    (~(gas ju egg-index) egg)
        from-index   (~(gas ju from-index) from)
        grain-index  (~(gas ju grain-index) grain)
        to-index     (~(gas ju to-index) to)
    ==
    =^  cards  future-slots
      (make-future-slots-cards block-num)
    ::  publish to subscribers
    ::
    =.  cards
      %-  zing
      :^    :_  ~  %+  fact:io
              :-  %uqbar-indexer-update
              !>  ^-  update:uqbar-indexer
              [%slot [header.update `block.update]]
            ~[/block]
          (make-all-sub-cards block-num)
        cards
      ~
    :-  cards
    state(slots (put:sot:zig slots block-num new-slot))
  ::
  ::     %chunk
  ::   =*  block-num  block-num.location.update
  ::   =*  town-id    town-id.location.update
  ::   =*  chunk      chunk.update
  ::   ::  TODO: chunk already exists?
  ::   =+  [egg from grain to]=(parse-chunk block-num town-id chunk)
  ::   =:  egg-index    (~(gas ju egg-index) egg)
  ::       from-index   (~(gas ju from-index) from)
  ::       grain-index  (~(gas ju grain-index) grain)
  ::       to-index     (~(gas ju to-index) to)
  ::   ==
  ::   ::  publish to subscribers
  ::   ::
  ::   :-  (make-all-sub-cards block-num)
  ::   state(slots (put:sot:zig slots block-num new-slot))
  ::
  ==
  ::
  ++  make-future-slots-cards
    |=  block-num=@ud
    ^-  (quip card _future-slots)
    ?~  next-slot=(get:sot:zig future-slots block-num)
      `future-slots
    =+  [* new-future-slots]=(del:sot:zig future-slots block-num)
    :_  new-future-slots
    :_  ~
    %-  %~  poke-self  pass:io  /future-slots-poke
    :-  %uqbar-indexer-update
    !>(`update:uqbar-indexer`[%slot u.next-slot])
  ::
  ++  make-all-sub-cards
    |=  block-num=@ud
    ^-  (list card)
    %-  zing
    :~  (make-sub-cards chunk-subs %ud `block-num %chunk /chunk)
        (make-sub-cards id-subs %ux ~ %from /id)
        (make-sub-cards id-subs %ux ~ %to /id)
        (make-sub-cards grain-subs %ux ~ %grain /grain)
    ==
  ::  TODO: if this is slow, could optimize by
  ::  passing in and searching over only newest
  ::  additions to index
  ::
  ++  make-sub-cards
    |=  $:  subs=(jug id=@u sub=@p)
            id-type=?(%ux %ud)
            payload-prefix=(unit @ud)
            =query-type:uqbar-indexer
            path-prefix=path
        ==
    ^-  (list card)
    %+  murn  ~(tap in ~(key by subs))
    |=  id=@u
    =/  payload=?(@u [@ud @u])
      ?~  payload-prefix  id  [u.payload-prefix id]
    ?~  update=(serve-update query-type payload)  ~
    :-  ~
    %+  fact:io
      :-  %uqbar-indexer-update
      !>(`update:uqbar-indexer`u.update)
    ~[(snoc path-prefix (scot id-type id))]
  ::
  --
--
