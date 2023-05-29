/-  spider,
    eng=zig-engine,
    pyro=zig-pyro,
    seq=zig-sequencer,
    ui=zig-indexer,
    zig=zig-ziggurat
/+  agentio,
    mip,
    strandio,
    dock=docket,
    engine=zig-sys-engine,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart,
    ui-lib=zig-indexer
|_  [=bowl:gall =settings:zig]
+*  this    .
    io      ~(. agentio bowl)
    strand  strand:spider
::
+$  card  card:agent:gall
::
::  utilities
::
++  make-canonical-distribution-ship
  ^-  @p
  ::  REPLACE THIS ON DEPLOYMENT
  ~zod
::
++  default-ships
  ^-  (list @p)
  ~[~nec ~wes ~bud]
::
++  default-ships-set
  ^-  (set @p)
  (~(gas in *(set @p)) default-ships)
::
++  default-snap-path
  ^-  path
  /testnet
::
++  get-ind-desk
  |=  [=project:zig desk-name=@tas]
  ^-  (unit (pair @ud desk:zig))
  =|  index=@ud
  |-
  ?~  desks.project  ~
  =*  name-desk  i.desks.project
  ?:  =(desk-name p.name-desk)  `[index q.name-desk]
  $(index +(index), desks.project t.desks.project)
::
++  get-desk
  |=  [=project:zig desk-name=@tas]
  ^-  (unit desk:zig)
  ?~  ind-desk=(get-ind-desk project desk-name)  ~
  `q.u.ind-desk
::
++  has-desk
  |=  [=project:zig desk-name=@tas]
  ^-  ?
  ?=(^ (get-ind-desk project desk-name))
::
++  got-ind-desk
  |=  [=project:zig desk-name=@tas]
  ^-  (pair @ud desk:zig)
  (need (get-ind-desk project desk-name))
::
++  got-desk
  |=  [=project:zig desk-name=@tas]
  ^-  desk:zig
  (need (get-desk project desk-name))
::
++  gut-desk
  |=  [=project:zig desk-name=@tas default=desk:zig]
  ^-  desk:zig
  ?^  desk=(get-desk project desk-name)  u.desk  default
::
++  tap-desk
  |=  =project:zig
  ^-  (list @tas)
  %+  turn  desks.project
  |=([p=@tas q=desk:zig] p)
::
++  val-desk
  |=  =project:zig
  ^-  (list desk:zig)
  %+  turn  desks.project
  |=([p=@tas q=desk:zig] q)
::
++  put-desk
  |=  [=project:zig desk-name=@tas =desk:zig]
  ^-  project:zig
  %=  project
      desks
    ?~  ind-desk=(get-ind-desk project desk-name)
      (snoc desks.project [desk-name desk])
    (snap desks.project p.u.ind-desk [desk-name desk])
  ==
::
++  del-desk
  |=  [=project:zig desk-name=@tas]
  ^-  project:zig
  ?~  ind-desk=(get-ind-desk project desk-name)  project
  project(desks (oust [p.u.ind-desk 1] desks.project))
::
++  diff-ship-lists
  |=  [running=(list @p) new=(list @p)]
  ^-  (list @p)
  =|  diff=(list @p)
  |-
  ?~  new  (flop diff)
  ?^  (find [i.new]~ running)  $(new t.new)
  $(new t.new, diff [i.new diff])
::
::  +make-new-desk based on https://github.com/urbit/urbit/blob/0b95645134f9b3902fa5ec8d2aad825f2e64ed8d/pkg/arvo/gen/hood/new-desk.hoon
::
++  make-new-desk
  |=  desk-name=@tas
  ^-  card
  %-  ~(arvo pass:io /make-new-desk/[desk-name])
  %^  new-desk:cloy  desk-name  ~
  %-  ~(gas by *(map path page:clay))
  %+  turn
    ^-  (list path)
    :~  /mar/noun/hoon
        /mar/hoon/hoon
        /mar/txt/hoon
        /mar/kelvin/hoon
        /sys/kelvin
    ==
  |=  p=path
  :-  p
  ^-  page:clay
  :-  (rear p)
  ~|  [%missing-source-file %base p]
  .^  *
      %cx
      %-  weld  :_  p
      /(scot %p our.bowl)/base/(scot %da now.bowl)
  ==
::
++  get-dev-desk
  |=  [who=@p desk-name=@tas]
  ^-  card
  %-  ~(arvo pass:io /get-dev-desk/[desk-name])
  [%c %merg desk-name who desk-name da+now.bowl %only-that]
::
++  suspend-desk
  |=  desk-name=@tas
  ^-  card
  %-  ~(arvo pass:io /suspend-desk/[desk-name])
  [%c %zest desk-name %dead]
::
++  uninstall-desk
  |=  desk-name=@tas
  ^-  card
  %+  ~(poke-our pass:io /uninstall-desk/[desk-name])  %hood
  [%kiln-uninstall !>(`@tas`desk-name)]
::
++  make-build-file
  |=  $:  =update-info:zig
          file-path=path
      ==
  ^-  card
  =*  project-name  project-name.update-info
  =*  desk-name     desk-name.update-info
  =*  request-id    request-id.update-info
  :: ?<  ?=(%con -.file-path)
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  desk-name  request-id
  [%build-file file-path]
::
++  make-read-repo
  |=  $:  project-name=@t
          desk-name=@tas
          request-id=(unit @t)
      ==
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  (make-read-repo-cage project-name desk-name request-id)
::
++  make-read-repo-cage
  |=  $:  project-name=@t
          desk-name=@tas
          request-id=(unit @t)
      ==
  ^-  cage
  :-  %ziggurat-action
  !>  ^-  action:zig
  [project-name desk-name request-id [%read-repo ~]]
