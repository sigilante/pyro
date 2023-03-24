/-  spider,
    eng=zig-engine,
    pyro=zig-pyro,
    seq=zig-sequencer,
    ui=zig-indexer,
    zig=zig-ziggurat
/+  agentio,
    mip,
    strandio,
    conq=zink-conq,
    dock=docket,
    pyro-lib=pyro-pyro,
    smart=zig-sys-smart,
    ui-lib=zig-indexer,
    zink=zink-zink
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
:: ::
:: ++  make-test-steps-file
::   |=  =test:zig
::   ^-  @t
::   %+  rap  3
::   :~
::   ::  imports
::     %+  roll  ~(tap by test-imports.test)
::     |=  [[face=@tas file=path] imports=@t]
::     %+  rap  3
::     :~  imports
::         '/=  '
::         face
::         '  '
::         (crip (noah !>(file)))
::         '\0a'
::     ==
::   ::  infix
::     '''
::     ::
::     |%
::     ++  $
::       ^-  test-steps:zig
::       :~
:: 
::     '''
::   ::  test-steps
::     %+  roll  steps.test
::     |=  [=test-step:zig test-steps-text=@t]
::     %+  rap  3
::     :~  test-steps-text
::         '  ::\0a'
::         '    '
::         (crip (noah !>(test-step)))
::         '\0a'
::     ==
::   ::  suffix
::     '''
::       ==
::     --
:: 
::     '''
::   ==
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
  !.
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
++  build-default-configuration
  |=  [=config:zig desk-name=@tas]
  ^-  configuration-file-output:zig
  =*  ships  default-ships
  :*  config
      ships
  ::
      =/  bill-path=path
        :-  (scot %p our.bowl)
        /[desk-name]/(scot %da now.bowl)/desk/bill
      .^(? %cu bill-path)
  ::
      ~
      ~
      ~
  ==
