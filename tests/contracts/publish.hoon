::
::  Tests for publish.hoon
::
/-  zink
/+  *test, smart=zig-sys-smart, *sequencer, merk
/*  smart-lib-noun    %noun  /lib/zig/sys/smart-lib/noun
/*  zink-cax-noun     %noun  /lib/zig/sys/hash-cache/noun
/*  publish-contract  %noun  /con/compiled/publish/noun
|%
::
::  constants / dummy info for mill
::
++  big  (bi:merk id:smart item:smart)  ::  merkle engine for granary
++  pig  (bi:merk id:smart @ud)          ::                for populace
++  town-id   0x0
++  fake-sig  [0 0 0]
++  mil
  %~  mill  mill
  :+    ;;(vase (cue +.+:;;([* * @] smart-lib-noun)))
    ;;((map * @) (cue +.+:;;([* * @] zink-cax-noun)))
  %.y
::
+$  single-result
  [fee=@ud =land burned=granary =errorcode:smart hits=(list hints:zink) =crow:smart]
::
::  fake data
::
++  miller  ^-  caller:smart
  [0x24c.23b9.8535.cd5a.0645.5486.69fb.afbf.095e.fcc0 1 0x0]  ::  zigs account not used
++  holder-1  0xd387.95ec.b77f.b88e.c577.6c20.d470.d13c.8d53.2169
++  holder-2  0xface.face.face.face.face.face.face.face.face.face
++  caller-1  ^-  caller:smart  [holder-1 1 (make-id:zigs holder-1)]
++  caller-2  ^-  caller:smart  [holder-2 1 (make-id:zigs holder-2)]
::
++  zigs
  |%
  ++  make-id
    |=  holder=id:smart
    (fry-data:smart zigs-contract-id:smart holder town-id `@`'zigs')
  ++  make-account
    |=  [holder=id:smart amt=@ud]
    ^-  item:smart
    :*  %&  `@`'zigs'  %account
        [amt ~ `@ux`'zigs-metadata-id']
        (make-id holder)
        zigs-contract-id:smart
        holder
        town-id
    ==
  --
::
++  trivial-nok  ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 0] [1 1 0 0 0 0 0] 0 1] 0 1] pay=[1 0]]
++  immutable-nok   ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 1.684.957.542 0] [1 8 [8 [9 22 0 62] 9 2 10 [6 0 29] 0 2] 6 [5 [1 0] 0 2] [11 [1.735.355.507 [1 0] [1 1.717.658.988] 7 [0 1] 8 [1 1 103 114 97 105 110 32 110 111 116 32 102 111 117 110 100 0] 9 2 0 1] 1 0 0 0 0 0] 11 [1.735.355.507 [1 0] [1 1.717.658.988] 7 [0 1] 8 [1 1 103 114 97 105 110 32 108 111 99 97 116 101 100 0] 9 2 0 1] [1 0] [1 0] [1 0] [1 0] [[1 2.036.573.977.734.092.974.463.363.948.310.374] [1 110] 8 [9 6.108 0 4.063] 9 2 10 [6 [7 [0 3] 1 30.837] 0 446] 0 2] 1 0] 0 1] 0 1] pay=[1 0]]
++  trivial-nok-upgrade  ^-  [bat=* pay=*]
  [bat=[8 [1 0 [0 0] 0 0] [1 [8 [1 0] [1 [1 0] 1 0] 0 1] 8 [1 0] [1 8 [8 [9 2.398 0 16.127] 9 2 10 [6 7 [0 3] 1 100] 0 2] 1 0 0 0 0 0] 0 1] 0 1] pay=[1 0]]
::
++  upgradable-id
  (fry-pact:smart id.p:publish-wheat id:caller-1 town-id `trivial-nok)
++  upgradable
  ^-  item:smart
  :*  %|
        `trivial-nok
        ~
        ~
        upgradable-id
        id.p:publish-wheat
        id:caller-1
        town-id
  ==
::
++  immutable-id
  (fry-pact:smart 0x0 id:caller-1 town-id `immutable-nok)
++  immutable
  ^-  item:smart
  :*  %|
      `immutable-nok
      ~
      ~
      immutable-id
      0x0
      id:caller-1
      town-id
  ==
::
++  publish-wheat
  ^-  item:smart
  =/  cont  ;;([bat=* pay=*] (cue +.+:;;([* * @] publish-contract)))
  :*  %|
      `cont
      interface=~
      types=~
      0xdada.dada  ::  id
      0xdada.dada  ::  lord
      0xdada.dada  ::  holder
      town-id
  ==
::
++  fake-granary
  ^-  granary
  %+  gas:big  *(merk:merk id:smart item:smart)
  %+  turn
    :~  publish-wheat
        upgradable
        immutable
        (make-account:zigs holder-1 300.000.000)
        (make-account:zigs holder-2 300.000.000)
    ==
  |=(=item:smart [id.p.grain grain])
++  fake-populace
  ^-  populace
  %+  gas:pig  *(merk:merk id:smart @ud)
  ~[[holder-1 0] [holder-2 0]]
++  fake-land
  ^-  land
  [fake-granary fake-populace]
::
::  begin tests
::
++  test-deploy
  =/  =calldata:smart  [%deploy %.y trivial-nok ~ ~]
  =/  shel=shell:smart
    [caller-1 ~ id.p:publish-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      [(del:big fake-granary upgradable-id) fake-populace]
    `transaction:smart`[fake-sig shel yolk]
  ::
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
  ::  assert new contract grain was created properly
    (expect-eq !>(upgradable) !>((got:big p.land.res upgradable-id)))
  ==
::
++  test-deploy-immutable
  =/  =calldata:smart  [%deploy %.n immutable-nok ~ ~]
  =/  shel=shell:smart
    [caller-1 ~ id.p:publish-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      [(del:big fake-granary immutable-id) fake-populace]
    `transaction:smart`[fake-sig shel yolk]
  ::
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
  ::  assert new contract grain was created properly
    (expect-eq !>(immutable) !>((got:big p.land.res immutable-id)))
  ==
::
++  test-upgrade
  =/  =calldata:smart  [%upgrade upgradable-id trivial-nok-upgrade]
  =/  shel=shell:smart
    [caller-1 ~ id.p:publish-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::
  =/  new-wheat
    ^-  item:smart
    :*  %|
        `trivial-nok-upgrade
        ~
        ~
        upgradable-id
        id.p:publish-wheat
        id:caller-1
        town-id
    ==
  ;:  weld
  ::  assert that our call went through
    (expect-eq !>(%0) !>(errorcode.res))
  ::  assert new contract grain was created properly
    (expect-eq !>(new-wheat) !>((got:big p.land.res upgradable-id)))
  ==
::
++  test-upgrade-immutable
  =/  =calldata:smart  [%upgrade immutable-id trivial-nok-upgrade]
  =/  shel=shell:smart
    [caller-1 ~ id.p:publish-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::  assert that our call failed
  (expect-eq !>(%6) !>(errorcode.res))
::
++  test-upgrade-not-holder
  =/  =calldata:smart  [%upgrade immutable-id trivial-nok-upgrade]
  =/  shel=shell:smart
    [caller-2 ~ id.p:publish-wheat 1 1.000.000 town-id 0]
  =/  res=single-result
    %+  ~(mill mil miller town-id 1)
      fake-land
    `transaction:smart`[fake-sig shel yolk]
  ::  assert that our call failed
  (expect-eq !>(%6) !>(errorcode.res))
--