::
++  make-run-queue
  |=  [project-name=@t desk-name=@tas request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  desk-name  request-id
  [%run-queue ~]
::
++  make-watch-for-file-changes
  |=  $:  project-name=@tas
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
      ==
  ^-  card
  %-  ~(poke-self pass:io /make-watch-for-file-changes)
  %-  make-watch-for-file-changes-cage
  [project-name repo-host repo-name branch-name]
::
++  make-watch-for-file-changes-cage
  |=  $:  project-name=@tas
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
      ==
  ^-  cage
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  %$  ~
  [%watch-for-file-changes repo-host repo-name branch-name]
::
++  make-cancel-watch-for-file-changes
  |=  $:  project-name=@tas
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
      ==
  ^-  card
  %-  ~(poke-self pass:io /make-cancel-watch-for-file-changes)
  %-  make-cancel-watch-for-file-changes-cage
  [project-name repo-host repo-name branch-name]
::
++  make-cancel-watch-for-file-changes-cage
  |=  $:  project-name=@tas
          repo-host=@p
          repo-name=@tas
          branch-name=@tas
      ==
  ^-  cage
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  %$  ~
  :-  %cancel-watch-for-file-changes
  [repo-host repo-name branch-name]
::
++  get-most-recent-commit
  |=  [repo-host=@p repo-name=@tas branch-name=@tas]
  ^-  (unit @ux)
  =*  scry-path
    :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
    /(scot %p repo-host)/[repo-name]/[branch-name]/noun
  =+  .^(log=(list [commit-hash=@ux @ @ @]) %gx scry-path)
  ?~  log  ~  `commit-hash.i.log
::
++  convert-contract-hoon-to-jam
  |=  contract-hoon-path=path
  ^-  (unit path)
  ?.  ?=([%con *] contract-hoon-path)  ~
  :-  ~
  %-  snoc
  :_  %jam
  %-  snip
  `path`(welp /con/compiled +.contract-hoon-path)
::
++  build-contract
  !.
  |=  [smart-lib=vase repo-path=path to-compile=path]
  ^-  build-result:zig
  ::
  ::  adapted from compile-contract:conq
  ::  this wacky design is to get a more helpful error print
  ::
  |^
  =/  first  (mule |.(parse-main))
  ?:  ?=(%| -.first)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.first 'error parsing main:')
    :: (snoc (scag 4 p.first) 'error parsing main:')
  ?:  ?=(%| -.p.first)  [%| p.p.first]
  =/  second  (mule |.((parse-imports raw.p.p.first)))
  ?:  ?=(%| -.second)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.second 'error parsing import:')
    :: (snoc (scag 3 p.second) 'error parsing import:')
  ?:  ?=(%| -.p.second)  [%| p.p.second]
  =/  third  (mule |.((build-imports p.p.second)))
  ?:  ?=(%| -.third)
    %|^(reformat-compiler-error (snoc p.third 'error building imports:'))
    :: %|^(reformat-compiler-error (snoc (scag 2 p.third) 'error building imports:'))
  =/  fourth  (mule |.((build-main vase.p.third contract-hoon.p.p.first)))
  ?:  ?=(%| -.fourth)
    :-  %|
    %-  reformat-compiler-error
    (snoc p.fourth 'error building main:')
    :: (snoc (scag 2 p.fourth) 'error building main:')
  %&^[bat=p.fourth pay=nok.p.third]
  ::
  ++  parse-main  ::  first
    ^-  (each [raw=(list [face=term =path]) contract-hoon=hoon] @t)
    =*  p=path
      ;:  welp
          /(scot %p our.bowl)/linedb/(scot %da now.bowl)
          repo-path
          to-compile
          /noun
      ==
    =+  .^(file-contents=(unit @t) %gx p)
    ?~  file-contents
      :-  %|
      %-  crip
      %+  weld  "did not find contract at"
      " {<`path`to-compile>} in repo {<`path`repo-path>}"
    [%& (parse-pile:conq p (trip u.file-contents))]
  ::
  ++  parse-imports  ::  second
    |=  raw=(list [face=term p=path])
    ^-  (each (list hoon) @t)
    =/  imports-or-error=(each (list [@tas path @t]) @t)
      =|  imports=(list [@tas path @t])
      |-
      ?~  raw  [%& (flop imports)]
      =*  face=term  face.i.raw
      =*  p=path     (snoc p.i.raw %hoon)
      =*  tp=path
        ;:  welp
           /(scot %p our.bowl)/linedb/(scot %da now.bowl)
           repo-path
           p
           /noun
        ==
      =+  .^(file-contents=(unit @t) %gx tp)
      ?~  file-contents
        :-  %|
        %-  crip
        "did not find imports for {<to-compile>} at {<p>}"
      %=  $
          raw      t.raw
          imports  [[face tp u.file-contents] imports]
      ==
    ?:  ?=(%| -.imports-or-error)  [%| p.imports-or-error]
    :-  %&
    %+  turn  p.imports-or-error
    |=  [face=@tas tp=path file-contents=@t]
    ^-  hoon
    [%ktts face +:(parse-pile:conq tp (trip file-contents))]
  ::
  ++  build-imports  ::  third
    |=  braw=(list hoon)
    ^-  [nok=* =vase]
    =/  libraries=hoon  [%clsg braw]
    :-  q:(~(mint ut p.smart-lib) %noun libraries)
    (slap smart-lib libraries)
  ::
  ++  build-main  ::  fourth
    |=  [payload=vase contract=hoon]
    ^-  *
    q:(~(mint ut p:(slop smart-lib payload)) %noun contract)
  --
::
++  reformat-compiler-error
  |=  e=(list tank)
  ^-  @t
  %-  crip
  %-  zing
  %+  turn  (flop e)
  |=  =tank
  =/  raw-wall=wall  (wash [0 80] tank)
  ?~  raw-wall  (of-wall:format raw-wall)
  ?+    `@tas`(crip i.raw-wall)  (of-wall:format raw-wall)
      %mint-nice
    "mint-nice error: cannot nest `have` type within `need` type\0a"
  ::
      %mint-vain
    "mint-vain error: hoon is never reached in execution\0a"
  ::
      %mint-lost
    "mint-lost error: ?- conditional missing possible branch\0a"
  ::
      %nest-fail
    "nest-fail error: cannot nest `have` type within `need` type\0a"
  ::
      %fish-loop
    %+  weld  "fish-loop error:"
    " cannot match noun to a recursively-defined type\0a"
  ::
      %fuse-loop
    "fuse-loop error: type definition produces infinite loop\0a"
  ::
      ?(%'- need' %'- have')
    ?:  (gte compiler-error-num-lines.settings (lent raw-wall))
      (of-wall:format raw-wall)
    (weld i.raw-wall "\0a<long type elided>\0a")
  ::
      %'-find.$'
    %+  weld  "-find.$ error: face is used like a gate but"
    " is not a gate (try `^face`?)\0a"
  ::
      %rest-loop
    %+  weld  "rest-loop error: cannot cast arm return"
    " value to that arm"
  ==
::
++  get-formatted-error
  |=  e=(list tank)
  ^-  @t
  %-  crip
  %-  zing
  %+  turn  (flop e)
  |=  =tank
  (of-wall:format (wash [0 80] tank))
::
++  show-state
  |=  state=vase
  ^-  @t
  =/  max-print-size=@ud
    ?:  =(*@ud state-num-characters.settings)  10.000
    state-num-characters.settings
  =/  noah-state=tape  (noah state)
  ?:  (lth max-print-size (lent noah-state))
    (crip noah-state)
  (get-formatted-error (sell state) ~)
::
++  mule-slam-transform
  |=  [transform=vase payload=vase]
  ^-  (each vase @t)
  !.
  =/  slam-result
    (mule |.((slam transform payload)))
  ?:  ?=(%& -.slam-result)  slam-result
  [%| (reformat-compiler-error p.slam-result)]
::
++  mule-slap-subject
  |=  [subject=vase payload=hoon]
  ^-  (each vase @t)
  !.
  =/  compilation-result
    (mule |.((slap subject payload)))
  ?:  ?=(%& -.compilation-result)  compilation-result
  [%| (reformat-compiler-error p.compilation-result)]
::
++  compile-and-call-arm
  |=  [arm=@tas subject=vase payload=hoon]
  ^-  (each vase @t)
  =/  hoon-compilation-result
    (mule-slap-subject subject payload)
  ?:  ?=(%| -.hoon-compilation-result)
    hoon-compilation-result
  (mule-slap-subject p.hoon-compilation-result (ream arm))
::
++  get-chain-state
  |=  [project-name=@t =configs:zig]
  ^-  (each (map @ux batch:ui) @t)
  =/  now=@ta   (scot %da now.bowl)
  =/  sequencers=(list [town-id=@ux who=@p])
    %~  tap  by
    (get-town-id-to-sequencer-map project-name configs)
  =|  town-states=(list [@ux batch:ui])
  |-
  ?~  sequencers
    [%& (~(gas by *(map @ux batch:ui)) town-states)]
  =*  town-id  town-id.i.sequencers
  =/  who=@ta   (scot %p who.i.sequencers)
  =/  town-ta=@ta  (scot %ux town-id)
  ?.  .^  ?
          %gx
          :+  (scot %p our.bowl)  %pyro
          /[now]/i/[who]/gu/[who]/indexer/[now]/$/noun
      ==
    :-  %|
    %-  crip
    "%pyro ship {<who.i.sequencers>} not running %indexer"
  =/  batch-order=update:ui
    .^  update:ui
        %gx
        %+  weld
          /(scot %p our.bowl)/pyro/[now]/[who]/indexer
        /batch-order/[town-ta]/noun/noun
    ==
  ?~  batch-order              $(sequencers t.sequencers)
  ?.  ?=(%batch-order -.batch-order)
    $(sequencers t.sequencers)
  ?~  batch-order.batch-order  $(sequencers t.sequencers)
  =*  newest-batch  i.batch-order.batch-order
  =/  batch-update=update:ui
    .^  update:ui
        %gx
        ;:  weld
            /(scot %p our.bowl)/pyro/[now]/[who]
            /indexer/newest/batch/[town-ta]
            /(scot %ux newest-batch)/noun/noun
    ==  ==
  ?~  batch-update               $(sequencers t.sequencers)
  ?.  ?=(%batch -.batch-update)  $(sequencers t.sequencers)
  ?~  batch=(~(get by batches.batch-update) newest-batch)
    $(sequencers t.sequencers)
  %=  $
      sequencers  t.sequencers
      town-states
    :_  town-states
    [town-id (snip-batch-code batch.u.batch)]
  ==
::
++  snip-batch-code
  |=  =batch:ui
  |^  ^-  batch:ui
  :+  transactions.batch
    snip-chain-code
  hall.batch
  ::
  ++  snip-chain-code
    ^-  chain:eng
    =*  chain  chain.batch
    :_  q.chain
    %+  gas:big:seq  *_p.chain
    %+  turn  ~(tap by p.chain)
    |=  [id=@ux @ =item:smart]
    ?:  ?=(%& -.item)  [id item]
    =/  max-print-size=@ud
      ?:  =(*@ud code-max-characters.settings)  200
      code-max-characters.settings
    =/  noah-code-size=@ud  (lent (noah !>(code.p.item)))
    ?:  (gth max-print-size noah-code-size)  [id item]
    [id item(code.p [0 0])]
  --
::
++  town-id-to-sequencer-host
  |=  [project-name=@t town-id=@ux =configs:zig]
  ^-  (unit @p)
  %.  town-id
  %~  get  by
  (get-town-id-to-sequencer-map project-name configs)
::
++  get-town-id-to-sequencer-map
  |=  [project-name=@t =configs:zig]
  ^-  (map @ux @p)
  =/  town-id-to-sequencer=(map @ux @p)
    %-  ~(gas by *(map @ux @p))
    %+  murn  ~(tap bi:mip configs)
    |=  [pn=@t [who=@p what=@tas] item=@]
    ?.  =(project-name pn)   ~
    ?.  ?=(%sequencer what)  ~
    `[`@ux`item who]
  ?.  &(?=(~ town-id-to-sequencer) !=('global' project-name))
    town-id-to-sequencer
  (get-town-id-to-sequencer-map 'global' configs)
::
++  get-ship-to-address-map
  |=  [project-name=@t =configs:zig]
  ^-  (map @p @ux)
  =/  ship-to-address=(map @p @ux)
    %-  ~(gas by *(map @p @ux))
    %+  murn  ~(tap bi:mip configs)
    |=  [pn=@t [who=@p what=@tas] item=@]
    ?.  =(project-name pn)   ~
    ?.  ?=(%address what)  ~
    `[who `@ux`item]
  ?.  &(?=(~ ship-to-address) !=('global' project-name))
    ship-to-address
  (get-ship-to-address-map 'global' configs)
::
++  make-cis-running
  |=  [ships=(list @p) desk-name=@tas]
  ^-  (map @p [@t ?])
  %-  ~(gas by *(map @p [@t ?]))
  %+  turn  ships
  |=  who=@p
  :-  who
  :_  %.n
  (rap 3 'setup-' desk-name '-' (scot %p who) ~)
::
++  make-status-card
  |=  [=status:zig project-name=@t desk-name=@tas]
  ^-  card
  %-  update-vase-to-card
  %.  status
  %~  status  make-update-vase
  [project-name desk-name %cis ~]
::
++  make-done-cards
  |=  [=status:zig project-name=@t desk-name=@tas]
  |^  ^-  (list card)
  :^    (make-status-card status project-name desk-name)
      make-watch-cis-setup-done-card
    (make-run-queue '' desk-name ~)
  ~
  ::
  ++  make-watch-cis-setup-done-card
    ^-  card
    %.  [%ziggurat /project]
    %~  watch-our  pass:io
    /cis-setup-done/[project-name]/[desk-name]
  --
::
++  loud-ream
  |=  [txt=@ error-path=path]
  |^  ^-  hoon
  (rash txt loud-vest)
  ::
  ++  loud-vest
    |=  tub=nail
    ^-  (like hoon)
    %.  tub
    %-  full
    (ifix [gay gay] tall:(vang %.y error-path))
  --
::
++  uni-configs
  |=  [olds=configs:zig news=configs:zig]
  ^-  configs:zig
  %-  ~(gas by *configs:zig)
  %+  turn  ~(tap by olds)
  |=  [project-name=@t old=config:zig]
  :-  project-name
  ?~  new=(~(get by news) project-name)  old
  (~(uni by old) u.new)
::
++  thread-name-to-path
  |=  thread-name=@tas
  ^-  path
  /ted/ziggurat/[thread-name]/hoon
::
++  get-fit
  |=  [repo-path=path file-path-prefix=@tas file-path=@tas]
  ^-  (unit path)
  =/  scry-prefix=path
    :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
    repo-path
  =/  scry-suffix=path  /hoon/noun
  =/  possible-paths=(list path)  (segments:clay file-path)
  ~&  `(list path)`possible-paths
  |-
  ?~  possible-paths  ~
  =*  p  i.possible-paths
  ~&  ;:  weld
          scry-prefix
          [file-path-prefix p]
          scry-suffix
      ==
  =+  .^  f=(unit @t)
          %gx
          ;:  weld
              scry-prefix
              [file-path-prefix p]
              scry-suffix
      ==  ==
  ?^  f  `[file-path-prefix p]
  $(possible-paths t.possible-paths)
::
++  add-to-queue
  |=  $:  =thread-queue:zig
          thread-name=@tas
          payload=thread-queue-payload:zig
          =update-info:zig
      ==
  ^-  [vase thread-queue:zig]
  =*  project-name  project-name.update-info
  =*  desk-name     desk-name.update-info
  =.  thread-queue
    %-  ~(put to thread-queue)
    [project-name desk-name thread-name payload]
  :_  thread-queue
  %.  thread-queue
  ~(thread-queue make-update-vase update-info)
::
++  does-linedb-have-file
  |=  [repo-path=path file-path=path]
  ^-  ?
  ::  host, repo, branch, commit
  ?>  ?=([@ @ @ @ ~] repo-path)
  (is-linedb-path-populated (welp repo-path file-path))
::
++  is-linedb-path-populated
  |=  query-path=path
  ^-  ?
  ::  NOTE: `query-path` should NOT have the scry /noun.
  =*  query-result
    .^  *
        %gx
        %-  weld  :_  (snoc query-path %noun)
        /(scot %p our.bowl)/linedb/(scot %da now.bowl)
    ==
  ?=(^ query-result)
::
++  make-state-views
  |=  $:  who=@p
          project-repo-name=@tas
          branch-name=@tas
          commit-hash=(unit @ux)
      ==
  ^-  (unit state-views:zig)
  =*  p=path
    :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
    :^  (scot %p who)  project-repo-name  branch-name
    :-  ?~  commit-hash  %head  (scot %ux u.commit-hash)
    /zig/state-views/[project-repo-name]/hoon/noun
  =+  .^(state-views-text=(unit @t) %gx p)
  ?~  state-views-text  ~
  =/  build-result
    %-  mule
    |.
    (slap !>(..zuse) (ream u.state-views-text))
  ?:  ?=(%| -.build-result)  ~
  `!<(state-views:zig p.build-result)
::
++  convert-test-steps-to-thread
  |=  $:  project-name=@t
          desk-name=@tas
          =imports:zig
          =test-steps:zig
      ==
  ^-  @t
  =.  imports
    %-  ~(gas by imports)
    :-  [%spider /sur/spider]
    :^  [%strandio /lib/strandio]  [%zig /sur/zig/ziggurat]
      [%ziggurat-threads /lib/zig/ziggurat/threads]
    ~
  |^
  :: =/  sorted-imports=(map @tas imports:zig)  sort-imports
  %+  rap  3
  %-  zing
  :~  make-import-lines
      :: %-  to-wain:format
  ::
      :_  ~
      '''
      ::
      =*  strand  strand:spider
      ::
      =/  m  (strand ,vase)
      =|  project-name=@t
      =|  desk-name=@tas
      =|  ship-to-address=(map @p @ux)
      =*  zig-threads
        ~(. ziggurat-threads project-name desk-name ship-to-address)
      |^  ted
      ::
      +$  arg-mold
        $:  project-name=@t
            desk-name=@tas
            request-id=(unit @t)
        ==
      ::
      ++  town-id
        ^-  @ux
        0x0
      ::
      ++  sequencer-host
        ^-  @p
        ~nec
      ::
      ++  get-ship-to-address
        =/  m  (strand ,(map @p @ux))
        ^-  form:m
        ;<  =update:zig  bind:m
          %+  scry:strandio  update:zig
          /gx/ziggurat/get-ship-to-address-map/[project-name]/noun
        ?>  ?=(^ update)
        ?>  ?=(%ship-to-address-map -.update)
        ?>  ?=(%& -.payload.update)
        (pure:m p.payload.update)
      ::
      ++  ted
        ^-  thread:spider
        |=  args-vase=vase
        ^-  form:m
        =/  args  !<((unit arg-mold) args-vase)
        ?~  args
          ~&  >>>  "Usage:"
          ~&  >>>  "-<desk-name>!<thread-name> project-name=@t desk-name=@tas request-id=(unit @t)"
          (pure:m !>(~))
        =.  project-name  project-name.u.args
        =.  desk-name     desk-name.u.args
        =*  request-id    request-id.u.args
        ;<  new-ship-to-address=(map @p @ux)  bind:m
          get-ship-to-address
        =.  ship-to-address  new-ship-to-address

      '''
  ::
      make-test-steps-lines
      ~['  (pure:m !>(`(each ~ @t)`[%.y ~]))\0a--\0a']
  ==
  ::
  ++  make-import-lines
    |^  ^-  (list @t)
    =/  prefix=@t  '/=  '
    %+  turn
      (sort ~(tap by imports) alphabetize-face-comparator)
    |=  [face=@tas p=path]
    ?:  ?=(%$ face)  (rap 3 prefix (spat p) '\0a' ~)
    (rap 3 prefix face '  ' (spat p) '\0a' ~)
    ::
    ++  alphabetize-face-comparator
      |=  [a=(pair @tas *) b=(pair @tas *)]
      ^-  ?
      (aor p.a p.b)
    --
  ::
  ++  make-test-steps-lines
    ^-  (list @t)
    =|  lines=(list @t)
    =|  index=@ud
    |-
    ?~  test-steps  (flop lines)
    =*  test-step  i.test-steps
    %=  $
        index       +(index)
        test-steps  t.test-steps
        lines
      :_  lines
      %^  cat  3
        %-  crip
        """
          ::
          ::  step {<index>}
          ::

        """
      ?-    -.test-step
          %wait
        %-  crip
        "  ;<  ~  bind:m  (sleep:strandio {<until.test-step>})\0a"
      ::
          %dojo
        =*  p  payload.test-step
        %-  crip
        """
          ;<  empty-vase=vase  bind:m
            %+  send-discrete-pyro-dojo:zig-threads
            {<who.p>}  {<payload.p>}

        """
      ::
          %scry
        =*  p  payload.test-step
        %+  rap  3
        :~
            :: '  ;<  result=['
            '  ;<  result='
            mold-name.p
            :: ' ?]  bind:m\0a'
            '  bind:m\0a'
        ::
            %-  crip
                :: %^  send-pyro-scry-with-expectation:zig-threads
            """
                %^  send-pyro-scry:zig-threads
                  {<who.p>}
            """
        ::
            '  '
            mold-name.p
        ::
            %-  crip
            """

                :+  {<care.p>}  {<app.p>}  {<path.p>}

            """
        ::
            :: '    '
            :: ?~  expected.test-step  '0'  expected.test-step
            :: '\0a'
        ==
      ::
          %poke
        =*  p  payload.test-step
        %+  rap  3
        :~  %-  crip
            """
              ;<  empty-vase=vase  bind:m
                %-  send-discrete-pyro-poke:zig-threads
                :^  {<who.p>}  {<to.p>}  {<app.p>}
                :-  {<mark.p>}

            """
            '    !>('
            (crip (noah payload.p))
            ')\0a'
        ==
      ==
    ==
  --
::
++  get-pyro-ships-app-states
  |=  whos=(list @p)
  ^-  (map @p (map @tas (set [@tas ?])))
  %-  ~(gas by *(map @p (map @tas (set [@tas ?]))))
  %+  turn  whos
  |=  who=@p
  [who (get-pyro-ship-app-states who)]
::
++  get-pyro-ship-app-states
  |=  who=@p
  ^-  (map @tas (set [@tas ?]))
  =*  our  (scot %p our.bowl)
  =*  now  (scot %da now.bowl)
  =*  w    (scot %p who)
  |^
  %-  ~(gas by *(map @tas (set [@tas ?])))
  %+  turn  ~(tap in get-desk-names)
  |=  desk-name=@tas
  [desk-name (get-app-states desk-name)]
  ::
  ++  get-desk-names
    ^-  (set @tas)
    .^  (set @tas)
        %gx
        /[our]/pyro/[now]/i/[w]/cd/[w]//0/noun
    ==
  ::
  ++  get-app-states
    |=  desk-name=@tas
    ^-  (set [@tas ?])
    .^  (set [@tas ?])
        %gx
        /[our]/pyro/[now]/i/[w]/ge/[w]/[desk-name]/0/$/apps
    ==
  --
::
::  files we delete from zig desk to make new gall desk
::
++  clean-desk
  |=  name=@tas
  :~  [/app/indexer/hoon %del ~]
      [/app/rollup/hoon %del ~]
      [/app/sequencer/hoon %del ~]
      [/app/uqbar/hoon %del ~]
      [/app/wallet/hoon %del ~]
      [/app/ziggurat/hoon %del ~]
      [/gen/rollup/activate/hoon %del ~]
      [/gen/sequencer/batch/hoon %del ~]
      [/gen/sequencer/init/hoon %del ~]
      [/gen/uqbar/set-sources/hoon %del ~]
      [/gen/wallet/basic-tx/hoon %del ~]
      [/gen/build-hash-cache/hoon %del ~]
      [/gen/compile/hoon %del ~]
      [/gen/compose/hoon %del ~]
      [/gen/merk-profiling/hoon %del ~]
      [/gen/mk-smart/hoon %del ~]
      [/tests/contracts/fungible/hoon %del ~]
      [/tests/contracts/nft/hoon %del ~]
      [/tests/contracts/publish/hoon %del ~]
      [/tests/lib/merk/hoon %del ~]
      [/tests/lib/mill-2/hoon %del ~]
      [/tests/lib/mill/hoon %del ~]
      [/roadmap/md %del ~]
      [/readme/md %del ~]
      [/app/[name]/hoon %ins hoon+!>((make-template /app/[name]/hoon))]
  ==
::
++  make-operation-steps
  |%
  ++  setup-project
    ^-  (list @tas)
    :^  %build-configuration-thread  %get-dependency-repos
    %start-new-ships  ~
  ::
  ++  commit-install-start
    ^-  (list @tas)
    ~[%commit-files-to-pyro-ships %install-and-start-apps-on-pyro-ships]
  ::
  ++  fetch-repo
    ^-  (list @tas)
    ~[%fetch-repo]
  --
::
::  uqbar-core:lib/zink/conq/hoon duplicated here in part
::   with changes that allow for more verbose compilation
::   error output
::
++  conq
  |%
  ::
  ::  parser helpers
  ::
  +$  small-pile
      $:  raw=(list [face=term =path])
          =hoon
      ==
  +$  taut  [face=(unit term) pax=term]
  ++  parse-pile
    !.
    |=  [pax=path tex=tape]
    ^-  small-pile
    =/  [=hair res=(unit [=small-pile =nail])]  ((pile-rule pax) [1 1] tex)
    ?^  res  small-pile.u.res
    %-  mean  %-  flop
    =/  lyn  p.hair
    =/  col  q.hair
    =/  lyns=wain  (to-wain:format (crip tex))
    =/  prev-lyn=@ud  (dec lyn)
    ?:  (gth (lent lyns) prev-lyn)
      :~  leaf+"syntax error at [{<lyn>} {<col>}] in {<`path`(slag 3 pax)>}"
          leaf+(runt [(dec col) '-'] "^")
          leaf+(trip (snag prev-lyn lyns))
      ==
    :~  leaf+"syntax error at [{<lyn>} {<col>}] in {<`path`(slag 3 pax)>}"
        leaf+"file missing a terminator"
    ==
  ++  pile-rule
    |=  pax=path
    %-  full
    %+  ifix
      :_  gay
      ::  parse optional smart library import and ignore
      ;~(plug gay (punt ;~(plug fas lus gap taut-rule gap)))
    ;~  plug
    ::  only accept /= imports for contract libraries
      %+  rune  tis
      ;~(plug sym ;~(pfix gap stap))
    ::
      %+  stag  %tssg
      (most gap tall:(vang & (slag 3 pax)))
    ==
  ++  rune
    |*  [bus=rule fel=rule]
    %-  pant
    %+  mast  gap
    ;~(pfix fas bus gap fel)
  ++  pant
    |*  fel=rule
    ;~(pose fel (easy ~))
  ++  mast
    |*  [bus=rule fel=rule]
    ;~(sfix (more bus fel) bus)
  ++  taut-rule
    %+  cook  |=(taut +<)
    ;~  pose
      (stag ~ ;~(pfix tar sym))
      ;~(plug (stag ~ sym) ;~(pfix tis sym))
      (cook |=(a=term [`a a]) sym)
    ==
  ::
  ::  abbreviated parser from lib/zink/conq.hoon:
  ::   parse to end of imports, start of hoon.
  ::   used to find start of hoon for compilation and to find
  ::   proper line error number in case of error
  ::   (see +mule-slap-subject)
  ::
  +$  small-start-of-pile  (list [face=term =path])
  ::
  ++  parse-start-of-pile
    |=  tex=tape
    ^-  [small-start-of-pile hair]
    =/  [=hair res=(unit [=small-start-of-pile =nail])]
      (start-of-pile-rule [1 1] tex)
    ?^  res  [small-start-of-pile.u.res hair]
    %-  mean  %-  flop
    =/  lyn  p.hair
    =/  col  q.hair
    :~  leaf+"syntax error"
        leaf+"\{{<lyn>} {<col>}}"
        leaf+(runt [(dec col) '-'] "^")
        leaf+(trip (snag (dec lyn) (to-wain:format (crip tex))))
    ==
  ::
  ++  start-of-pile-rule
    %+  ifix
      :_  gay
      ::  parse optional smart library import and ignore
      ;~(plug gay (punt ;~(plug fas lus gap taut-rule:conq gap)))
    ;~  plug
    ::  only accept /= imports for contract libraries
      %+  rune:conq  tis
      ;~(plug sym ;~(pfix gap stap))
    ==
  --
