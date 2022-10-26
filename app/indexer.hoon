::  indexer [UQ| DAO]:
::
::  Index batches
::
::    Receive new batches, index them,
::    and update subscribers with full batches
::    or with hashes of interest.
::    Additionally, accept scries: one-time queries.
::
::
::    ## Scry paths
::
::    Most scry paths accept one or two `@ux` arguments.
::    A single argument is interpreted as the hash of the
::    queried item (e.g., for a `/item` query, the `item-id`).
::    For two arguments, the first is interpreted as the
::    `town-id` in which to query for the second, the item hash.
::    In other words, two arguments restricts the query to
::    a town, while one argument queries all indexed towns.
::
::    Scry paths may be prepended with a `/newest`, which
::    will return results only in the most recent batch.
::    For example, the history of all items held by
::    `0xdead.beef` would be queried using the path
::    `/x/holder/0xdead.beef`
::    while only the most recent state of all items held
::    by `0xdead.beef` would be queried using
::    `/x/newest/holder/0xdead.beef`.
::
::    Scry paths may be prepended with a `/json`, which
::    will cause the scry to return JSON rather than an
::    `update:ui` and will attempt to mold the `data` in
::    `item`s and the `yolk` in `txn`s.
::    In order to do so it requires the `source` contracts
::    have properly filled out `interface` and `types`
::    fields, see `lib/jolds.hoon` docstring for the spec
::    and `con/lib/*interface-types.hoon`
::    for examples.
::
::    When used in combination, the `/json` prefix must
::    come before the `/newest` prefix, so a valid example
::    is `/x/json/newest/holder/0xdead.beef`.
::
::    /x/batch/[batch-id=@ux]
::    /x/batch/[town-id=@ux]/[batch-id=@ux]:
::      An entire batch.
::    /x/batch-order/[town-id=@ux]
::    /x/batch-order/[town-id=@ux]/[nth-most-recent=@ud]/[how-many=@ud]:
::      The order of batches for a town, or a subset thereof.
::    /x/txn/[txn-id=@ux]:
::    /x/txn/[town-id=@ux]/[txn-id=@ux]:
::      Info about txn (transaction) with the given hash.
::    /x/from/[from-id=@ux]:
::    /x/from/[town-id=@ux]/[from-id=@ux]:
::      History of sender with the given hash.
::    /x/item/[item-id=@ux]:
::    /x/item/[town-id=@ux]/[item-id=@ux]:
::      Historical states of item with given hash.
::    :: /x/item-txns/[item-id=@ux]:  ::  TODO: reenable
::    :: /x/item-txns/[town-id=@ux]/[item-id=@ux]:
::    ::   txns involving item with given hash.
::    /x/hash/[hash=@ux]:
::    /x/hash/[town-id=@ux]/[hash=@ux]:
::      Info about hash (queries all indexes for hash).
::    /x/holder/[holder-id=@ux]:
::    /x/holder/[town-id=@ux]/[holder-id=@ux]:
::      items held by id with given hash.
::    /x/id/[id=@ux]:
::    /x/id/[town-id=@ux]/[id=@ux]:
::      History of id (queries `from`s and `to`s).
::    /x/source/[source-id=@ux]:
::    /x/source/[town-id=@ux]/[source-id=@ux]:
::      items ruled by source with given hash.
::    /x/to/[to-id=@ux]:
::    /x/to/[town-id=@ux]/[to-id=@ux]:
::      History of receiver with the given hash.
::    /x/town/[town-id=@ux]:
::    /x/town/[town-id=@ux]/[town-id=@ux]:
::      History of town: all batches.
::
::
::    ## Subscription paths
::
::    Subscribe to `/batch-order` to be informed
::    of new batches that have been indexed.
::    To update the state of a specific query per-batch,
::    subscribe to `/batch-order` and then scry that item
::    when a `%fact` is received on the subscription wire.
::
::    /batch-order/[town-id=@ux]:
::      A stream of batch ids.
::      Returns entire history of `batch-order` on-watch
::      (first batch in list is newest).
::
::
::    ##  Pokes
::
::    %indexer-bootstrap:
::      Copy state from target indexer.
::      WARNING: Overwrites current state, so should
::      only be used when bootstrapping a new indexer.
::
::    %indexer-catchup:
::      Copy state from target indexer
::      from given batch hash onward.
::
::    %set-sequencer:
::      Subscribe to sequencer for new batches.
::
::    %set-rollup:
::      Subscribe to rollup for new batch roots.
::
::
/-  engine=zig-engine,
    uqbar=zig-uqbar,
    seq=zig-sequencer,
    ui=zig-indexer
/+  agentio,
    dbug,
    default-agent,
    verb,
    indexer-lib=zig-indexer,
    smart=zig-sys-smart