::
++  load-configuration-file
  :: !.
  |=  [=update-info:zig state=inflated-state-0:zig]
  ^-  [[(list card) (unit configuration-file-output:zig)] inflated-state-0:zig]
  =*  project-name  project-name.update-info
  =*  desk-name     desk-name.update-info
  =/  new-project-error
    %~  new-project  make-error-vase
    [update-info(source %load-configuration-file) %error]
  =/  config-file-path=path
    %+  weld  /(scot %p our.bowl)/[desk-name]
    /(scot %da now.bowl)/zig/configs/[desk-name]/hoon
  |^
  ?.  .^(? %cu config-file-path)
    =/  =configuration-file-output:zig
      (build-default-configuration ~ desk-name)
    =^  cards=(list card)  state
      (build-cards-and-state configuration-file-output)
    [[cards `configuration-file-output] state]
  =/  result  get-configuration-from-file
  ?:  ?=(%| -.result)  [[-.p.result ~] +.p.result]
  =*  configuration-file-output  p.result
  =^  cards=(list card)  state
    (build-cards-and-state configuration-file-output)
  [[cards `configuration-file-output] state]
  ::
  ++  get-configuration-from-file
    |^  ^-  (each configuration-file-output:zig [(list card) inflated-state-0:zig])
    =/  file-cord=@t  .^(@t %cx config-file-path)
    =/  [imports=(list [face=@tas =path]) payload=hoon]
      (parse-pile:conq config-file-path (trip file-cord))
    =^  subject=(each vase @t)  state
      %-  compile-imports
      [project-name desk-name imports state]
    ?:  ?=(%| -.subject)
      %+  make-error  p.subject
      'config imports compilation failed with error:\0a'
    =/  config-core
      (mule-slap-subject p.subject payload)
    ?:  ?=(%| -.config-core)
      %+  make-error  p.config-core
      'config compilation failed with:\0a'
    ::
    =/  config-result
      (mule-slap-subject p.config-core (ream %make-config))
    ?:  ?=(%| -.config-result)
      %+  make-error  p.config-result
      'failed to call +make-config arm:\0a'
    ::
    =/  virtualships-to-sync-result
      %+  mule-slap-subject  p.config-core
      (ream %make-virtualships-to-sync)
    ?:  ?=(%| -.virtualships-to-sync-result)
      %+  make-error  p.virtualships-to-sync-result
      'failed to call +make-virtualships-to-sync arm:\0a'
    ::
    =/  install-result
      (mule-slap-subject p.config-core (ream %make-install))
    ?:  ?=(%| -.install-result)
      %+  make-error  p.install-result
      'failed to call +make-install arm:\0a'
    ::
    =/  start-apps-result
      %+  mule-slap-subject  p.config-core
      (ream %make-start-apps)
    ?:  ?=(%| -.start-apps-result)
      %+  make-error  p.start-apps-result
      'failed to call +make-start-apps arm:\0a'
    ::
    =/  state-views-result
      %+  mule-slap-subject  p.config-core
      (ream %make-state-views)
    ?:  ?=(%| -.state-views-result)
      %+  make-error  p.state-views-result
      'failed to call +make-state-views arm:\0a'
    ::
    =/  setup-result
      (mule-slap-subject p.config-core (ream %make-setup))
    ?:  ?=(%| -.setup-result)
      %+  make-error  p.setup-result
      'failed to call +make-setup arm:\0a'
    ::
    :*  %&
        !<(config:zig p.config-result)
        !<((list @p) p.virtualships-to-sync-result)
        !<(? p.install-result)
        !<((list @tas) p.start-apps-result)
        !<((list [@p (unit @tas) path]) p.state-views-result)
        !<((map @p thread-path=path) p.setup-result)
    ==
    ::
    ++  make-error
      |=  [error=@t message=@t]
      ^-  (each configuration-file-output:zig [(list card) inflated-state-0:zig])
      :-  %|
      :_  state
      :_  ~
      %-  update-vase-to-card
      (new-project-error (cat 3 message error))
    --
  ::
  ++  build-cards-and-state
    |=  $:  =config:zig
            virtualships-to-sync=(list @p)
            install=?
            start-apps=(list @tas)
            state-views=(list [who=@p app=(unit @tas) file=path])
            setups=(map @p thread-path=path)
        ==
    ^-  [(list card) inflated-state-0:zig]
    =/  setups-not-run=(set @p)
      %-  ~(dif in ~(key by setups))
      (~(gas in *(set @p)) virtualships-to-sync)
    =/  cards=(list card)
      ?:  =(0 ~(wyt in setups-not-run))  ~
      =/  message=tape
        ;:  weld
          "+make-setup will only run for virtualships that"
          " are set to sync. The following will not be run:"
          " {<setups-not-run>}. To have them run, add to"
          " +make-virtualships-to-sync in /zig/configs"
          "/{<desk-name>} and run %new-project again"
        ==
      :_  ~
      %-  update-vase-to-card
      (new-project-error(level %warning) (crip message))
    ::  use new-status rather than modifying status.state
    ::   in place to satisfy compiler
    =/  new-status=status:zig
      :-  %commit-install-starting
      (make-cis-running virtualships-to-sync desk-name)
    ?>  ?=(%commit-install-starting -.new-status)
    =*  cis-running  cis-running.new-status
    =.  cards
      %+  weld  cards
      %+  murn  virtualships-to-sync
      |=  who=@p
      ?~  setup=(~(get by setups) who)  ~
      =/  [cis-name=@t ?]  (~(got by cis-running) who)
      :-  ~
      %-  ~(poke-self pass:io /self-wire)
      :-  %ziggurat-action
      !>  ^-  action:zig
      :*  project-name
          desk-name
          `cis-name
          %queue-thread
          u.setup
      ==
    :: =.  cards
    ::   |-
    ::   ?~  virtualships-to-sync  cards
    ::   =*  who   i.virtualships-to-sync
    ::   =/  cis-cards=(list card)
    ::     :_  ~
    ::     %+  cis-thread
    ::       /cis-done/(scot %p who)/[project-name]/[desk-name]
    ::     [who desk-name install start-apps new-status]
    ::   %=  $
    ::       virtualships-to-sync  t.virtualships-to-sync
    ::       cards                 (weld cards cis-cards)
    ::   ==
    =.  cards
      :_  cards
      %-  fact:io  :_  ~[/project]
      :-  %json
      !>  ^-  json
      %-  update:enjs
      !<  update:zig
      %.  state-views
      %~  state-views  make-update-vase
      [project-name desk-name %load-configuration-file ~]
    :-  :_  cards
        %-  update-vase-to-card
        %.  new-status
        %~  status  make-update-vase
        [project-name desk-name %load-configuration-file ~]
    =.  projects.state
      %+  ~(put by projects.state)  project-name
      =/  =project:zig
        %+  ~(gut by projects.state)  project-name
        *project:zig
      project(pyro-ships virtualships-to-sync)
    =.  projects.state
      =/  project=(unit project:zig)
        (~(get by projects.state) focused-project.state)
      ?~  project  projects.state
      %+  ~(put by projects.state)  focused-project.state
      u.project(saved-thread-queue thread-queue.state)
    %=  state
        thread-queue   ~
        status         new-status
    ::
        sync-desk-to-vship
      %-  ~(gas ju sync-desk-to-vship.state)
      %+  turn  virtualships-to-sync
      |=(who=@p [desk-name who])
    ::
        configs
      %+  ~(put by configs.state)  project-name
      %.  ~(tap by config)
      ~(gas by (~(gut by configs.state) project-name ~))
    ==
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
    |=  queue=(qeu [@t @tas path])
    ^-  vase
    !>  ^-  update:zig
    [%thread-queue update-info [%& queue] ~]
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
    ?-    -.status
        %running-thread  [%s -.status]
        %ready           [%s -.status]
        %uninitialized   [%s -.status]
        %commit-install-starting
      %-  pairs
      %+  turn  ~(tap by cis-running.status)
      |=  [who=@p cis-done=@t is-done=?]
      :-  (scot %p who)
      %-  pairs
      :+  [%cis-done %s cis-done]
        [%is-done %b is-done]
      ~
    ::
        %changing-project-desks
      %-  pairs
      %+  turn  ~(tap by project-cis-running.status)
      |=  [desk-name=@tas cis-running=(map @p [@t ?])]
      :-  desk-name
      %-  pairs
      %+  turn  ~(tap by cis-running)
      |=  [who=@p cis-done=@t is-done=?]
      :-  (scot %p who)
      %-  pairs
      :+  [%cis-done %s cis-done]
        [%is-done %b is-done]
      ~
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
        ['saved_thread_queue' (thread-queue saved-thread-queue.p)]
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
    |=  thread-queue=(qeu [@t @tas ^path])
    ^-  json
    :-  %a
    %+  turn  ~(tap to thread-queue)
    |=  [project-name=@t desk-name=@tas p=^path]
    %-  pairs
    :^    [%project-name %s project-name]
        [%desk-name %s desk-name]
      [%thread-path (path p)]
    ~
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
    :~  [%new-project (ot ~[[%sync-ships (ar (se %p))] [%fetch-data-from-remote-ship (se-soft %p)]])]
        [%delete-project ul]
        [%save-config-to-file ul]
    ::
        [%add-sync-desk-vships add-sync-desk-vships]
        [%delete-sync-desk-vships (ot ~[[%ships (ar (se %p))]])]
    ::
        [%change-focus ul]
        [%add-project-desk ni:dejs-soft:format]
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
--