::
++  make-configuration-template
  |=  [repo-dependencies=(list @t) pyro-ships=(list @p)]
  ^-  @t
  %+  rap  3
  %-  zing
  :~
    :_  ~
    '''
    /-  spider,
        zig=zig-ziggurat
    /+  ziggurat-threads=zig-ziggurat-threads
    ::
    =*  strand  strand:spider
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
    ++  make-repo-dependencies
      |=  =bowl:strand
      ^-  repo-dependencies:zig

    '''
  ::
    ?~  repo-dependencies
      ~['  ~\0a']
    %-  snoc  :_  '\0a  ==\0a'
    :-  '  :~\0a    '
    (join '\0a    ' repo-dependencies)
  ::
    :_  ~
    '''
    ::
    ++  make-config
      ^-  config:zig
      ~
    ::
    ++  make-virtualships-to-sync
      ^-  (list @p)

    '''
  ::
    :_  ~
    %-  crip
    """
      {<pyro-ships>}

    """
  ::
    :_  ~
    '''
    ::
    ++  make-install
      ^-  (map desk-name=@tas whos=(list @p))
      ~
    ::
    ++  make-start-apps
      ^-  (map desk-name=@tas (list @tas))
      ~
    ::
    ++  run-setup-desk
      |=  request-id=(unit @t)
      =/  m  (strand ,vase)
      ^-  form:m
      ;<  =bowl:strand  bind:m  get-bowl
      %:  setup-project:zig-threads
          request-id
          (make-repo-dependencies bowl)
          make-config
          make-virtualships-to-sync
          make-install
          make-start-apps
      ==
    ::
    ++  setup-virtualship-state
      =/  m  (strand ,vase)
      ^-  form:m
      ::  for examples, see
      ::   https://github.com/uqbar-dao/zig-dev/blob/master/zig/configuration/zig-dev.hoon#L69-L180
      ::   https://github.com/uqbar-dao/pokur-dev/blob/master/zig/configuration/pokur-dev.hoon#L75-L192
      (pure:m !>(~))
    ::
    ++  $
      ^-  thread:spider
      |=  args-vase=vase
      ^-  form:m
      =/  args  !<((unit arg-mold) args-vase)
      ?~  args
        ~&  >>>  "Usage:"
        ~&  >>>  "-!ziggurat-configuration- project-name=@t desk-name=@tas request-id=(unit @t)"
        (pure:m !>(~))
      =.  project-name  project-name.u.args
      =.  desk-name     desk-name.u.args
      =*  request-id    request-id.u.args
      ::
      ;<  setup-desk-result=vase  bind:m
        (run-setup-desk request-id)
      ;<  setup-ships-result=vase  bind:m  setup-virtualship-state
      (pure:m !>(`(each ~ @t)`[%.y ~]))
    --
    '''
  ==
