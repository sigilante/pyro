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
    ui-lib=zig-indexer,
    zink=zink-zink
/*  smart-lib-noun  %noun  /lib/zig/sys/smart-lib/noun
/*  triv-txt        %hoon  /con/trivial/hoon
|_  [=bowl:gall =settings:zig]
+*  this    .
    io      ~(. agentio bowl)
    strand  strand:spider
::
+$  card  card:agent:gall
::
::  utilities
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
++  make-compile-contracts
  |=  [project-name=@t desk-name=@tas request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  desk-name  request-id
  [%compile-contracts ~]
::
++  make-read-desk
  |=  [project-name=@t desk-name=@tas request-id=(unit @t)]
  ^-  card
  %-  ~(poke-self pass:io /self-wire)
  :-  %ziggurat-action
  !>  ^-  action:zig
  :^  project-name  desk-name  request-id
  [%read-desk ~]
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
  |=  [project-name=@t desk-name=@tas]
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name]/[desk-name])
  [desk-name ~ %next %v da+now.bowl /]
::
++  make-cancel-watch-for-file-changes
  |=  [project-name=@t desk-name=@tas]
  ^-  card
  %-  ~(warp-our pass:io /clay/[project-name]/[desk-name])
  [desk-name ~]
::
++  make-save-jam
  |=  [desk-name=@tas file=path non=*]
  ^-  card
  ?>  ?=(%jam (rear file))
  %-  ~(arvo pass:io /save-wire)
  :+  %c  %info
  [`@tas`desk-name %& [file %ins %noun !>(`@`(jam non))]~]
::
++  make-save-file
  |=  [=update-info:zig file=path text=@t]
  ^-  card
  =*  desk-name  desk-name.update-info
  =/  file-type=@tas  (rear file)
  |^
  =/  supported-file-types=(set @tas)
    %-  ~(gas in *(set @tas))
    ~[%hoon %ship %bill %kelvin %docket-0]
  ?:  (~(has in supported-file-types) file-type)  make-card
  =/  is-mark-found=?
    .^  ?
        %cu
        %+  weld  /(scot %p our.bowl)/[desk-name]
        /(scot %da now.bowl)/mar/[file-type]/hoon
    ==
  ?:  is-mark-found                               make-card
  %-  update-vase-to-card
  %-  %~  save-file  make-error-vase
      [update-info %error]
  %-  crip
  ;:  weld
      "cannot save file with mark {<`@tas`file-type>}."
      " supported file marks are"
      " {<`(set @tas)`supported-file-types>}"
      " and marks with %mime grow arms in"
      " {<`path`/[desk-name]/mar>}"
  ==
  ::
  ++  make-card
    ^-  card
    =.  text  ?.(=('' text) text (make-template file))
    =/  mym=mime
      :-  /application/x-urb-unknown
      %-  as-octt:mimes:html
      %+  rash  text
      (star ;~(pose (cold '\0a' (jest '\0d\0a')) next))
    %-  ~(arvo pass:io /save-wire)
    :-  %c
    :^  %info  desk-name  %&
    :_  ~  :+  file  %ins
    =*  reamed-text  q:(slap !>(~) (ream text))  ::  =* in case text unreamable
    ?+    file-type  [%mime !>(mym)] :: don't need to know mar if we have bytes :^)
        %hoon        [%hoon !>(text)]
        %ship        [%ship !>(;;(@p reamed-text))]
        %bill        [%bill !>(;;((list @tas) reamed-text))]
        %kelvin      [%kelvin !>(;;([@tas @ud] reamed-text))]
        %docket-0
      =-  [%docket-0 !>((need (from-clauses:mime:dock -)))]
      ;;((list clause:dock) reamed-text)
    ==
  --
::
++  make-configs-file
  |=  $:  imports-list=(list [@tas path])
          =config:zig
          vships-to-sync=(list @p)
          install=?
          start-apps=(list @tas)
          state-views=(list [@p (unit @tas) path])
          :: setup=(map @p test-steps:zig)
          setup=(map @p thread-path=path)
      ==
  |^  ^-  @t
  %+  rap  3
  :~
  ::  imports
    %+  roll  imports-list
    |=  [[face=@tas file=path] imports=@t]
    %+  rap  3
    :~  imports
        '/=  '
        face
        '  '
        (crip (noah !>(file)))
        '\0a'
    ==
  ::  infix
    '''
    ::
    |%
    ++  make-config
      ^-  config:zig
      %-  ~(gas by *config:zig)

    '''
    '  '
    (crip (noah !>(`(list [[@p @tas] @])`~(tap by config))))
    '\0a'
    '''
    ::
    ++  make-virtualships-to-sync
      ^-  (list @p)

    '''
    '  '
    (crip (noah !>(`(list @p)`vships-to-sync)))
    '\0a'
    '''
    ::
    ++  make-install
      ^-  ?

    '''
    '  '
    (crip (noah !>(`?`install)))
    '\0a'
    '''
    ::
    ++  make-start-apps
      ^-  (list @tas)

    '''
    '  '
    (crip (noah !>(`(list @tas)`start-apps)))
    '\0a'
    '''
    ++  make-state-views
      ^-  (list [who=@p app=(unit @tas) file-path=path])
      ::  app=~ -> chain view, not an agent view

    '''
    '  '
    %-  crip
    (noah !>(`(list [@p (unit @tas) path])`state-views))
    '\0a'
    make-make-setup
  ::  suffix
    '''
    --

    '''
  ==
  ::
  ++  make-make-setup
    ^-  @t
    ?:  =(0 ~(wyt by setup))
      '''
      ::
      ++  make-setup
        ^-  (map @p thread-path=path)
        ~

      '''
    ~&  "TODO: bother ~hosted-fornet to finish implementing non-null setup case! Just needs a roll to add arms for ++make-setup-* and testing"
    !!
    :: %+  rap  3
    :: :~
    ::   '''
    ::   \0a::
    ::   ++  make-setup
    ::     |^  ^-  (map @p test-steps:zig)
    ::     %-  ~(gas by *(map @p test-steps:zig))
    ::     :~

    ::   '''
    :: ::  [~zod make-setup-zod] pairs
    ::   %+  roll  vships-to-sync
    ::   |=  [who=@p test-steps-text=@t]
    ::   =/  noah-who=tape  (noah !>(`@p`who))
    ::   %+  rap  3
    ::   :~  test-steps-text
    ::       '    ['
    ::       (crip noah-who)
    ::       ' make-setup-'
    ::       (crip (slag 1 noah-who))
    ::       ']\0a'
    ::   ==
    :: ::  suffix of main
    ::   '''
    ::   ==
    ::   ::
    ::  ::  test-steps
    ::    %+  roll  test-steps
    ::    |=  [=test-step:zig test-steps-text=@t]
    ::    %+  rap  3
    ::    :~  test-steps-text
    ::        '  ::\0a'
    ::        '    '
    ::        (crip (noah !>(test-step)))
    ::        '\0a'
    ::    ==
    ::   '''
    :: ==
  --
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
++  save-compiled-contracts
  |=  $:  desk-name=@t
          build-results=(list [p=path q=build-result:zig])
      ==
  ^-  [(list card) (list [path @t])]
  =|  cards=(list card)
  =|  errors=(list [path @t])
  |-
  ?~  build-results      [cards errors]
  =*  contract-path       p.i.build-results
  =/  =build-result:zig   q.i.build-results
  =/  save-result=(each card [path @t])
    %^  save-compiled-contract  desk-name  contract-path
    build-result
  ?:  ?=(%| -.save-result)
    %=  $
        build-results  t.build-results
        errors         [p.save-result errors]
    ==
  %=  $
      build-results  t.build-results
      cards          [p.save-result cards]
  ==
::
++  save-compiled-contract
  |=  $:  desk-name=@tas
          contract-path=path
          =build-result:zig
      ==
  ^-  (each card [path @t])
  ?:  ?=(%| -.build-result)
    [%| [contract-path p.build-result]]
  =/  contract-jam-path=path
    (need (convert-contract-hoon-to-jam contract-path))
  :-  %&
  %^  make-save-jam  desk-name  contract-jam-path
  p.build-result
::
++  build-contract-projects
  |=  $:  smart-lib=vase
          desk=path
          to-compile=(set path)
      ==
  ^-  (list [path build-result:zig])
  %+  turn  ~(tap in to-compile)
  |=  p=path
  ~&  "building {<p>}..."
  [p (build-contract-project smart-lib desk p)]
::
++  build-contract-project
  :: !.
  |=  [smart-lib=vase desk=path to-compile=path]
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
    =/  p=path  (welp desk to-compile)
    ?.  .^(? %cu p)
      :-  %|
      %-  crip
      %+  weld  "did not find contract at {<to-compile>}"
      " in desk {<`@tas`(snag 1 desk)>}"
    [%& (parse-pile:conq p (trip .^(@t %cx p)))]
  ::
  ++  parse-imports  ::  second
    |=  raw=(list [face=term p=path])
    ^-  (each (list hoon) @t)
    =/  non-existent-libs=(list path)
      %+  murn  raw
      |=  [face=term p=path]
      =/  hp=path  (welp p /hoon)
      =/  tp=path  (welp desk hp)
      ?:  .^(? %cu tp)  ~  `hp
    ?^  non-existent-libs
      :-  %|
      %-  crip
      %+  weld  "did not find imports for {<to-compile>} at"
      " {<`(list path)`non-existent-libs>} in desk {<`@tas`(snag 1 desk)>}"
    :-  %&
    %+  turn  raw
    |=  [face=term p=path]
    =/  tp=path  (welp desk (welp p /hoon))
    ^-  hoon
    :+  %ktts  face
    +:(parse-pile:conq tp (trip .^(@t %cx tp)))
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
          /[now]/i/[who]/gu/[who]/indexer/[now]/noun
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
::  scry %ca or fetch from local cache
::
++  scry-or-cache-ca
  |=  [desk-name=@tas p=path =ca-scry-cache:zig]
  |^  ^-  (unit [vase ca-scry-cache:zig])
  =/  scry-path=path
    :-  (scot %p our.bowl)
    (weld /[desk-name]/(scot %da now.bowl) p)
  ?~  cache=(~(get by ca-scry-cache) [desk-name p])
    scry-and-cache-ca
  ?.  =(p.u.cache .^(@ %cz scry-path))  scry-and-cache-ca
  `[q.u.cache ca-scry-cache]
  ::
  ++  scry-and-cache-ca
    ^-  (unit [vase ca-scry-cache:zig])
    =/  scry-result
      %-  mule
      |.
      =/  scry-path=path
        :-  (scot %p our.bowl)
        (weld /[desk-name]/(scot %da now.bowl) p)
      =/  scry-vase=vase  .^(vase %ca scry-path)
      :-  scry-vase
      %+  ~(put by ca-scry-cache)  [desk-name p]
      [`@ux`.^(@ %cz scry-path) scry-vase]
    ?:  ?=(%& -.scry-result)  `p.scry-result
    ~&  %ziggurat^%scry-and-cache-ca-fail
    ~
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
++  sync-desk-to-virtualship-card
  |=  [who=@p project-name=@tas]
  ^-  card
  %+  %~  poke-our  pass:io
      /sync/(scot %da now.bowl)/[project-name]/(scot %p who)
    %pyro
  (sync-desk-to-virtualship-cage who project-name)
::
++  sync-desk-to-virtualship-cage
  |=  [who=@p project-name=@tas]
  ^-  cage
  :-  %pyro-events
  !>  ^-  (list pyro-event:pyro)
  :_  ~
  :+  who  /c/commit/(scot %p who)
  (park:pyro-lib our.bowl project-name %da now.bowl)
::
++  send-pyro-dojo-card
  |=  [who=@p command=tape]
  ^-  card
  %+  %~  poke-our  pass:io
      /dojo/(scot %p who)/(scot %ux `@ux`(jam command))
    %pyro
  (send-pyro-dojo-cage who command)
::
++  send-pyro-dojo-cage
  |=  [who=@p command=tape]
  ^-  cage
  :-  %pyro-events
  !>  ^-  (list pyro-event:pyro)
  (dojo-events:pyro-lib who command)
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
++  compile-imports
  |=  $:  project-name=@t
          desk-name=@tas
          imports=(list [face=@tas =path])
          state=inflated-state-0:zig
      ==
  ^-  [(each vase @t) inflated-state-0:zig]
  =/  compilation-result
    %-  mule
    |.
    =/  [subject=vase c=ca-scry-cache:zig]
      %+  roll  imports
      |:  [[face=`@tas`%$ sur=`path`/] [subject=`vase`!>(..zuse) ca-scry-cache=ca-scry-cache:state]]
      =^  sur-hoon=vase  ca-scry-cache
        %-  need  ::  TODO: handle error
        %^  scry-or-cache-ca  desk-name
        (snoc sur %hoon)  ca-scry-cache
      :_  ca-scry-cache
      %-  slop  :_  subject
      sur-hoon(p [%face face p.sur-hoon])
    [subject c]
  ?:  ?=(%& -.compilation-result)
    :-  [%& -.p.compilation-result]
    state(ca-scry-cache +.p.compilation-result)
  :_  state
  :-  %|
  %-  crip
  %+  roll  p.compilation-result
  |=  [in=tank out=tape]
  :(weld ~(ram re in) "\0a" out)
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
::  uqbar-core:lib/zink/conq/hoon duplicated here with changes
::   that allow for more verbose compilation error output
::
++  conq
  |%
  ::
  ++  hash
    |=  [n=* cax=cache:zink]
    ^-  phash:zink
    ?@  n
      ?:  (lte n 12)
        =/  ch  (~(get by cax) n)
        ?^  ch  u.ch
        (hash:pedersen:zink n 0)
      (hash:pedersen:zink n 0)
    ?^  ch=(~(get by cax) n)
      u.ch
    =/  hh  $(n -.n)
    =/  ht  $(n +.n)
    (hash:pedersen:zink hh ht)
  ::
  ++  compile-path
    !.
    |=  pax=path
    ^-  [bat=* pay=*]
    =/  desk=path  (swag [0 3] pax)
    (compile-contract pax desk .^(@t %cx pax))
  ::
  ++  compile-contract
    !.
    |=  [pax=path desk=path txt=@t]
    ^-  [bat=* pay=*]
    ::
    ::  goal flow:
    ::  - take main file, parse to find libs
    ::  - for each lib, parse to find any libs there
    ::  - if an import is already present in that stack
    ::    (circular), crash
    ::  - once a file with no imports is reached, (rain ) it
    ::  - compose against this back up the stack
    ::
    ::  old stuff:
    ::
    ::  parse contract code
    =/  [raw=(list [face=term =path]) contract-hoon=hoon]
      (parse-pile pax (trip txt))
    ::  generate initial subject containing uHoon
    =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ::  compose libraries against uHoon subject
    =/  libraries=hoon
      :-  %clsg
      %+  turn  raw
      |=  [face=term =path]
      =/  pax  (weld desk path)
      ^-  hoon
      :+  %ktts  face
      =/  lib-txt  .^(@t %cx (welp pax /hoon))
      ::  CURRENTLY IGNORING IMPORTS INSIDE LIBRARIES
      +:(parse-pile pax (trip lib-txt))
    =/  pay=*  q:(~(mint ut p.smart-lib) %noun libraries)
    =/  payload=vase  (slap smart-lib libraries)
    =/  cont
      %+  ~(mint ut p:(slop smart-lib payload))
      %noun  contract-hoon
    ::
    [bat=q.cont pay]
  ::
  ++  compile-trivial
    |=  [pax=path hoonlib-txt=@t smartlib-txt=@t]
    ^-  vase
    =/  [raw=(list [face=term =path]) contract-hoon=hoon]
      (parse-pile /con/trivial/hoon (trip triv-txt))
    =/  smart-lib=vase
      ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    =/  libraries=hoon  [%clsg ~]
    =/  full-nock=*     q:(~(mint ut p.smart-lib) %noun libraries)
    =/  payload=vase    (slap smart-lib libraries)
    ::
    (slap (slop smart-lib payload) contract-hoon)
  ::
  ++  conq
    |=  [pax=path hoonlib-txt=@t smartlib-txt=@t cax=cache:zink bud=@ud]
    ^-  (map * phash:zink)
    |^
    =.  cax
      %-  ~(gas by cax)
      %+  turn  (gulf 0 12)
      |=  n=@
      ^-  [* phash:zink]
      [n (hash n ~)]
    ~&  >>  %compiling
    =/  built-contract  (compile-trivial pax hoonlib-txt smartlib-txt)
    ~&  >>  %hashing-arms
    =.  cax
      %^  cache-file  built-contract
        cax
      :~  ::  hoon
          ::  four layers
          'add'
          'biff'
          'egcd'
          'po'
          ::  inner layers
          'dif:fe'
          'all:in'
          'all:by'
          'get:ja'
          'del:ju'
          'apt:to'
          'le:nl'
          'abs:si'
          'sb:ff'
          ::  smart
          ::  five layers
          'pedersen'
          'hash'
          'ship'
          'id'
          'big'
          ::  inner layers (reverse order)
          'as-octs:secp:crypto'
          'hmac-sha1:hmac:crypto'
          'keccak-224:keccak:crypto'
          'as:crub:crypto'
          'sal:scr:crypto'
          'ahem:aes:crypto'
          'aes:crypto'
          'as-octs:mimes:html'
          'mimes:html'
          'fu:number'
          'pass:ames'
          'hash:pedersen'
          't:pedersen'
          ::  'bif:bi'
          'frond:enjs:format'
      ==
    ~&  >>  %hashing-trivial-core
    ::
    ::  =/  [raw=(list [face=term =path]) contract-hoon=hoon]  (parse-pile /con/trivial/hoon (trip triv-txt))
    ::  =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ::  =/  libraries=hoon  [%clsg ~]
    ::  =/  full-nock=*  q:(~(mint ut p.smart-lib) %noun libraries)
    ::  =/  payload=vase  (slap smart-lib libraries)
    ::  =/  cont  (~(mint ut p:(slop smart-lib payload)) %noun contract-hoon)
    ::  ::
    ::  =/  gun  (~(mint ut p.cont) %noun (ream '~'))
    ::  =/  =book  (zebra bud cax *chain-state-scry [q.cont q.gun] %.n)
    ::  ~&  p.book
    ::  cax.q.book
    ::
    =/  smart-lib=vase  ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    =/  code=[bat=* pay=*]  (compile-contract /con/trivial/hoon /zig triv-txt)
    =/  cor  .*([q.smart-lib pay.code] bat.code)
    =/  dor  [-:!>(*contract:smart) cor]
    =/  gun  (ajar:engine dor %write !>(*context:smart) !>(*calldata:smart) %$)
    =/  =book:zink  (zebra:zink bud cax jets:zink *chain-state-scry:zink gun %.n)
    ~&  p.book
    cax.q.book
    ::
    ++  cache-file
      |=  [vax=vase cax=cache:zink layers=(list @t)]
      ^-  cache:zink
      |-
      ?~  layers
        cax
      =/  cor  (slap vax (ream (cat 3 '..' i.layers)))
      =/  min  (~(mint ut p.vax) %noun (ream (cat 3 '..' i.layers)))
      $(layers t.layers, cax (hash-arms cor cax))
    ::
    ++  hash-arms
      |=  [vax=vase cax=(map * phash:zink)]
      ^-  (map * phash:zink)
      =/  lis  (sloe p.vax)
      =/  len  (lent lis)
      =/  i  1
      |-
      ?~  lis  cax
      =*  t  i.lis
      ~&  >  %-  crip
             %-  zing
             :~  (trip t)
                 (reap (sub 20 (met 3 t)) ' ')
                 (trip (rap 3 (scot %ud i) '/' (scot %ud len) ~))
             ==
      =/  n  q:(slot (arm-axis vax t) vax)
      $(lis t.lis, cax (~(put by cax) n (hash n cax)), i +(i))
    --
  ::  conq helpers
  ++  arm-axis
    |=  [vax=vase arm=term]
    ^-  @
    =/  r  (~(find ut p.vax) %read ~[arm])
    ?>  ?=(%& -.r)
    ?>  ?=(%| -.q.p.r)
    p.q.p.r
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
  ^-  @t
  '''
  /-  spider,
      zig=zig-ziggurat
  /+  ziggurat-threads=zig-ziggurat-threads
  ::
  =*  strand     strand:spider
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
  ++  make-config
    ^-  config:zig
    ~
  ::
  ++  make-state-views
    ^-  state-views:zig
    ~
  ::
  ++  make-virtualships-to-sync
    ^-  (list @p)
    ~  ::  ~ -> default-ships:zig-lib
  ::
  ++  make-install
    ^-  ?
    %.n
  ::
  ++  make-start-apps
    ^-  (list @tas)
    ~
  ::
  ++  run-setup-desk
    |=  request-id=(unit @t)
    =/  m  (strand ,vase)
    ^-  form:m
    %:  setup-desk:zig-threads
        project-name
        desk-name
        request-id
        !>(~)
        make-config
        make-state-views
        make-virtualships-to-sync
        make-install
        make-start-apps
    ==
  ::
  ++  setup-virtualship-state
    =/  m  (strand ,vase)
    ^-  form:m
    (pure:m !>(~))
  ::
  ++  ted
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
    |^  ^-  @t
    ?~  file-path               ''
    ?~  t.file-path             ''
    ?+  `@tas`i.t.file-path     ''
      %configs                  configs
      %custom-step-definitions  custom-step-definitions
      %test-steps               test-steps
    ==
    ::
    ++  configs
      ^-  @t
      '''
      /=  zig  /sur/zig/ziggurat
      ::
      /=  mip  /lib/mip
      ::
      |%
      ++  make-config
        ^-  config:zig
        *config:zig
      ::
      ++  make-virtualships-to-sync
        ^-  (list @p)
        ~[~nec ~bud ~wes]
      ::
      ++  make-install
        ^-  ?
        ^.y
      ::
      ++  make-start-apps
        ^-  (list @tas)
        ~
      ::
      ++  make-setup
        |^  ^-  (map @p test-steps:zig)
        %-  ~(gas by *(map @p test-steps:zig))
        :^    [~nec make-setup-nec]
            [~bud make-setup-bud]
          [~wes make-setup-wes]
        ~
        ::
        ++  make-setup-nec
          ^-  test-steps:zig
          =/  who=@p  ~nec
          ~
        ::
        ++  make-setup-bud
          ^-  test-steps:zig
          =/  who=@p  ~bud
          ~
        ::
        ++  make-setup-wes
          ^-  test-steps:zig
          =/  who=@p  ~wes
          ~
        --
      --
      '''
    ::
    ++  custom-step-definitions
      ^-  @t
      .^  @t
          %cx
          :-  (scot %p our.bowl)
          %+  weld  /[q.byk.bowl]/(scot %da now.bowl)/zig
          /custom-step-definitions/deploy-contract/hoon
      ==
    ::
    ++  test-steps
      ^-  @t
      .^  @t
          %cx
          %+  weld  /(scot %p our.bowl)/[q.byk.bowl]
          /(scot %da now.bowl)/zig/test-steps/send-nec/hoon
      ==
    --
  --
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
  ++  compile-contract
    ^-  vase
    !>  ^-  update:zig
    [%compile-contract update-info [%& ~] ~]
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
  ++  sync-desk-to-vship
    |=  =sync-desk-to-vship:zig
    ^-  vase
    !>  ^-  update:zig
    :^  %sync-desk-to-vship  update-info
    [%& sync-desk-to-vship]  ~
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
  ++  compile-contract
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    [%compile-contract update-info [%| level message] ~]
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
  ++  suspend-uninstall-to-make-dev-desk
    |=  message=@t
    ^-  vase
    !>  ^-  update:zig
    :^  %suspend-uninstall-to-make-dev-desk  update-info
    [%| level message]  ~
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
        ?(%compile-contract %run-queue)
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
      %+  frond  %sync-desk-to-vship
      (sync-desk-to-vship p.payload.update)
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
        %suspend-uninstall-to-make-dev-desk
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
    ==
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
        ['most_recent_snap' (path most-recent-snap.p)]
        ['saved_thread_queue' (thread-queue (show-thread-queue saved-thread-queue.p))]
    ==
  ::
  ++  desks
    |=  ds=(list (pair @tas desk:zig))
    ^-  json
    :-  %a
    %+  turn  ds
    |=  [desk-name=@tas d=desk:zig]
    [%a ~[[%s desk-name] (desk d)]]
  ::
  ++  desk
    |=  d=desk:zig
    ^-  json
    %-  pairs
    :~  ['dir' (dir dir.d)]
        ['user_files' (dir ~(tap in user-files.d))]
        ['to_compile' (dir ~(tap in to-compile.d))]
        ['threads' (threads threads.d)]
    ==
  ::
  ++  threads
    |=  threads=(set ^path)
    ^-  json
    :-  %a
    %+  turn  ~(tap in threads)
    |=  thread=^path  (path thread)
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
    :-  %a
    %+  murn  state-views
    |=  [who=@p app=(unit @tas) file-path=^path]
    =/  file-scry-path=^path
      %-  weld  :_  file-path
      /(scot %p our.bowl)/[project-name]/(scot %da now.bowl)
    =+  .^(is-file-found=? %cu file-scry-path)
    ?.  is-file-found  ~
    =+  .^(file-contents=@t %cx file-scry-path)
    =/  [imports=(list [@tas ^path]) =hair]
      (parse-start-of-pile:conq (trip file-contents))
    =/  json-pairs=(list [@tas json])
      :~  [%who %s (scot %p who)]
          [%what %s ?~(app %chain %agent)]
      ::
          :+  %body  %s
          %-  of-wain:format
          (slag (dec p.hair) (to-wain:format file-contents))
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
        [%save-config-to-file ul]
    ::
        [%add-sync-desk-vships add-sync-desk-vships]
        [%delete-sync-desk-vships (ot ~[[%ships (ar (se %p))]])]
    ::
        [%change-focus ul]
        [%add-project-desk (ot ~[[%index ni:dejs-soft:format] [%fetch-desk-from-remote-ship (se-soft %p)] [%special-configuration-args special-configuration-args]])]
        [%delete-project-desk ul]
    ::
        [%save-file (ot ~[[%file pa] [%text so]])]
        [%delete-file (ot ~[[%file pa]])]
    ::
        [%add-config (ot ~[[%who (se %p)] [%what (se %tas)] [%item ni]])]
        [%delete-config (ot ~[[%who (se %p)] [%what (se %tas)]])]
    ::
        [%register-contract-for-compilation (ot ~[[%file pa]])]
        [%unregister-contract-for-compilation (ot ~[[%file pa]])]
        [%deploy-contract deploy]
    ::
        [%compile-contracts ul]
        [%compile-contract (ot ~[[%path pa]])]
        [%read-desk ul]
    ::
        :: [%run-queue ul]
        :: [%clear-queue ul]
    ::
        [%stop-pyro-ships ul]
        [%start-pyro-ships (ot ~[[%ships (ar (se %p))]])]
        [%start-pyro-snap (ot ~[[%snap pa]])]
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
        [%cis-panic ul]
    ::
        [%change-settings change-settings]
    ::
        [%get-dev-desk (se %p)]
        [%suspend-uninstall-to-make-dev-desk ul]
    ==
  ::
  ++  new-project
    ^-  $-(json [(list @p) (unit @p) vase])
    %-  ot
    :^    [%sync-ships (ar (se %p))]
        [%fetch-data-from-remote-ship (se-soft %p)]
      :-  %special-configuration-args
      special-configuration-args
    ~
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
  ++  deploy
    ^-  $-(json [town-id=@ux contract-jam=path])
    %-  ot
    :~  [%town-id (se %ux)]
        [%path pa]
    ==
  ::
  ++  add-sync-desk-vships
    ^-  $-(json [(list @p) ? (list @tas)])
    %-  ot
    :^    [%ships (ar (se %p))]
        [%install bo]
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