::
|%
+$  card  card:agent:gall
--
::
=|  inflated-state-0:ui
=*  state  -
::
%-  agent:dbug
%+  verb  |
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this          .
      def           ~(. (default-agent this %|) bowl)
      io            ~(. agentio bowl)
      indexer-core  +>
      ic            ~(. indexer-core bowl)
      ui-lib        ~(. indexer-lib bowl)
  ::
  ++  on-init
    ::  Temporary hardcode for ~bacdun testnet
    ::   to allow easier setup.
    ::   TODO: Remove hardcode and add a GUI button/
    ::         input menu to setup.
    =/  testnet-host=@p            ~bacdun
    =/  indexer-bootstrap-host=@p  ~dister-dozzod-bacdun
    =/  rollup-dock=dock           [testnet-host %rollup]
    =/  sequencer-dock=dock        [testnet-host %sequencer]
    =/  indexer-bootstrap-dock=dock
      [indexer-bootstrap-host %indexer]
    :_  this(catchup-indexer indexer-bootstrap-dock)
    :-  %+  ~(poke-our pass:io /set-source-poke)  %uqbar
        :-  %uqbar-action
        !>  ^-  action:uqbar
        :-  %set-sources
        [0x0 (~(gas in *(set dock)) ~[[our dap]:bowl])]~
    ?:  ?|  =(testnet-host our.bowl)
            =(indexer-bootstrap-host our.bowl)
        ==
      ~
    :~  %^    watch-target:ic
            sequencer-wire
          sequencer-dock
        sequencer-path
    ::
        %^    watch-target:ic
            rollup-capitol-wire
          rollup-dock
        rollup-capitol-path
    ::
        %^    watch-target:ic
            rollup-root-wire
          rollup-dock
        rollup-root-path
    ::
        %^    watch-target:ic
            indexer-bootstrap-wire
          indexer-bootstrap-dock
        indexer-bootstrap-path
    ==
  ++  on-save  !>(-.state)
  ++  on-load
    |=  old-vase=vase
    `this(state (set-state-from-vase old-vase))
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?>  (team:title our.bowl src.bowl)
    ?+    mark  (on-poke:def mark vase)
        %set-catchup-indexer
      `this(catchup-indexer !<(dock vase))
    ::
        %set-sequencer
      :_  this
      %^    set-watch-target:ic
          sequencer-wire
        !<(dock vase)
      sequencer-path
    ::
        %set-rollup
      :_  this
      %+  weld
        %^    set-watch-target:ic
            rollup-capitol-wire
          !<(dock vase)
        rollup-capitol-path
      %^    set-watch-target:ic
          rollup-root-wire
        !<(dock vase)
      rollup-root-path
    ::
        %indexer-bootstrap
      =+  !<(indexer-bootstrap-dock=dock vase)
      :_  this(catchup-indexer indexer-bootstrap-dock)
      %^    set-watch-target:ic
          indexer-bootstrap-wire
        indexer-bootstrap-dock
      indexer-bootstrap-path
    ::
        %indexer-catchup
      =+  !<([=dock town=id:smart root=id:smart] vase)
      :_  this(catchup-indexer dock)
      %^    set-watch-target:ic
          (indexer-catchup-wire town root)
        dock
      (indexer-catchup-path town root)
    ==
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-watch:def path)
        [%ping ~]
      :_  this
      %-  fact-init-kick:io
      :-  %loob
      !>(`?`%.y)
    ::
        [%indexer-bootstrap ~]
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-bootstrap
      !>(`versioned-state:ui`-.state)
    ::
        [%indexer-catchup @ @ ~]
      =/  town-id=id:smart  (slav %ux i.t.path)
      =/  root=id:smart     (slav %ux i.t.t.path)
      =/  [=batches:ui =batch-order:ui]
        (~(gut by batches-by-town) town-id [~ ~])
      =.  batch-order  (flop batch-order)
      :_  this
      %-  fact-init-kick:io
      :-  %indexer-catchup
      !>  ^-  [batches:ui batch-order:ui]
      |-
      ?~  batch-order  [*batches:ui *batch-order:ui]
      ?:  =(root i.batch-order)  [batches (flop batch-order)]
      %=  $
          batches      (~(del by batches) i.batch-order)
          batch-order  t.batch-order
      ==
    ::
        [%batch-order @ ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %indexer-update
      !>  ^-  update:ui
      .^  update:ui
          %gx
          %+  scry:pass:io  %indexer
          (snoc `(list @ta)`path `@ta`%noun)
      ==
    ::
        [%json %batch-order @ ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %json
      !>  ^-  json
      .^  json
          %gx
          %+  scry:pass:io  %indexer
          (snoc `(list @ta)`path `@ta`%json)
      ==
    ::
        [%capitol-updates ~]
      :_  this
      :_  ~
      %-  fact:io
      :_  ~
      :-  %sequencer-capitol-update
      !>(`capitol-update:seq`[%new-capitol capitol])
    ==
  ::
  ++  on-leave
    |=  =path
    ^-  (quip card _this)
    ?+    path  (on-leave:def path)
        $?  [%batch-order @ ~]
            [%json %batch-order @ ~]
            [%capitol-updates ~]
        ==
      `this
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?:  =(/x/dbug/state path)
      ``[%noun !>(`_state`state)]
    ?.  ?=  $?  [@ @ @ ~]  [@ @ @ @ @ @ ~]
                [@ @ @ @ ~]  [@ @ @ @ @ ~]
            ==
        path
      :^  ~  ~  %indexer-update
      !>(`update:ui`[%path-does-not-exist ~])
    ::
    =/  is-json=?      ?=(%json i.t.path)
    =/  only-newest=?
      ?.  is-json  ?=(%newest i.t.path)
      ?=(%newest i.t.t.path)
    =/  args=^path
      =/  num=@ud  (add is-json only-newest)
      ?:  =(2 num)  t.path
      ?:  =(1 num)  t.t.path
      ?:  =(0 num)  t.t.t.path
      !!
    |^
    ?+    args  :^  ~  ~  %indexer-update
                !>(`update:ui`[%path-does-not-exist ~])
        ?([%hash @ ~] [%hash @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      (get-hashes u.query-payload only-newest %.y)
    ::
        ?([%id @ ~] [%id @ @ ~])
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      (get-ids u.query-payload only-newest)
    ::
        $?  [%batch @ ~]       [%batch @ @ ~]
            [%txn @ ~]         [%txn @ @ ~]
            [%from @ ~]        [%from @ @ ~]
            [%item @ ~]        [%item @ @ ~]
            :: [%item-txns @ ~]   [%item-txns @ @ ~]
            [%holder @ ~]      [%holder @ @ ~]
            [%source @ ~]      [%source @ @ ~]
            [%to @ ~]          [%to @ @ ~]
            [%town @ ~]       [%town @ @ ~]
        ==
      =/  =query-type:ui  ;;(query-type:ui i.args)
      =/  query-payload=(unit query-payload:ui)
        read-query-payload-from-args
      %-  make-peek-update
      ?~  query-payload  [%path-does-not-exist ~]
      %:  serve-update
          query-type
          u.query-payload
          only-newest
          %.y
      ==
    ::
        [%batch-order @ ~]
      =/  town-id=@ux  (slav %ux i.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-town) town-id)  ~
      [%batch-order batch-order.u.bs]
    ::
        [%batch-order @ @ @ ~]
      =/  [town-id=@ux nth-most-recent=@ud how-many=@ud]
        :+  (slav %ux i.t.args)  (slav %ud i.t.t.args)
        (slav %ud i.t.t.t.args)
      %-  make-peek-update
      ?~  bs=(~(get by batches-by-town) town-id)  ~
      :-  %batch-order
      (swag [nth-most-recent how-many] batch-order.u.bs)
    ==
    ::
    ++  make-peek-update
      |=  =update:ui
      ?.  is-json
        [~ ~ %indexer-update !>(`update:ui`update)]
      [~ ~ %json !>(`json`(update:enjs:ui-lib update))]
    ::
    ++  read-query-payload-from-args
      ^-  (unit query-payload:ui)
      ?:  ?=([@ @ ~] args)  `(slav %ux i.t.args)
      ?.  ?=([@ @ @ ~] args)  ~
      `[(slav %ux i.t.args) (slav %ux i.t.t.args)]
    --
  ::
  ++  on-agent
    |=  [=wire =sign:agent:gall]
    |^  ^-  (quip card _this)
    ?+    wire  (on-agent:def wire sign)
        ?([%rollup-capitol-update ~] [%rollup-root-update ~])
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =^  cards  state
          %-  consume-rollup-update
          !<(rollup-update:seq q.cage.sign)
        [cards this]
      ::
          %kick
        :_  this
        %^    set-watch-target:ic
            wire
          [src.bowl %rollup]  ::  TODO: remove hardcode
        ?:  ?=(%rollup-root-update -.wire)
          rollup-root-path
        rollup-capitol-path
      ==
    ::
        [%sequencer-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        =^  cards  state
          %-  consume-sequencer-update
          !<(indexer-update:seq q.cage.sign)
        [cards this]
      ::
          %kick
        :_  this
        %^    set-watch-target:ic
            sequencer-wire
          [src.bowl %sequencer]  ::  TODO: remove hardcode
        sequencer-path
      ==
    ::
        [%indexer-bootstrap-update ~]
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        ::  Reset state to initial conditions: this happens
        ::   automagically `+on-load`, but not here.
        ::   If don't do this, can get bad state starting
        ::   up a new indexer.
        =:  batches-by-town         ~
            capitol                 ~
            sequencer-update-queue  ~
            town-update-queue       ~
            txn-index               ~
            from-index              ~
            item-index              ~
            :: item-txns-index         ~
            holder-index            ~
            source-index            ~
            to-index                ~
            newest-batch-by-town    ~
        ==
        `this(state (set-state-from-vase q.cage.sign))
      ==
    ::
        [%indexer-catchup-update @ @ ~]
      =/  town-id=id:smart  (slav %ux i.t.wire)
      =/  root=id:smart      (slav %ux i.t.t.wire)
      ?+    -.sign  (on-agent:def wire sign)
          %fact
        :-  ~
        =+  !<([=batches:ui =batch-order:ui] q.cage.sign)
        =/  old=(unit (pair batches:ui batch-order:ui))
          (~(get by batches-by-town) town-id)
        ?~  old
          %=  this
              batches-by-town
            %+  ~(put by batches-by-town)  town-id
            [batches batch-order]
          ==
        =/  root-index=@ud
          ?~(i=(find ~[root] q.u.old) 0 +(u.i))
        =.  batches-by-town
          %+  ~(put by batches-by-town)  town-id
          :-  (~(uni by p.u.old) batches)
          (weld batch-order (slag root-index q.u.old))
        %=  this
            sequencer-update-queue  ~
            town-update-queue       ~
            +.state
          %-  inflate-state
          ~(tap by batches-by-town)
        ==
      ==
    ==
    ::
    ++  has-root-already
      |=  [town-id=id:smart root=id:smart]
      ^-  ?
      =/  [=batches:ui *]
        %+  %~  gut  by  batches-by-town
        town-id  [*batches:ui *batches-by-town:ui]
      (~(has by batches) root)
    ::
    ++  consume-sequencer-update
      |=  update=indexer-update:seq
      ^-  (quip card _state)
      ?-    -.update
          %update
        =*  town-id  town-id.hall.update
        =*  root     root.update
        ?:  (has-root-already town-id root)  `state
        ?.  =(root (sham chain.update))       `state
        =/  timestamp=(unit @da)
          %.  root
          %~  get  by
          %+  ~(gut by town-update-queue)  town-id
          *(map @ux @da)
        ?~  timestamp
          :-  ~
          %=  state
              sequencer-update-queue
            %+  ~(put by sequencer-update-queue)  town-id
            %+  %~  put  by
                %+  ~(gut by sequencer-update-queue)  town-id
                *(map @ux batch:ui)
              root
            [transactions.update [chain.update hall.update]]
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              transactions.update
              [chain.update hall.update]
              u.timestamp
              %.y
          ==
        :-  cards
        %=  state
            town-update-queue
          %+  ~(put by town-update-queue)  town-id
          %.  root
          ~(del by (~(got by town-update-queue) town-id))
        ==
      ==
    ::
    ++  consume-rollup-update
      |=  update=rollup-update:seq
      |^  ^-  (quip card _state)
      ?-    -.update
          %new-sequencer
        `state
      ::
          %new-capitol
        :_  state(capitol capitol.update)
        :-  %+  fact:io
              :-  %sequencer-capitol-update
              !>(`capitol-update:seq`update)
            :+  rollup-capitol-path
              (snoc rollup-capitol-path %no-init)
            ~
        ?:  (only-missing-newest capitol.update)  ~
        %+  murn  ~(val by capitol.update)
        |=  [town-id=id:smart @ [@ @] [@ *] @ roots=(list @ux)]
        =/  [* =batch-order:ui]
          %+  ~(gut by batches-by-town)  town-id
          [~ batch-order=~]
        =/  needed-list=(list id:smart)
          (find-needed-batches roots batch-order)
        ?~  needed-list  ~
        =*  root  i.needed-list
        :-  ~
        %^    watch-target:ic
            (indexer-catchup-wire town-id root)
          catchup-indexer
        (indexer-catchup-path town-id root)
      ::
          %new-peer-root
        =*  town-id  town.update
        =*  root     root.update
        ?:  (has-root-already town-id root)  `state
        =/  sequencer-update
          ^-  (unit [txns=(list [@ux transaction:smart]) =town:seq])
          %.  root
          %~  get  by
          %+  ~(gut by sequencer-update-queue)  town-id
          *(map @ux batch:ui)
        ?~  sequencer-update
          :-  ~
          %=  state
              town-update-queue
            %+  ~(put by town-update-queue)  town-id
            %+  %~  put  by
                %+  ~(gut by town-update-queue)  town-id
                *(map batch-id=@ux timestamp=@da)
            root  timestamp.update
          ==
        =^  cards  state
          %:  consume-batch:ic
              root
              txns.u.sequencer-update
              town.u.sequencer-update
              timestamp.update
              %.y
          ==
        :-  cards
        %=  state
            sequencer-update-queue
          %+  ~(jab by sequencer-update-queue)  town-id
          |=  queue=(map @ux batch:ui)
          (~(del by queue) root)
        ==
      ==
      ::
      ++  find-needed-batches  ::  TODO: only return id where diff begins?
        |=  [capitol=(list id:smart) batch-order=(list id:smart)]
        ^-  (list id:smart)
        =.  batch-order  (flop batch-order)
        ?:  =(capitol batch-order)  ~
        =|  needed=(list id:smart)
        |-
        ?~  capitol  (flop needed)
        ?~  batch-order
          $(capitol t.capitol, needed [i.capitol needed])
        ?:  =(i.capitol i.batch-order)
          $(capitol t.capitol, batch-order t.batch-order)
        %=  $
            capitol      t.capitol
            batch-order  t.batch-order
            needed       [i.capitol needed]
        ==
      ::
      ++  only-missing-newest
        |=  new-capitol=capitol:seq
        ^-  ?
        =/  town-ids=(list id:smart)
          ~(tap in ~(key by new-capitol))
        |-
        ?~  town-ids  %.y
        =*  town-id  i.town-ids
        =/  old-roots=batch-order:ui
          roots:(~(gut by capitol) town-id *hall:seq)
        =/  new-roots=batch-order:ui
          roots:(~(gut by new-capitol) town-id *hall:seq)
        ?~  old-roots  $(town-ids t.town-ids)
        ?~  new-roots  %.n
        =/  l-old=@ud  (lent old-roots)
        =/  l-new=@ud  (lent new-roots)
        ?.  |(=(l-old l-new) =(l-old (dec l-new)))  %.n
        $(town-ids t.town-ids)
      --
    --
  ::
  ++  on-arvo  on-arvo:def
  ++  on-fail  on-fail:def
  --
::
|_  =bowl:gall
+*  io      ~(. agentio bowl)
    ui-lib  ~(. indexer-lib bowl)
::
++  rollup-capitol-wire
  ^-  wire
  /rollup-capitol-update
::
++  rollup-root-wire
  ^-  wire
  /rollup-root-update
::
++  sequencer-wire
  ^-  wire
  /sequencer-update
::
++  indexer-bootstrap-wire
  ^-  wire
  /indexer-bootstrap-update
::
++  indexer-catchup-wire
  |=  [town-id=id:smart root=id:smart]
  ^-  wire
  /indexer-catchup-update/(scot %ux town-id)/(scot %ux root)
::
++  rollup-capitol-path
  ^-  path
  /capitol-updates
::
++  rollup-root-path
  ^-  path
  /peer-root-updates
::
++  sequencer-path
  ^-  path
  /indexer/updates
::
++  indexer-bootstrap-path
  ^-  path
  /indexer-bootstrap
::
++  indexer-catchup-path
  |=  [town-id=id:smart root=id:smart]
  ^-  path
  /indexer-catchup/(scot %ux town-id)/(scot %ux root)
::
++  watch-target
  |=  [w=wire d=dock p=path]
  ^-  card
  (~(watch pass:io w) d p)
::
++  leave-wire
  |=  w=wire
  ^-  (unit card)
  =/  old-source=(unit dock)
    (get-wex-dock-by-wire w)
  ?~  old-source  ~
  :-  ~
  %-  ~(leave pass:io w)
  u.old-source
::
++  set-watch-target
  |=  [w=wire d=dock p=path]
  ^-  (list card)
  =/  watch-card=card  (watch-target w d p)
  =/  leave-card=(unit card)  (leave-wire w)
  ?~  leave-card  ~[watch-card]
  ~[u.leave-card watch-card]
::
++  get-wex-dock-by-wire
  |=  w=wire
  ^-  (unit dock)
  ?:  =(0 ~(wyt by wex.bowl))  ~
  =/  wexs=(list [w=wire s=ship t=term])
    ~(tap in ~(key by wex.bowl))
  |-
  ?~  wexs  ~
  =*  wex  i.wexs
  ?.  =(w w.wex)
    $(wexs t.wexs)
  :-  ~
  [s.wex t.wex]
::
++  get-batch
  |=  [town-id=id:smart batch-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  bs=(~(get by batches-by-town) town-id)  ~
  ?~  b=(~(get by batches.u.bs) batch-root)     ~
  `[batch-root u.b]
::
++  get-newest-batch
  |=  [town-id=id:smart expected-root=id:smart]
  ^-  (unit [batch-id=id:smart timestamp=@da =batch:ui])
  ?~  b=(~(get by newest-batch-by-town) town-id)  ~
  ?.  =(expected-root batch-id.u.b)                 ~
  `u.b
::
++  combine-txn-updates
  |=  updates=(list update:ui)
  ^-  update:ui
  ?~  update=(combine-txn-updates-to-map updates)  ~
  [%txn update]
::
++  get-ids
  |=  [qp=query-payload:ui only-newest=?]
  ^-  update:ui
  =/  from=update:ui  (serve-update %from qp only-newest %.n)
  =/  to=update:ui    (serve-update %to qp only-newest %.n)
  (combine-txn-updates ~[from to])
::
++  get-hashes
  |=  [qp=query-payload:ui only-newest=? should-filter=?]
  ^-  update:ui
  =*  options  [only-newest should-filter]
  =/  batch=update:ui   (serve-update %batch qp options)
  =/  txn=update:ui     (serve-update %txn qp options)
  =/  from=update:ui    (serve-update %from qp options)
  =/  item=update:ui    (serve-update %item qp options)
  =/  holder=update:ui  (serve-update %holder qp options)
  =/  source=update:ui  (serve-update %source qp options)
  =/  to=update:ui      (serve-update %to qp options)
  =/  town=update:ui   (serve-update %town qp options)
  :: =/  item-txns=update:ui
  ::   (serve-update %item-txns qp only-newest)
  %^  combine-updates  ~[batch town]  ~[txn from to]
  ~[item holder source]
::
++  combine-batch-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da town-location:ui batch:ui])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da town-location:ui batch:ui])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%batch -.update)
    ?.  ?=(%newest-batch -.update)  ~
    [+.update]~
  ~(tap by batches.update)