::
++  make-template
  |=  file-path=path
  |^  ^-  @t
  ?~  file-path          ''
  ?+  `@tas`i.file-path  ''
    %app    app
    %con    con
    %gen    gen
    %lib    lib
    %mar    mar
    %sur    sur
    %ted    ted
    %tests  tests
    %zig    zig
  ==
  ::
  ++  app
    ^-  @t
    '''
    /+  default-agent, dbug
    |%
    +$  versioned-state
        $%  state-0
        ==
    +$  state-0  [%0 ~]
    --
    %-  agent:dbug
    =|  state-0
    =*  state  -
    ^-  agent:gall
    |_  =bowl:gall
    +*  this     .
        default   ~(. (default-agent this %|) bowl)
    ::
    ++  on-init                     :: [(list card) this]
      `this(state [%0 ~])
    ++  on-save
      ^-  vase
      !>(state)
    ++  on-load                     :: |=(old-state=vase [(list card) this])
      on-load:default
    ++  on-poke   on-poke:default   :: |=(=cage [(list card) this])
    ++  on-watch  on-watch:default  :: |=(=path [(list card) this])
    ++  on-leave  on-leave:default  :: |=(=path [(list card) this])
    ++  on-peek   on-peek:default   :: |=(=path [(list card) this])
    ++  on-agent  on-agent:default  :: |=  [=wire =sign:agent:gall]
                                    :: [(list card) this]
    ++  on-arvo   on-arvo:default   :: |=([=wire =sign-arvo] [(list card) this])
    ++  on-fail   on-fail:default   :: |=  [=term =tang]
                                    :: %-  (slog leaf+"{<dap.bowl>}" >term< tang)
                                    :: [(list card) this]
    --
    '''
  ::
  ++  con
    |^  ^-  @t
    ?~  file-path      ''
    ?~  t.file-path    ''
    ?.(?=(%lib `@tas`i.t.file-path) con con-lib)
    ::
    ++  con
      ^-  @t
      '''
      /+  *zig-sys-smart
      /=  my-con-lib  /con/lib/my-lib  ::  your lib here
      |_  =context
      ++  write
        |=  act=action:sur
        ^-  ((list call) diff)
        ?-    -.act
            %action-0  ::  your action tags here
            ::  ...
        ==
      ::
      ++  read
        |_  =pith
        ++  json
          ~
        ++  noun
          ~
        --
      --
      '''
    ::
    ++  con-lib
      ^-  @t
      '''
      /+  *zig-sys-smart
      |%
      ++  sur
        |%
        +$  action
          %$  [%action-0 my-arg-0=@ud]  ::  your actions here
              ::  ...
          --
        ::
        +$  my-type-0  ::  your types here
          ~
        --
      ++  lib
        |%
        ++  my-helper-0
          ~  ::  do stuff
        --
      --
      '''
    --
  ::
  ++  gen
    ^-  @t
    '''
    :-  %say
    |=  [[now=@da eny=@uvJ bec=beak] ~[addend=@ud] ~[base=(unit @ud)]]
    ?~  base  (add 2 addend)
    (add u.base addend)
    '''
  ::
  ++  lib
    ^-  @t
    '''
    |%
    ++  my-arm
      ~  ::  do stuff
    --
    '''
  ::
  ++  mar
    ^-  @t
    '''
    ::  template based on dev-suite/mar/zig/ziggurat.hoon
    /-  zig=zig-ziggurat
    /+  zig-lib=zig-ziggurat
    |_  =action:zig
    ++  grab
      |%
      ++  noun  action:zig
      ++  json  uber-action:dejs:zig-lib
      --
    ::
    ++  grow
      |%
      ++  noun  action
      --
    ++  grad  %noun
    '''
  ::
  ++  sur
    ^-  @t
    '''
    |%
    +$  my-type
      ~  ::  define type
    --
    '''
  ::
  ++  ted
    ^-  @t
    '''
    /-  spider
    /+  strandio
    ::
    =*  strand  strand:spider
    ::
    =/  m  (strand ,vase)
    |^  ted
    ::
    +$  arg-mold
      $:  thread-arg-0=@ud  ::  your args here
          :: thread-arg-1=@ux
      ==
    ::
    ++  helper-core  ::  your helper cores here
      ~  ::  do stuff
    ::
    ::  main
    ::
    ++  ted
      ^-  thread:spider
      |=  args-vase=vase
      ^-  form:m
      =/  args  !<((unit arg-mold) args-vase)
      ?~  args
        ~&  >>>  "Usage:"
        ~&  >>>  "-<thread-name> <thread-arg-0> <thread-arg-1> ..."
        (pure:m !>(~))
      ::  do stuff
      (pure:m !>(~))
    --
    '''
  ::
  ++  tests
    ^-  @t
    '''
    ::  see https://medium.com/dcspark/writing-robust-hoon-a-guide-to-urbit-unit-testing-82b2631fe20a
    |%
    ++  my-test
      ~  ::  do test
    --
    '''
  ::
  ++  zig
    ^-  @t
    ''
  --
::
++  project-to-repo-infos
  |=  =project:zig
  ^-  (list repo-info:zig)
  %+  turn  (val-desk project)
  |=(=desk:zig repo-info.desk)
::
++  find-file-in-repos
  |=  [file-path=path repo-infos=(list repo-info:zig)]
  ^-  (unit repo-info:zig)
  ?~  repo-infos  ~
  =*  repo-info  i.repo-infos
  =*  repo-host  (scot %p repo-host.repo-info)
  =*  repo-name  repo-name.repo-info
  =*  branch-name  branch-name.repo-info
  =*  commit-hash  commit-hash.repo-info
  =*  commit=@ta
    ?~  commit-hash  %head  (scot %ux u.commit-hash)
  =*  file-scry-path=path
    %-  weld  :_  (snoc file-path %noun)
    :^  (scot %p our.bowl)  %linedb  (scot %da now.bowl)
    /[repo-host]/[repo-name]/[branch-name]/[commit]
  =*  file-contents  .^((unit @t) %gx file-scry-path)
  ?^  file-contents  `repo-info
  $(repo-infos t.repo-infos)
::
++  find-file-in-desks
  |=  [file-path=path desk-names=(list @tas)]
  ^-  (unit @tas)
  ?~  desk-names  ~
  =*  desk-name  i.desk-names
  =*  file-scry-path=path
    %-  weld  :_  file-path
    /(scot %p our.bowl)/[desk-name]/(scot %da now.bowl)
  ?:  .^(? %cu file-scry-path)
    `desk-name
  $(desk-names t.desk-names)
::
++  update-linedb-watches
  |=  $:  old=(pair @tas (list repo-info:zig))
          new=(pair @tas (list repo-info:zig))
      ==
  ^-  (list card)
  %+  weld
    %+  turn  q.old
    |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
    %-  make-cancel-watch-for-file-changes
    [p.old repo-host repo-name branch-name]
  %+  turn  q.new
  |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
  %-  make-watch-for-file-changes
  [p.new repo-host repo-name branch-name]
::
++  update-linedb-watches-cages
  |=  $:  old=(pair @tas (list repo-info:zig))
          new=(pair @tas (list repo-info:zig))
      ==
  ^-  (list cage)
  %+  weld
    %+  turn  q.old
    |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
    %-  make-cancel-watch-for-file-changes-cage
    [p.old repo-host repo-name branch-name]
  %+  turn  q.new
  |=  [repo-host=@p repo-name=@tas branch-name=@tas *]
  %-  make-watch-for-file-changes-cage
  [p.new repo-host repo-name branch-name]
::
++  update-vase-to-card
  |=  v=vase
  ^-  card
  (fact:io [%ziggurat-update v] ~[/project])