::
++  combine-txn-updates-to-map
  |=  updates=(list update:ui)
  ^-  (map id:smart [@da txn-location:ui transaction:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(map id:smart [@da txn-location:ui transaction:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%txn -.update)
    ?.  ?=(%newest-txn -.update)  ~
    [+.update]~
  ~(tap by txns.update)
::
++  combine-item-updates-to-jar  ::  TODO: can this clobber?
  |=  updates=(list update:ui)
  ^-  (jar id:smart [@da batch-location:ui item:smart])
  ?~  updates  ~
  %-  %~  gas  by
      *(jar id:smart [@da batch-location:ui item:smart])
  %-  zing
  %+  turn  updates
  |=  =update:ui
  ?~  update  ~
  ?.  ?=(%item -.update)
    ?.  ?=(%newest-item -.update)  ~
    :_  ~
    :-  item-id.update
    [timestamp.update location.update item.update]~
  ~(tap by items.update)
::
++  combine-updates
  |=  $:  batch-updates=(list update:ui)
          txn-updates=(list update:ui)
          item-updates=(list update:ui)
      ==
  ^-  update:ui
  ?:  ?&  ?=(~ batch-updates)
          ?=(~ txn-updates)
          ?=(~ item-updates)
      ==
    ~
  =/  combined-batch=(map id:smart [@da town-location:ui batch:ui])
    (combine-batch-updates-to-map batch-updates)
  =/  combined-txn=(map id:smart [@da txn-location:ui transaction:smart])
    (combine-txn-updates-to-map txn-updates)
  =/  combined-item=(jar id:smart [@da batch-location:ui item:smart])
    (combine-item-updates-to-jar item-updates)
  ?:  ?&  ?=(~ combined-batch)
          ?=(~ combined-txn)
          ?=(~ combined-item)
      ==
    ~
  [%hash combined-batch combined-txn combined-item]
::
++  set-state-from-vase
  |=  state-vase=vase
  ^-  _state
  =+  !<(vs=versioned-state:ui state-vase)
  ?-    -.vs
      %0
    :-  vs(catchup-indexer catchup-indexer)
    %-  inflate-state
    ~(tap by batches-by-town.vs)
  ==
::
++  inflate-state
  |=  batches-by-town-list=(list [@ux =batches:ui =batch-order:ui])
  ^-  indices-0:ui
  =|  temporary-state=_state
  |^
  ?~  batches-by-town-list  +.temporary-state
  =/  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    %+  murn  (flop batch-order.i.batches-by-town-list)
    |=  =id:smart
    ?~  batch=(~(get by batches.i.batches-by-town-list) id)
      ~
    `[id u.batch]
  %=  $
      batches-by-town-list  t.batches-by-town-list
      temporary-state       (inflate-town batches-list)
  ==
  ::
  ++  inflate-town
    |=  batches-list=(list [root=@ux timestamp=@da =batch:ui])
    ^-  _state
    |-
    ?~  batches-list  temporary-state
    =^  cards  temporary-state  ::  throw away cards (empty)
      %:  consume-batch(state temporary-state)
          root.i.batches-list
          transactions.batch.i.batches-list
          +.batch.i.batches-list
          timestamp.i.batches-list
          %.n
      ==
    %=  $
        batches-list     t.batches-list
        temporary-state  temporary-state
    ==
  --
::
++  serve-update
  |=  $:  =query-type:ui
          =query-payload:ui
          only-newest=?
          should-filter=?
      ==
  ^-  update:ui
  =/  get-appropriate-batch
    ?.(only-newest get-batch get-newest-batch)
  |^
  ?+    query-type  ~
      %batch
    get-batch-update
  ::
      :: ?(%txn %from %item %item-txns %holder %source %to)
      ?(%txn %from %item %holder %source %to)
    get-from-index
  ::
      %town
    get-town
  ==
  ::
  ++  get-town
    ?.  ?=(@ query-payload)  ~
    =*  town-id  query-payload
    ?~  bs=(~(get by batches-by-town) town-id)  ~
    ?:  only-newest
      ?~  batch-order.u.bs  ~
      =*  batch-id  i.batch-order.u.bs
      ?~  b=(~(get by batches.u.bs) batch-id)  ~
      :-  %newest-batch
      [batch-id timestamp.u.b town-id batch.u.b]
    :-  %batch
    %-  %~  gas  by
        *(map id:smart [@da town-location:ui batch:ui])
    %+  turn  ~(tap by batches.u.bs)
    |=  [batch-id=id:smart timestamp=@da =batch:ui]
    [batch-id [timestamp town-id batch]]
  ::
  ++  get-batch-update
    ?:  ?=([@ @] query-payload)
      =*  town-id   -.query-payload
      =*  batch-id  +.query-payload
      ?~  b=(get-appropriate-batch town-id batch-id)  ~
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
      :-  %batch
      %+  %~  put  by
          *(map id:smart [@da town-location:ui batch:ui])
      batch-id  [timestamp town-id batch]
    ?.  ?=(@ query-payload)  ~
    =*  batch-id  query-payload
    =/  out=[%batch (map id:smart [@da town-location:ui batch:ui])]
      %+  roll  ~(tap in ~(key by batches-by-town))
      |=  $:  town-id=id:smart
              out=[%batch (map id:smart [@da town-location:ui batch:ui])]
          ==
      ?~  b=(get-appropriate-batch town-id batch-id)  out
      =*  timestamp  timestamp.u.b
      =*  batch      batch.u.b
      :-  %batch
      (~(put by +.out) batch-id [timestamp town-id batch])
    ?~(+.out ~ out)
  ::
  ++  get-from-index
    ^-  update:ui
    ?.  ?=(?(@ [@ @]) query-payload)  ~
    =/  locations=(list location:ui)  get-locations
    |^
    ?+    query-type  ~
        %item
      get-item
    ::
        %txn
      get-txn
    ::
        :: ?(%from %item-txns %holder %source %to)
        ?(%from %holder %source %to)
      get-second-order
    ==
    ::
    ++  get-item
      =/  item-id=id:smart
        ?:  ?=([@ @] query-payload)  +.query-payload
        query-payload
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(batch-location:ui location)  ~
        =*  town-id     town-id.location
        =*  batch-root  batch-root.location
        ?~  b=(get-appropriate-batch town-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  TODO: remove this check if we never see this log
          ~&  >>>  "%indexer: unexpected batch root (item)"
          ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
          ~
        =*  timestamp  timestamp.u.b
        =*  state    p.chain.batch.u.b
        ?~  item=(get:big:engine state item-id)  ~
        [%newest-item item-id timestamp location u.item]
      =|  items=(jar item-id=id:smart [@da batch-location:ui item:smart])
      =.  locations  (flop locations)
      |-
      ?~  locations  ?~(items ~ [%item items])
      =*  location  i.locations
      ?.  ?=(batch-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      ?~  b=(get-appropriate-batch town-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  TODO: remove this check if we never see this log
        ~&  >>>  "%indexer: unexpected batch root (item)"
        ~&  >>>  "br, bid: {<batch-root>} {<batch-id.u.b>}"
        $(locations t.locations)
      =*  timestamp  timestamp.u.b
      =*  state    p.chain.batch.u.b
      ?~  item=(get:big:engine state item-id)
        $(locations t.locations)
      %=  $
          locations  t.locations
          items
        %+  ~(add ja items)  item-id
        [timestamp location u.item]
      ==
    ::
    ++  get-txn
      ?:  only-newest  ::  TODO: DRY
        ?~  locations  ~
        =*  location  i.locations
        ?.  ?=(txn-location:ui location)  ~
        =*  town-id     town-id.location
        =*  batch-root  batch-root.location
        =*  txn-num     txn-num.location
        ?~  b=(get-appropriate-batch town-id batch-root)  ~
        ?.  |(!only-newest =(batch-root batch-id.u.b))
          ::  happens for second-order only-newest queries that
          ::   resolve to txns because get-locations does not
          ::   guarantee they are in the newest batch
          ~
        =*  timestamp  timestamp.u.b
        =*  txs        transactions.batch.u.b
        ?.  (lth txn-num (lent txs))  ~
        =+  [hash=@ux txn=transaction:smart]=(snag txn-num txs)
        [%newest-txn hash timestamp location txn]
      =|  txns=(map id:smart [@da txn-location:ui transaction:smart])
      |-
      ?~  locations  ?~(txns ~ [%txn txns])
      =*  location  i.locations
      ?.  ?=(txn-location:ui location)
        $(locations t.locations)
      =*  town-id     town-id.location
      =*  batch-root  batch-root.location
      =*  txn-num     txn-num.location
      ?~  b=(get-appropriate-batch town-id batch-root)
        $(locations t.locations)
      ?.  |(!only-newest =(batch-root batch-id.u.b))
        ::  happens for second-order only-newest queries that
        ::   resolve to txns because get-locations does not
        ::   guarantee they are in the newest batch
        $(locations t.locations)
      =*  timestamp  timestamp.u.b
      =*  txs        transactions.batch.u.b
      ?.  (lth txn-num (lent txs))  $(locations t.locations)
      =+  [hash=@ux txn=transaction:smart]=(snag txn-num txs)
      %=  $
          locations  t.locations
          txns
        (~(put by txns) hash [timestamp location txn])
      ==
    ::
    ++  get-second-order
      =/  first-order-type=?(%txn %item)
        ?:  |(?=(%holder query-type) ?=(%source query-type))
          %item
        %txn
      |^
      =/  =update:ui  create-update
      ?~  update  ~
      ?+    -.update  ~|("indexer: get-second-order unexpected return type" !!)
          %newest-txn  update
          %txn         update
      ::
          %newest-item
        ?.  should-filter  update
        ?.((is-item-hit +.+.update) ~ update)
      ::
          %item
        %=  update
            items
          ?.  should-filter  items.update
          (filter-items items.update)
        ==
      ==
      ::
      ++  is-item-hit
        |=  value=item-update-value:ui
        ^-  ?
        =/  query-hash=id:smart
          ?:  ?=(@ query-payload)  query-payload
          ?>  ?=([@ @] query-payload)
          +.query-payload
        =*  holder  holder.p.item.value
        =*  source    source.p.item.value
        ?|  &(?=(%holder query-type) =(query-hash holder))
            &(?=(%source query-type) =(query-hash source))
        ==
      ::
      ++  filter-items  ::  TODO: generalize w/ `+diff-update-items`
        |=  items=(jar id:smart item-update-value:ui)
        ^-  (jar id:smart item-update-value:ui)
        %-  %~  gas  by
            *(map id:smart (list item-update-value:ui))
        %+  roll  ~(tap by items)
        |=  $:  [item-id=id:smart values=(list item-update-value:ui)]
                out=(list [id:smart (list item-update-value:ui)])
            ==
        =/  filtered-values=(list item-update-value:ui)
          %+  roll  values
          |=  $:  =item-update-value:ui
                  inner-out=(list item-update-value:ui)
              ==
          ?.  (is-item-hit item-update-value)  inner-out
          [item-update-value inner-out]
        ?~  filtered-values  out
        [[item-id (flop filtered-values)] out]
      ::
      ++  create-update
        ^-  update:ui
        %+  roll  locations
        |=  $:  second-order-id=location:ui
                out=update:ui
            ==
        =/  next-update=update:ui
          %=  get-from-index
              query-payload  second-order-id
              query-type     first-order-type
          ==
        ?~  next-update  out
        ?~  out          next-update
        ?+    -.out  ~|("indexer: get-second-order unexpected update type {<-.out>}" !!)
            %txn
          ?.  ?=(?(%txn %newest-txn) -.next-update)  out
          %=  out
              txns
            ?:  ?=(%txn -.next-update)
              (~(uni by txns.out) txns.next-update)
            ?>  ?=(%newest-txn -.next-update)
            (~(put by txns.out) +.next-update)
          ==
        ::
            %item
          ?.  ?=(?(%item %newest-item) -.next-update)  out
          %=  out
              items
            ?:  ?=(%item -.next-update)
              (~(uni by items.out) items.next-update)  ::  TODO: can this clobber?
            ?>  ?=(%newest-item -.next-update)
            (~(add ja items.out) +.next-update)
          ==
        ::
            %newest-txn
          ?+    -.next-update  out
              %txn
            %=  next-update
                txns
              (~(put by txns.next-update) +.out)
            ==
          ::
              %newest-txn
            :-  %txn
            %.  ~[+.out +.next-update]
            %~  gas  by
            *(map id:smart [@da txn-location:ui transaction:smart])
          ==
        ::
            %newest-item
          ?+    -.next-update  out
              %item
            %=  next-update
                items
              (~(add ja items.next-update) +.out)  ::  TODO: ordering?
            ==
          ::
              %newest-item
            :-  %item
            %.  +.next-update
            %~  add  ja
            %.  +.out
            %~  add  ja
            *(jar id:smart item-update-value:ui)
          ==
        ==
      --
    --
  ::
  ++  get-locations
    |^  ^-  (list location:ui)
    ?+  query-type  ~|("indexer: get-locations unexpected query-type {<query-type>}" !!)
      %txn         (get-by-get-ja txn-index only-newest)
      %from        (get-by-get-ja from-index %.n)
      %item        (get-by-get-ja item-index only-newest)
      :: %item-txns   (get-by-get-ja item-txns-index %.n)
      %holder      (get-by-get-ja holder-index %.n)
      %source      (get-by-get-ja source-index %.n)
      %to          (get-by-get-ja to-index %.n)
    ==
    ::  always set `only-newest` false for
    ::   second-order indices or will
    ::   throw away unique txns/items.
    ::   Concretely, txn/item indices hold historical
    ::   state for a given hash, while second-order
    ::   indices hold different txns/items that hash
    ::   has appeared in (e.g. different items with a
    ::   given holder).
    ::
    ++  get-by-get-ja
      |=  [index=(map @ux (jar @ux location:ui)) only-newest=?]
      ^-  (list location:ui)
      ?:  ?=([@ @] query-payload)
        =*  town-id    -.query-payload
        =*  item-hash   +.query-payload
        ?~  town-index=(~(get by index) town-id)     ~
        ?~  items=(~(get ja u.town-index) item-hash)  ~
        ?:(only-newest ~[i.items] items)
      ?.  ?=(@ query-payload)  ~
      =*  item-hash  query-payload
      %+  roll  ~(val by index)
      |=  [town-index=(jar @ux location:ui) out=(list location:ui)]
      ?~  items=(~(get ja town-index) item-hash)  out
      ?:  only-newest  [i.items out]
      (weld out (~(get ja town-index) item-hash))
    --
  --
::
++  consume-batch
  |=  $:  root=@ux
          txns=(list [@ux transaction:smart])
          =town:seq
          timestamp=@da
          should-update-subs=?
      ==
  =*  town-id  town-id.hall.town
  |^  ^-  (quip card _state)
  =+  ^=  [txn from item holder source to]
      (parse-batch root town-id txns chain.town)
  =:  txn-index        (gas-ja-txn txn-index txn town-id)
      from-index       (gas-ja-second-order from-index from town-id)
      item-index       (gas-ja-batch item-index item town-id)
      :: item-txns-index  (gas-ja-second-order item-txns-index item-txns town-id)
      holder-index     (gas-ja-second-order holder-index holder town-id)
      source-index     (gas-ja-second-order source-index source town-id)
      to-index         (gas-ja-second-order to-index to town-id)
      newest-batch-by-town
    ::  only update newest-batch-by-town with newer batches
    ?:  %+  gth
          ?~  current=(~(get by newest-batch-by-town) town-id)
            *@da
          timestamp.u.current
        timestamp
      newest-batch-by-town
    %+  ~(put by newest-batch-by-town)  town-id
    [root timestamp txns town]
  ::
      batches-by-town
    %+  ~(put by batches-by-town)  town-id
    ?~  b=(~(get by batches-by-town) town-id)
      :_  ~[root]
      (malt ~[[root [timestamp txns town]]])
    :_  [root batch-order.u.b]
    (~(put by batches.u.b) root [timestamp txns town])
  ==
  ::
  :_  state
  ?.(should-update-subs ~ make-sub-cards)
  ::
  ++  gas-ja-txn
    |=  $:  index=txn-index:ui
            new=(list [hash=@ux location=txn-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux txn-location:ui)
      ?~(ti=(~(get by index) town-id) ~ u.ti)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-batch
    |=  $:  index=batch-index:ui
            new=(list [hash=@ux location=batch-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux batch-location:ui)
      ?~(ti=(~(get by index) town-id) ~ u.ti)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  gas-ja-second-order
    |=  $:  index=second-order-index:ui
            new=(list [hash=@ux location=second-order-location:ui])
            town-id=id:smart
        ==
    %+  ~(put by index)  town-id
    =/  town-index=(jar @ux second-order-location:ui)
      (~(gut by index) town-id ~)
    |-
    ?~  new  town-index
    %=  $
        new  t.new
        town-index
      (~(add ja town-index) hash.i.new location.i.new)
    ==
  ::
  ++  make-sub-cards
    ^-  (list card)
    =/  update-path=path
      /batch-order/(scot %ux town-id)
    ?~  (find [update-path]~ (turn ~(val by sup.bowl) |=([@ p=path] p)))
      ~
    :_  ~
    %-  fact:io
    :_  ~[update-path]
    [%indexer-update !>(`update:ui`[%batch-order ~[root]])]
  ::
  ++  parse-batch
    |=  $:  root=@ux
            town-id=@ux
            txns=(list [@ux transaction:smart])
            =chain:seq
        ==
    ^-  $:  (list [@ux txn-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =+  [item holder source]=(parse-state root town-id p.chain)
    =+  [txn from to]=(parse-transactions root town-id txns)
    [txn from item holder source to]
  ::
  ++  parse-state
    |=  [root=@ux town-id=@ux =state:seq]
    ^-  $:  (list [@ux batch-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-item=(list [@ux batch-location:ui])
    =|  parsed-holder=(list [@ux second-order-location:ui])
    =|  parsed-source=(list [@ux second-order-location:ui])
    =/  items=(list [@ux [@ux item:smart]])
      ~(tap by state)
    |-
    ?~  items  [parsed-item parsed-holder parsed-source]
    =*  item-id   id.p.+.+.i.items
    =*  holder-id  holder.p.+.+.i.items
    =*  source-id    source.p.+.+.i.items
    %=  $
        items         t.items
    ::
        parsed-holder
      ?:  %+  exists-in-index  town-id
          [holder-id item-id holder-index]
        parsed-holder
      [[holder-id item-id] parsed-holder]
    ::
        parsed-source
      ?:  %+  exists-in-index  town-id
          [source-id item-id source-index]
        parsed-source
      [[source-id item-id] parsed-source]
    ::
        parsed-item
      ?:  %+  exists-in-index  town-id
          [item-id [town-id root] item-index]
        parsed-item
      :_  parsed-item
      :-  item-id
      [town-id root]
    ==
  ::
  ++  parse-transactions
    |=  [root=@ux town-id=@ux txs=(list [@ux transaction:smart])]
    ^-  $:  (list [@ux txn-location:ui])
            (list [@ux second-order-location:ui])
            (list [@ux second-order-location:ui])
        ==
    =|  parsed-txn=(list [@ux txn-location:ui])
    =|  parsed-from=(list [@ux second-order-location:ui])
    =|  parsed-to=(list [@ux second-order-location:ui])
    =/  txn-num=@ud  0
    |-
    ?~  txs  [parsed-txn parsed-from parsed-to]
    =*  txn-hash     -.i.txs
    =*  txn          +.i.txs
    =*  contract     contract.txn
    =*  from         address.caller.txn
    =/  =txn-location:ui  [town-id root txn-num]
    %=  $
        txn-num      +(txn-num)
        txs          t.txs
        parsed-txn
      ?:  %+  exists-in-index  town-id
          [txn-hash txn-location txn-index]
        parsed-txn
      [[txn-hash txn-location] parsed-txn]
    ::
        parsed-from
      ?:  %+  exists-in-index  town-id
          [from txn-hash from-index]
        parsed-from
      [[from txn-hash] parsed-from]
    ::
        parsed-to
      ?:  %+  exists-in-index  town-id
          [contract txn-hash to-index]
        parsed-to
      [[contract txn-hash] parsed-to]
    ==
  ::
  ++  exists-in-index
    |=  $:  town-id=@ux
            key=@ux
            val=location:ui
            index=location-index:ui
        ==
    ^-  ?
    ?~  town-index=(~(get by index) town-id)  %.n
    %.  val
    %~  has  in
    %-  %~  gas  in  *(set location:ui)
    (~(get ja u.town-index) key)
  --
--