::
++  make-update-vase
  |_  =update-info:zig
  ++  focused-project
    |=  focused-project=@t
    ^-  vase
    !>  ^-  update:zig
    [%focused-project update-info [%& focused-project] ~]
  ::
  ++  project-names
    |=  project-names=(set @t)
    ^-  vase
    !>  ^-  update:zig
    [%project-names update-info [%& ~] project-names]
  ::
  ++  projects
    |=  =projects:zig
    ^-  vase
    !>  ^-  update:zig
    [%projects update-info [%& ~] projects]
  ::
  ++  project
    |=  =project:zig
    ^-  vase
    !>  ^-  update:zig
    [%project update-info [%& ~] project]
  ::
  ++  new-project
    |=  =sync-desk-to-vship:zig
    ^-  vase
    !>  ^-  update:zig
    [%new-project update-info [%& sync-desk-to-vship] ~]
  ::
  ++  add-config
    |=  [who=@p what=@tas item=@]
    ^-  vase
    !>  ^-  update:zig
    [%add-config update-info [%& who what item] ~]
  ::
  ++  delete-config
    |=  [who=@p what=@tas]
    ^-  vase
    !>  ^-  update:zig
    [%delete-config update-info [%& who what] ~]
  ::
  ++  run-queue
    ^-  vase
    !>  ^-  update:zig
    [%run-queue update-info [%& ~] ~]
  ::
  ++  add-user-file
    |=  file=path
    ^-  vase
    !>  ^-  update:zig
    [%add-user-file update-info [%& ~] file]
  ::
  ++  delete-user-file
    |=  file=path
    ^-  vase
    !>  ^-  update:zig
    [%delete-user-file update-info [%& ~] file]
  ::
  ++  dir
    |=  dir=(list path)
    ^-  vase
    !>  ^-  update:zig
    [%dir update-info [%& dir] ~]
  ::
  ++  poke
    ^-  vase
    !>  ^-  update:zig
    [%poke update-info [%& ~] ~]
  ::
  ++  thread-queue
    |=  =thread-queue:zig
    ^-  vase
    !>  ^-  update:zig
    :^  %thread-queue  update-info
    [%& (show-thread-queue thread-queue)]  ~
  ::
  ++  pyro-agent-state
    |=  [agent-state=vase wex=boat:gall sup=bitt:gall]
    ^-  vase
    !>  ^-  update:zig
    :^  %pyro-agent-state  update-info
    [%& agent-state wex sup]  ~
  ::
  ++  shown-pyro-agent-state
    |=  [agent-state=@t wex=boat:gall sup=bitt:gall]
    ^-  vase
    !>  ^-  update:zig
    :^  %shown-pyro-agent-state  update-info
    [%& agent-state wex sup]  ~
  ::
  ++  pyro-chain-state
    |=  state=(map @ux batch:ui)
    ^-  vase
    !>  ^-  update:zig
    [%pyro-chain-state update-info [%& state] ~]
  ::
  ++  shown-pyro-chain-state
    |=  chain-state=@t
    ^-  vase
    !>  ^-  update:zig
    :^  %shown-pyro-chain-state  update-info
    [%& chain-state]  ~
  ::
  ++  save-file
    |=  p=path
    ^-  vase
    !>(`update:zig`[%save-file update-info [%& p] ~])
  ::
  ++  sync-desk-to-vship
    |=  $:  =sync-desk-to-vship:zig
            pyro-ships-app-states=(map @p (map @tas (set [@tas ?])))
        ==
    ^-  vase
    !>  ^-  update:zig
    :^  %sync-desk-to-vship  update-info
    [%& [sync-desk-to-vship pyro-ships-app-states]]  ~
  ::
  ++  cis-setup-done
    ^-  vase
    !>  ^-  update:zig
    [%cis-setup-done update-info [%& ~] ~]
  ::
  ++  status
    |=  =status:zig
    ^-  vase
    !>  ^-  update:zig
    [%status update-info [%& status] ~]
  ::
  ++  settings
    |=  =settings:zig
    ^-  vase
    !>  ^-  update:zig
    [%settings update-info [%& settings] ~]
  ::
  ++  state-views
    |=  state-views=(list [@p (unit @tas) path])
    ^-  vase
    !>  ^-  update:zig
    [%state-views update-info [%& state-views] ~]
  ::
  ++  ziggurat-state
    |=  state=state-0:zig
    ^-  vase
    !>  ^-  update:zig
    [%ziggurat-state update-info [%& state] ~]
  ::
  ++  configs
    |=  =configs:zig
    ^-  vase
    !>  ^-  update:zig
    [%configs update-info [%& configs] ~]
  ::
  ++  ship-to-address-map
    |=  ship-to-address-map=(map @p @ux)
    ^-  vase
    !>  ^-  update:zig
    [%ship-to-address-map update-info [%& ship-to-address-map] ~]
  ::
  ++  build-result
    |=  p=path
    ^-  vase
    !>  ^-  update:zig
    [%build-result update-info [%& ~] p]
  ::
  ++  deploy-contract
    |=  [contract-id=@ux p=path]
    ^-  vase
    !>  ^-  update:zig
    [%deploy-contract update-info [%& contract-id] p]
  ::
  ++  suite-update-available
    ^-  vase
    !>  ^-  update:zig
    [%suite-update-available update-info [%& ~] ~]
  ::
  ++  repo-info
    |=  =repo-info:zig
    ^-  vase
    !>  ^-  update:zig
    [%repo-info update-info [%& repo-info] ~]
  --
::
++  make-error-vase
  |_  [=update-info:zig level=error-level:zig]
  ::
  ::  more arms at
  ::   https://github.com/uqbar-dao/dev-suite/blob/313baeb2532fecb35502239aa2bcea3255bd7232/lib/zig/ziggurat.hoon#L1397-L1555
  ::
  ++  new-project
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%new-project update-info [%| level message] ~]
  ::
  ++  queue-thread
    |=  [message=@t thread-name=@tas]
    ^-  vase
    !>  ^-  update:zig
    :-  %queue-thread
    [update-info [%| level message] thread-name]
  ::
  ++  run-queue
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%run-queue update-info [%| level message] ~]
  ::
  ++  poke
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%poke update-info [%| level message] ~]
  ::
  ++  sync-desk-to-vship
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%sync-desk-to-vship update-info [%| level message] ~]
  ::
  ++  pyro-agent-state
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%| level message] ~]
  ::
  ++  pyro-chain-state
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%pyro-agent-state update-info [%| level message] ~]
  ::
  ++  save-file
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%save-file update-info [%| level message] ~]
  ::
  ++  add-project-desk
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%add-project-desk update-info [%| level message] ~]
  ::
  ++  delete-project-desk
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%delete-project-desk update-info [%| level message] ~]
  ::
  ++  get-dev-desk
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%get-dev-desk update-info [%| level message] ~]
  ::
  ++  build-result
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%build-result update-info [%| level message] ~]
  ::
  ++  thread-result
    |=  [message=@t thread-name=@tas]
    ^-  vase
    !>  ^-  update:zig
    :^  %thread-result  update-info  [%| level message]
    thread-name
  ::
  ++  deploy-contract
    |=  [message=@t p=path]
    ^-  vase
    !>  ^-  update:zig
    [%deploy-contract update-info [%| level message] p]
  ::
  ++  linedb
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%linedb update-info [%| level message] ~]
  ::
  ++  state-reset
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%state-reset update-info [%| level message] ~]
  --
::
::  json
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =update:zig
    ^-  json
    ?~  update  ~
    =/  update-info=(list [@t json])
      :+  [%type %s -.update]
        ['project_name' %s project-name.update]
      :^    ['desk_name' %s desk-name.update]
          ['source' %s source.update]
        :-  'request_id'
        ?~(request-id.update ~ [%s u.request-id.update])
      ~
    %-  pairs
    %+  weld  update-info
    ?:  ?=(%| -.payload.update)  (error p.payload.update)
    ?-    -.update
        %focused-project
      ['data' %s p.payload.update]~
    ::
        %project-names
      :+  ['project_names' (set-cords project-names.update)]
        [%data ~]
      ~
    ::
        %projects
      :+  ['projects' (projects projects.update)]
        [%data ~]
      ~
    ::
        %project
      :+  ['project' (project +.+.+.update)]
        [%data ~]
      ~
    ::
        %new-project
      :_  ~
      :-  'data'
      %-  sync-desk-to-vship
      sync-desk-to-vship.p.payload.update
    ::
        %run-queue
      ['data' ~]~
    ::
        %add-config
      :_  ~
      :-  'data'
      %-  pairs
      :^    ['who' %s (scot %p who.p.payload.update)]
          ['what' %s what.p.payload.update]
        ['item' (numb item.p.payload.update)]
      ~
    ::
        %delete-config
      :_  ~
      :-  'data'
      %-  pairs
      :+  ['who' %s (scot %p who.p.payload.update)]
        ['what' %s what.p.payload.update]
      ~
    ::
        %queue-thread
      :+  ['thread_name' %s thread-name.update]
        ['data' %s p.payload.update]
      ~
    ::
        ?(%add-user-file %delete-user-file)
      :+  ['file' (path file.update)]
        ['data' ~]
      ~
    ::
        %dir
      `(list [@t json])`['data' (frond %dir (dir p.payload.update))]~
    ::
        %poke
      ['data' ~]~
    ::
        %thread-queue
      :_  ~
      :-  'data'
      %+  frond  %thread-queue
      (thread-queue p.payload.update)
    ::
        %pyro-agent-state
      :_  ~
      :-  'data'
      %-  pairs
      :^    :+  %pyro-agent-state  %s
            (show-state agent-state.p.payload.update)
          ['outgoing' (boat wex.p.payload.update)]
        ['incoming' (bitt sup.p.payload.update)]
      ~
    ::
        %shown-pyro-agent-state
      :_  ~
      :-  'data'
      %-  pairs
      :^    :+  %pyro-agent-state  %s
            agent-state.p.payload.update
          ['outgoing' (boat wex.p.payload.update)]
        ['incoming' (bitt sup.p.payload.update)]
      ~
    ::
        %pyro-chain-state
      [%data (pyro-chain-state p.payload.update)]~
    ::
        %shown-pyro-chain-state
      [%data %s p.payload.update]~
    ::
        %sync-desk-to-vship
      :_  ~
      :-  'data'
      %-  pairs
      :+  :-  %sync-desk-to-vship
          %-  sync-desk-to-vship
          sync-desk-to-vship.p.payload.update
        :-  %pyro-ships-app-states
        %-  pyro-ships-app-states
        pyro-ships-app-states.p.payload.update
      ~
    ::
        %cis-setup-done
      ['data' ~]~
    ::
        %status
      :_  ~
      :-  'data'
      (frond %status (status p.payload.update))
    ::
        %save-file
      ['data' (path p.payload.update)]~
    ::
        %settings
      ['data' (settings p.payload.update)]~
    ::
        %state-views
      :_  ~
      :-  'data'
      (state-views project-name.update p.payload.update)
    ::
        %add-project-desk
      ['data' ~]~
    ::
        %delete-project-desk
      ['data' ~]~
    ::
        %get-dev-desk
      ['data' ~]~
    ::
        %ziggurat-state
      ['data' ~]~  :: TODO
      :: ['data' p.payload.update]~
    ::
        %configs
      ['data' ~]~  :: TODO
    ::
        %ship-to-address-map
      ['data' ~]~  :: TODO
    ::
        %build-result
      ['data' ~]~
    ::
        %long-operation-current-step
      :_  ~
      ['data' (long-operation-info-body p.payload.update)]
    ::
        %thread-result
      :+  ['thread_name' %s thread-name.update]
        ['data' ~]
      ~
    ::
        %deploy-contract
      ['data' ~]~
    ::
        %linedb
      ['data' ~]~
    ::
        %state-reset
      ['data' ~]~
    ::
        %suite-update-available
      ['data' ~]~
    ::
        %repo-info
      ['data' (repo-info p.payload.update)]~
    ==
  ::
  ++  long-operation-info-body
    |=  loib=long-operation-info-body:zig
    ^-  json
    %-  pairs
    :^    [%name %s name.loib]
        [%steps %a (turn steps.loib |=(s=@tas [%s s]))]
      :-  %current-step
      ?~(current-step.loib ~ [%s u.current-step.loib])
    ~
  ::
  ++  pyro-ships-app-states
    |=  pyro-ships-app-states=(map @p (map @tas (set [@tas ?])))
    ^-  json
    %-  pairs
    %+  turn  ~(tap by pyro-ships-app-states)
    |=  [who=@p psas=(map @tas (set [@tas ?]))]
    [(scot %p who) (pyro-ship-app-states psas)]
  ::
  ++  pyro-ship-app-states
    |=  pyro-ship-app-states=(map @tas (set [@tas ?]))
    ^-  json
    %-  pairs
    %+  turn  ~(tap by pyro-ship-app-states)
    |=  [desk-name=@tas as=(set [@tas ?])]
    [desk-name (app-states as)]
  ::
  ++  app-states
    |=  app-states=(set [@tas ?])
    ^-  json
    %-  pairs
    %+  turn  ~(tap in app-states)
    |=  [app-name=@tas is-installed=?]
    [app-name %b is-installed]
  ::
  ++  settings
    |=  s=settings:zig
    ^-  json
    %-  pairs
    :~  :-  %test-result-num-characters
        (numb test-result-num-characters.s)
    ::
        :-  %state-num-characters
        (numb state-num-characters.s)
    ::
        :-  %compiler-error-num-lines
        (numb compiler-error-num-lines.s)
    ::
        :-  %code-max-characters
        (numb code-max-characters.s)
    ==
  ::
  ++  status
    |=  =status:zig
    ^-  json
    ?-  -.status
      %running-thread  [%s -.status]
      %ready           [%s -.status]
      %uninitialized   [%s -.status]
    ==
  ::
  ++  error
    |=  [level=error-level:zig message=@t]
    ^-  (list [@t json])
    :+  ['level' %s `@tas`level]
      ['message' %s message]
    ~
  ::
  ++  projects
    |=  ps=projects:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by ps)
    |=([p-name=@t p=project:zig] [p-name (project p)])
  ::
  ++  project
    |=  p=project:zig
    ^-  json
    %-  pairs
    :~  ['desks' (desks desks.p)]
        ['pyro_ships' (list-ships pyro-ships.p)]
        ['sync_desk_to_vship' (sync-desk-to-vship sync-desk-to-vship.p)]
        ['most_recent_snap' (path most-recent-snap.p)]
        ['saved_thread_queue' (thread-queue (show-thread-queue saved-thread-queue.p))]
    ==
  ::
  ++  desks
    |=  ds=(list (pair @tas desk:zig))
    ^-  json
    %-  pairs
    =|  desks=(list [@t json])
    =|  i=@
    |-
    ?~  ds  (flop desks)
    =*  desk-name  p.i.ds
    =*  dask       q.i.ds
    $(desks [[desk-name (desk dask i)] desks], i +(i), ds t.ds)
  ::
  ++  desk
    |=  [d=desk:zig i=@]
    ^-  json
    %-  pairs
    :~  ['name' %s name.d]
        ['repo_info' (repo-info repo-info.d)]
        ['dir' (dir dir.d)]
        ['user_files' (dir ~(tap in user-files.d))]
        ['to_compile' (dir ~(tap in to-compile.d))]
        ['saved_test_steps' (saved-test-steps saved-test-steps.d)]
        ['index' (numb i)]
    ==
  ::
  ++  repo-info
    |=  ri=repo-info:zig
    ^-  json
    %-  pairs
    :~  ['repo_host' %s (scot %p repo-host.ri)]
        ['repo_name' %s repo-name.ri]
        ['branch_name' %s branch-name.ri]
        :-  'commit_hash'
        ?~(commit-hash.ri ~ [%s (scot %ux u.commit-hash.ri)])
    ==
  ::
  ++  saved-test-steps
    |=  saved-test-steps=(map @tas [imports:zig test-steps:zig])
    ^-  json
    %-  pairs
    %+  turn  ~(tap by saved-test-steps)
    |=  [thread-name=@tas i=imports:zig tss=test-steps:zig]
    :-  thread-name
    %-  pairs
    :+  [%test-imports (imports i)]
      [%test-steps (test-steps tss)]
    ~
  ::
  ++  test-steps
    |=  =test-steps:zig
    ^-  json
    :-  %a
    (turn test-steps |=(ts=test-step:zig (test-step ts)))
  ::
  ++  test-step
    |=  =test-step:zig
    ^-  json
    ?-    -.test-step
        %scry
      %-  pairs
      :^    ['type' %s -.test-step]
          ['payload' (scry-payload payload.test-step)]
        ['expected' %s expected.test-step]
      ~
    ::
        %wait
      %-  pairs
      :+  ['type' %s -.test-step]
        ['until' %s (scot %dr until.test-step)]
      ~
    ::
        %dojo
      %-  pairs
      :+  ['type' %s -.test-step]
        ['payload' (dojo-payload payload.test-step)]
      ~
    ::
        %poke
      %-  pairs
      :+  ['type' %s -.test-step]
        ['payload' (poke-payload payload.test-step)]
      ~
    ==
  ::
  ++  dojo-payload
    |=  payload=dojo-payload:zig
    ^-  json
    %-  pairs
    :+  ['who' %s (scot %p who.payload)]
      ['payload' %s payload.payload]
    ~
  ::
  ++  scry-payload
    |=  payload=scry-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['mold-name' %s mold-name.payload]
        ['care' %s care.payload]
        ['app' %s app.payload]
        ['path' (path path.payload)]
    ==
  ::
  ++  poke-payload
    |=  payload=poke-payload:zig
    ^-  json
    %-  pairs
    :~  ['who' %s (scot %p who.payload)]
        ['to' %s (scot %p to.payload)]
        ['app' %s app.payload]
        ['mark' %s mark.payload]
        ['payload' %s (crip (noah payload.payload))]
    ==
  ::
  ++  threads
    |=  threads=(set @tas)
    ^-  json
    :-  %a
    %+  turn  ~(tap in threads)  |=(t=@tas [%s t])
  ::
  ++  list-ships
  |=  ss=(list @p)
  ^-  json
  :-  %a
  %+  turn  ss
  |=  s=@p  [%s (scot %p s)]
  ::
  ++  pyro-chain-state
    |=  state=(map @ux batch:ui)
    ^-  json
    %-  pairs
    %+  turn  ~(tap by state)
    |=  [town-id=@ux =batch:ui]
    [(scot %ux town-id) (batch:enjs:ui-lib batch)]
  ::
  ++  imports
    |=  =imports:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by imports)
    |=  [face=@tas p=^path]
    [face (path p)]
  ::
  ++  dir
    |=  dir=(list ^path)
    ^-  json
    :-  %a
    %+  turn  dir
    |=(p=^path (path p))
  ::
  ++  set-cords
    |=  cords=(set @t)
    ^-  json
    :-  %a
    %+  turn  ~(tap in cords)
    |=([cord=@t] [%s cord])
  ::
  ++  sync-desk-to-vship
    |=  =sync-desk-to-vship:zig
    ^-  json
    %-  pairs
    %+  turn  ~(tap by sync-desk-to-vship)
    |=  [desk=@tas ships=(set @p)]
    :+  desk  %a
    %+  turn  ~(tap in ships)
    |=(who=@p [%s (scot %p who)])
  ::
  ++  thread-queue
    |=  thread-queue=shown-thread-queue:zig
    ^-  json
    :-  %a
    %+  turn  ~(tap to thread-queue)
    |=  $:  project-name=@t
            desk-name=@tas
            thread-name=@tas
            payload=shown-thread-queue-payload:zig
        ==
    %-  pairs
    :~  [%project-name %s project-name]
        [%desk-name %s desk-name]
        [%thread-name %s thread-name]
        :-  %payload 
        %-  pairs
        =+  [%type %s -.payload]~
        ?:  ?=(%lard -.payload)  -
        [[%args %s args.payload] -]
    ==
  ::
  ++  boat
    |=  =boat:gall
    ^-  json
    :-  %a
    %+  turn  ~(tap by boat)
    |=  [[w=wire who=@p app=@tas] [ack=? p=^path]]
    %-  pairs
    :~  [%wire (path w)]
        [%ship %s (scot %p who)]
        [%term %s app]
        [%acked %b ack]
        [%path (path p)]
    ==
  ::
  ++  bitt
    |=  =bitt:gall
    ^-  json
    :-  %a
    %+  turn  ~(tap by bitt)
    |=  [d=duct who=@p p=^path]
    %-  pairs
    :~  [%duct %a (turn d |=(w=wire (path w)))]
        [%ship %s (scot %p who)]
        [%path (path p)]
    ==
  ::
  ++  state-views
    |=  $:  project-name=@tas
            state-views=(list [@p (unit @tas) ^path])
        ==
    ^-  json
    =*  our  (scot %p our.bowl)
    =*  now  (scot %da now.bowl)
    =+  .^  =update:zig
            %gx
            /[our]/ziggurat/[now]/get-ziggurat-state/noun
        ==
    ?:  ?=(~ update)                  [%a ~]
    ?.  ?=(%ziggurat-state -.update)  [%a ~]
    ?:  ?=(%| -.payload.update)       [%a ~]
    =*  state=state-0:zig  p.payload.update
    =*  project=project:zig
      (~(got by projects:state) project-name)
    =*  desk=desk:zig
      (got-desk project project-name)
    =/  repo-info=repo-info:zig  repo-info.desk
    =*  rh    (scot %p repo-host.repo-info)
    =*  rn    repo-name.repo-info
    =*  bn  branch-name.repo-info
    =*  commit-hash  commit-hash.repo-info
    =*  commit=@tas
      ?~  commit-hash  %head  (scot %ux u.commit-hash)
    :-  %a
    %+  murn  state-views
    |=  [who=@p app=(unit @tas) file-path=^path]
    =*  file-scry-path=^path
      %-  weld  :_  (snoc file-path %noun)
      /[our]/linedb/[now]/[rh]/[rn]/[bn]/[commit]
    =+  .^(file-contents=(unit @t) %gx file-scry-path)
    ?~  file-contents  ~
    =/  [imports=(list [@tas ^path]) =hair]
      (parse-start-of-pile:conq (trip u.file-contents))
    =/  json-pairs=(list [@tas json])
      :~  [%who %s (scot %p who)]
          [%what %s ?~(app %chain %agent)]
      ::
          :+  %body  %s
          %-  of-wain:format
          %+  slag  (dec p.hair)
          (to-wain:format u.file-contents)
      ::
          :-  %imports
          %-  pairs
          %+  turn  imports
          |=([face=@tas import=^path] [face (path import)])
      ==
    :-  ~
    %-  pairs
    ?~(app json-pairs [[%app %s u.app] json-pairs])
  --
++  dejs
  =,  dejs:format
  |%
  ++  uber-action
    ^-  $-(json action:zig)
    %-  ot
    :~  [%project-name so]
        [%desk-name (se %tas)]
        [%request-id so:dejs-soft:format]
        [%action action]
    ==
  ::
  ++  action
    %-  of
    :~  [%new-project new-project]
        [%delete-project ul]
    ::
        [%add-sync-desk-vships add-sync-desk-vships]
        [%delete-sync-desk-vships (ot ~[[%ships (ar (se %p))]])]
    ::
        [%change-focus ul]
        [%add-project-desk (ot ~[[%index ni:dejs-soft:format] [%repo-host (se %p)] [%branch-name (se %tas)] [%commit-hash (se-soft %ux)]])]
        [%delete-project-desk ul]
    ::
        [%save-file (ot ~[[%file pa] [%contents so] [%repo-info repo-info-soft]])]  :: TODO: allow non-@t %contents
        [%delete-file (ot ~[[%file pa] [%repo-info repo-info-soft]])]
        [%make-configuration-file ul]
    ::
        [%add-config (ot ~[[%who (se %p)] [%what (se %tas)] [%item ni]])]
        [%delete-config (ot ~[[%who (se %p)] [%what (se %tas)]])]
    ::
        [%register-for-compilation (ot ~[[%file pa]])]
        [%unregister-for-compilation (ot ~[[%file pa]])]
        [%deploy-contract-virtualnet deploy-virtual]
        [%deploy-contract-livenet deploy-live]
    ::
        [%build-file (ot ~[[%path pa]])]
        [%watch-repo-for-changes ul]
        [%read-repo ul]
        :: [%read-desk ul]
    ::
        [%queue-thread queue-thread]
        [%save-thread save-thread]
        [%delete-thread (ot ~[[%thread-name (se %tas)]])]
    ::
        [%run-queue ul]
        [%clear-queue ul]
    ::
        [%stop-pyro-ships ul]
        [%start-pyro-ships (ot ~[[%ships (ar (se %p))]])]
    ::
        [%take-snapshot (ot ~[[%update-project-snaps (mu pa)]])]
    ::
        [%publish-app docket]
    ::
        [%add-user-file (ot ~[[%file pa]])]
        [%delete-user-file (ot ~[[%file pa]])]
    ::
        [%send-pyro-dojo (ot ~[[%who (se %p)] [%command sa]])]
    ::
        [%pyro-agent-state pyro-agent-state]
        [%pyro-chain-state pyro-chain-state]
    ::
        [%change-settings change-settings]
    ::
        [%get-dev-desk (se %p)]
    ::
        [%set-repo-info repo-info]
    ::
        [%update-suite ul]
    ==
  ::
  ++  repo-info-soft
    |=  jon=json
    ^-  (unit repo-info:zig)
    ?.(?=([%o *] jon) ~ (some (repo-info jon)))
  ::
  ++  repo-info
    ^-  $-(json repo-info:zig)
    %-  ot
    :~  [%repo-host (se %p)]
        [%repo-name (se %tas)]
        [%branch-name (se %tas)]
        [%commit-hash (se-soft %ux)]
    ==
  ::
  ++  queue-thread
    ^-  $-(json [@tas thread-queue-payload:zig])
    %-  ot
    :+  [%thread-name (se %tas)]
      [%payload thread-queue-payload]
    ~
  ::
  ++  save-thread
    ^-  $-(json [@tas imports:zig test-steps:zig])
    %-  ot
    :^    [%thread-name (se %tas)]
        [%test-imports (om pa)]
      [%test-steps (ar test-step)]
    ~
  ::
  ++  thread-queue-payload
    ^-  $-(json thread-queue-payload:zig)
    %-  of
    :_  ~
    [%fard special-configuration-args]
  ::
  ++  test-step
    ^-  $-(json test-step:zig)
    %-  of
    :~  [%scry (ot ~[[%payload scry-payload] [%expected so]])]
        [%wait (ot ~[[%until (se %dr)]])]
        [%dojo (ot ~[[%payload dojo-payload]])]
        [%poke (ot ~[[%payload poke-payload]])]
    ==
  ::
  ++  scry-payload
    ^-  $-(json scry-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%mold-name so]
        [%care (se %tas)]
        [%app (se %tas)]
        [%path pa]
    ==
  ::
  ++  dojo-payload
    ^-  $-(json dojo-payload:zig)
    %-  ot
    :+  [%who (se %p)]
      [%payload so]
    ~
  ::
  ++  poke-payload
    ^-  $-(json poke-payload:zig)
    %-  ot
    :~  [%who (se %p)]
        [%to (se %p)]
        [%app (se %tas)]
        [%mark (se %tas)]
        [%payload special-configuration-args]
    ==
  ::
  ++  new-project
    ^-  $-(json [@p @tas (unit @ux) vase])
    %-  ot
    :~  [%repo-host (se %p)]
        [%branch-name (se %tas)]
        [%commit-hash (se-soft %ux)]
    ::
        :-  %special-configuration-args
        special-configuration-args
    ==
  ::
  ++  special-configuration-args
    ^-  $-(json vase)
    |=  jon=json
    ?>  ?=([%s *] jon)
    (slap !>(..zuse) (ream p.jon))
  ::
  ++  change-settings
    ^-  $-(json settings:zig)
    %-  ot
    :~  [%test-result-num-characters ni]
        [%state-num-characters ni]
        [%compiler-error-num-lines ni]
        [%code-max-characters ni]
    ==
  ::
  ++  se-soft
    |=  aur=@tas
    |=  jon=json
    ?.(?=([%s *] jon) ~ (some (slav aur p.jon)))
  ::
  ++  docket
    ^-  $-(json [@t @t @ux @t [@ud @ud @ud] @t @t])
    %-  ot
    :~  [%title so]
        [%info so]
        [%color (se %ux)]
        [%image so]
        [%version (at ~[ni ni ni])]
        [%website so]
        [%license so]
    ==
  ::
  ++  deploy-virtual
    ^-  $-(json [who=(unit @p) town-id=@ux contract-jam-path=path])
    %-  ot
    :~  [%who (se-soft %p)]
        [%town-id (se %ux)]
        [%contract-jam-path pa]
    ==
  ::
  ++  deploy-live
    ^-  $-(json [from=@ux town-id=@ux contract-jam-path=path])
    %-  ot
    :~  [%who (se %ux)]
        [%town-id (se %ux)]
        [%contract-jam-path pa]
    ==
  ::
  ++  add-sync-desk-vships
    ^-  $-(json [(list @p) (list @p) (list @tas)])
    %-  ot
    :^    [%ships (ar (se %p))]
        [%install (ar (se %p))]
      [%start-apps (ar (se %tas))]
    ~
  ::
  ++  pyro-agent-state
    ^-  $-(json [who=@p app=@tas =imports:zig grab=@t])
    %-  ot
    :~  [%who (se %p)]
        [%app (se %tas)]
        [%imports (om pa)]
        [%grab so]
    ==
  ::
  ++  pyro-chain-state
    ^-  $-(json [=imports:zig grab=@t])
    (ot ~[[%imports (om pa)] [%grab so]])
  --
:: ::
:: ++  show-thread-queue
::   |=  =thread-queue:zig
::   ^-  shown-thread-queue:zig
::   %-  ~(gas to *shown-thread-queue:zig)
::   %+  turn  ~(tap to thread-queue)
::   |=  i=thread-queue-item:zig
::   ^-  shown-thread-queue-item:zig
::   :^  project-name.i  desk-name.i  thread-name.i
::   (crip (noah thread-args.i))
::
++  show-thread-queue
  |=  =thread-queue:zig
  ^-  shown-thread-queue:zig
  %-  ~(gas to *shown-thread-queue:zig)
  %+  turn  ~(tap to thread-queue)
  |=  i=thread-queue-item:zig
  ^-  shown-thread-queue-item:zig
  :^  project-name.i  desk-name.i  thread-name.i
  ?:  ?=(%lard -.payload.i)  [%lard ~]
  [%fard (crip (noah args.payload.i))]
--
