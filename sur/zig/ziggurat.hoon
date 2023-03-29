/-  docket,
    engine=zig-engine,
    ui=zig-indexer,
    wallet=zig-wallet,
    zink=zig-zink
/+  engine-lib=zig-sys-engine,
    mip,
    smart=zig-sys-smart
|%
+$  state-0
  $:  %0
      =projects
      =configs
      =sync-desk-to-vship
      focused-project=@t
      :: test-queue=(qeu [project-name=@t desk-name=@tas test-id=@ux])
      =thread-queue
      =status
      =settings
  ==
+$  inflated-state-0
  $:  state-0
      =eng
      smart-lib-vase=vase
      =ca-scry-cache
  ==
+$  ca-scry-cache  (map [@tas path] (pair @ux vase))
+$  eng  $_  ~(engine engine-lib !>(0) *(map * @) jets:zink %.y %.n)  ::  sigs off, hints off
::
+$  thread-queue
  (qeu thread-queue-item)
+$  thread-queue-item
  $:  project-name=@t
      desk-name=@tas
      thread-name=@tas
      payload=thread-queue-payload
      :: thread-name=@tas
      :: thread-args=vase
  ==
+$  thread-queue-payload
  $%  [%fard args=vase]
      [%lard =shed:khan]
  ==
+$  shown-thread-queue
  (qeu shown-thread-queue-item)
+$  shown-thread-queue-item
  $:  project-name=@t
      desk-name=@tas
      thread-name=@tas
      thread=$%([%fard args=@t] [%lard ~])
      :: thread-name=@tas
      :: thread-args=@t
  ==
+$  shown-thread-queue-payload
  $%  [%fard args=@t]
      [%lard ~]
  ==
::
+$  settings
  $:  test-result-num-characters=@ud
      state-num-characters=@ud
      compiler-error-num-lines=@ud
      code-max-characters=@ud
  ==
::
+$  status
  :: $%  [%running-test-steps ~]
  $%  [%running-thread ~]
      [%commit-install-starting cis-running=(map @p [@t ?])]
      [%changing-project-desks project-cis-running=(mip:mip @tas @p [@t ?])]
      [%ready ~]
      [%uninitialized ~]  ::  last is default
  ==
::
+$  projects  (map @t project)
+$  project
  $:  desks=(list (pair @tas desk))
      pyro-ships=(list @p)
      most-recent-snap=path
      :: saved-test-queue=(qeu [project-name=@t desk-name=@tas test-id=@ux])
      saved-thread-queue=thread-queue
  ==
+$  desk
  $:  dir=(list path)
      user-files=(set path)
      to-compile=(set path)
      :: =tests
      threads=(set path)
      special-configuration-args=vase
  ==
::
+$  build-result  (each [bat=* pay=*] @t)
::
:: +$  tests  (map @ux test)
:: +$  test
::   $:  name=(unit @t)  ::  optional
::       test-steps-file=path
::       =test-imports
::       subject=(each vase @t)
::       =custom-step-definitions
::       steps=test-steps
::       results=test-results
::   ==
::
+$  configs  (mip:mip project-name=@t [who=@p what=@tas] @)
+$  config   (map [who=@p what=@tas] @)
::
+$  sync-desk-to-vship  (jug @tas @p)
::
+$  imports  (map @tas path)
:: ::
:: +$  expected-diff
::   (map id:smart [made=(unit item:smart) expected=(unit item:smart) match=(unit ?)])
:: ::
:: +$  test-imports  (map @tas path)
:: ::
:: +$  test-steps  (list test-step)
:: +$  test-step  $%(test-read-step test-write-step)
:: +$  test-read-step
::   $%  [%scry =result-face payload=scry-payload expected=@t]
::       [%read-subscription =result-face payload=read-sub-payload expected=@t]
::       [%wait until=@dr]
::       [%custom-read tag=@tas =result-face payload=@t expected=@t]
::   ==
:: +$  test-write-step
::   $%  [%dojo =result-face payload=dojo-payload expected=(list test-read-step)]
::       [%poke =result-face payload=poke-payload expected=(list test-read-step)]
::       [%subscribe =result-face payload=sub-payload expected=(list test-read-step)]
::       [%custom-write tag=@tas =result-face payload=@t expected=(list test-read-step)]
::   ==
:: +$  scry-payload
::   [who=@p mold-name=@t care=@tas app=@tas path=@t]
:: +$  read-sub-payload  [who=@p to=@p app=@tas =path]
:: +$  dojo-payload  [who=@p payload=@t]
:: +$  poke-payload  [who=@p to=@p app=@tas mark=@tas payload=@t]
:: +$  sub-payload  [who=@p to=@p app=@tas =path]
:: ::
:: +$  result-face  (unit @tas)
:: ::
:: +$  custom-step-definitions
::   (map @tas (pair path custom-step-compiled))
:: +$  custom-step-compiled  (each transform=vase @t)
:: ::
:: +$  test-results  (list test-result)
:: +$  test-result   (list [success=? expected=@t result=vase])
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
+$  state-views
  (list [who=@p app=(unit @tas) file=path])
::
:: +$  configuration-file-output
::   $:  =config
::       ships=(list @p)
::       install=?
::       start=(list @tas)
::       =state-views
::       :: setup=(map @p test-steps)
::       :: imports=(list [@tas path])
::       setup=(map @p thread-path=path)
::   ==
:: ::
:: +$  test-globals
::   $:  our=@p
::       now=@da
::       =test-results
::       project-name=@t
::       desk-name=@tas
::       =configs
::   ==
::
+$  action
  $:  project-name=@t
      desk-name=@tas
      request-id=(unit @t)
      $%  [%new-project sync-ships=(list @p) fetch-desk-from-remote-ship=(unit @p) special-configuration-args=vase]
          [%delete-project ~]
          [%save-config-to-file ~]
      ::
          [%add-sync-desk-vships ships=(list @p) install=? start-apps=(list @tas)]
          [%delete-sync-desk-vships ships=(list @p)]
      ::
          [%send-state-views =state-views]
          [%set-ziggurat-state new-state=state-0]
          [%send-update =update]
      ::
          [%change-focus ~]
          [%add-project-desk index=(unit @ud) fetch-desk-from-remote-ship=(unit @p) special-configuration-args=vase]  ::  index=~ -> add to end
          [%delete-project-desk ~]
      ::
          [%save-file file=path text=@t]  ::  generates new file or overwrites existing
          [%delete-file file=path]
      ::
          [%add-config who=@p what=@tas item=@]
          [%delete-config who=@p what=@tas]
      ::
          [%register-contract-for-compilation file=path]
          [%unregister-contract-for-compilation file=path]
          [%deploy-contract town-id=@ux =path]
      ::
          [%compile-contracts ~]
          [%compile-contract =path]  ::  path of form /con/foo/hoon within project desk
          [%read-desk ~]
      ::
          [%queue-thread thread-name=@tas payload=thread-queue-payload]
          :: [%save-thread thread-path=path ] :: TODO; take in test-steps(?) and convert to thread
          :: [%edit-thread old=path new=path ] :: TODO: delete old, create new w/ %save-thread
      ::
      ::     [%add-test name=(unit @t) =test-imports =test-steps]
      ::     [%add-and-run-test name=(unit @t) =test-imports =test-steps]
      ::     [%add-and-queue-test name=(unit @t) =test-imports =test-steps]
      ::     [%save-test-to-file id=@ux =path]
      :: ::
      ::     [%add-test-file name=(unit @t) =path]
      ::     [%add-and-run-test-file name=(unit @t) =path]
      ::     [%add-and-queue-test-file name=(unit @t) =path]
      :: ::
      ::     [%edit-test id=@ux name=(unit @t) =test-imports =test-steps]
      ::     [%delete-test id=@ux]
      ::     [%run-test id=@ux]
          [%run-queue ~]
          [%clear-queue ~]
      ::     [%queue-test id=@ux]
      :: ::
      ::     [%add-custom-step test-id=@ux tag=@tas =path]
      ::     [%delete-custom-step test-id=@ux tag=@tas]
      ::
          [%stop-pyro-ships ~]
          [%start-pyro-ships ships=(list @p)]  ::  ships=~ -> ~[~nec ~bud ~wes]
          [%start-pyro-snap snap=path]
      ::
          [%take-snapshot update-project-snaps=(unit path)]  ::  ~ -> overwrite project snap
      ::
          [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::
          [%add-user-file file=path]
          [%delete-user-file file=path]
      ::
          [%send-pyro-dojo who=@p command=tape]
      ::
          [%pyro-agent-state who=@p app=@tas =imports grab=@t]
          [%pyro-chain-state =imports grab=@t]
      ::
          [%cis-panic ~]
      ::
          [%change-settings =settings]
      ::
          [%get-dev-desk who=@p]
          [%suspend-uninstall-to-make-dev-desk ~]
      ==
  ==
::
::  subscription update types
::
+$  update-tag
  $?  %focused-project
      %project-names
      %projects
      %project
      %new-project
      %add-config
      %delete-config
      :: %add-test
      :: %edit-test
      :: %delete-test
      %compile-contract
      %run-queue
      :: %add-custom-step
      :: %delete-custom-step
      %add-user-file
      %delete-user-file
      :: %custom-step-compiled
      :: %test-results
      %dir
      %poke
      :: %test-queue
      %thread-queue
      %shown-pyro-agent-state
      %pyro-chain-state
      %shown-pyro-chain-state
      %pyro-chain-state
      %sync-desk-to-vship
      %cis-setup-done
      %status
      %save-file
      %settings
      %state-views
      %add-project-desk
      %delete-project-desk
      %get-dev-desk
      %suspend-uninstall-to-make-dev-desk
      %ziggurat-state
      %configs
      %ship-to-address-map
  ==
+$  update-level  ?(%success error-level)
+$  error-level   ?(%info %warning %error)
+$  update-info
  $:  project-name=@t
      desk-name=@tas
      source=@tas
      request-id=(unit @t)
  ==
::
++  data  |$(this (each this [level=error-level message=@t]))
::
+$  update
  $@  ~
  $%  [%focused-project update-info payload=(data @t) ~]
      [%project-names update-info payload=(data ~) project-names=(set @t)]
      [%projects update-info payload=(data ~) =projects]
      [%project update-info payload=(data ~) =project]
      [%new-project update-info payload=(data =sync-desk-to-vship) ~]
      [%add-config update-info payload=(data [who=@p what=@tas item=@]) ~]
      [%delete-config update-info payload=(data [who=@p what=@tas]) ~]
      :: [%add-test update-info payload=(data shown-test) test-id=@ux]
      :: [%edit-test update-info payload=(data shown-test) test-id=@ux]
      :: [%delete-test update-info payload=(data ~) test-id=@ux]
      [%compile-contract update-info payload=(data ~) ~]
      [%run-queue update-info payload=(data ~) ~]
      :: [%add-custom-step update-info payload=(data ~) test-id=@ux tag=@tas]
      :: [%delete-custom-step update-info payload=(data ~) test-id=@ux tag=@tas]
      [%add-user-file update-info payload=(data ~) file=path]
      [%delete-user-file update-info payload=(data ~) file=path]
      :: [%custom-step-compiled update-info payload=(data ~) test-id=@ux tag=@tas]
      :: [%test-results update-info payload=(data shown-test-results) test-id=@ux thread-id=@t =test-steps]
      [%dir update-info payload=(data (list path)) ~]
      [%poke update-info payload=(data ~) ~]
      [%thread-queue update-info payload=(data shown-thread-queue) ~]
      :: [%test-queue update-info payload=(data (qeu [@t @tas @ux])) ~]
      [%pyro-agent-state update-info payload=(data [agent-state=vase wex=boat:gall sup=bitt:gall]) ~]
      [%shown-pyro-agent-state update-info payload=(data [agent-state=@t wex=boat:gall sup=bitt:gall]) ~]
      [%pyro-chain-state update-info payload=(data (map @ux batch:ui)) ~]
      [%shown-pyro-chain-state update-info payload=(data @t) ~]
      [%sync-desk-to-vship update-info payload=(data sync-desk-to-vship) ~]
      [%cis-setup-done update-info payload=(data ~) ~]
      [%status update-info payload=(data status) ~]
      [%save-file update-info payload=(data path) ~]
      [%settings update-info payload=(data settings) ~]
      [%state-views update-info payload=(data (list [@p (unit @tas) path])) ~]
      [%add-project-desk update-info payload=(data ~) ~]
      [%delete-project-desk update-info payload=(data ~) ~]
      [%get-dev-desk update-info payload=(data ~) ~]
      [%suspend-uninstall-to-make-dev-desk update-info payload=(data ~) ~]
      [%ziggurat-state update-info payload=(data state-0) ~]
      [%configs update-info payload=(data configs) ~]
      [%ship-to-address-map update-info payload=(data (map @p @ux)) ~]
  ==
::
:: +$  shown-projects  (map @t shown-project)
:: +$  shown-project
::   $:  desks=(list (pair @tas shown-desk))
::       pyro-ships=(list @p)
::       most-recent-snap=path
::       saved-test-queue=(qeu [project-name=@t desk-name=@tas test-id=@ux])
::   ==
:: +$  shown-desk
::   $:  dir=(list path)
::       user-files=(set path)
::       to-compile=(set path)
::       tests=shown-tests
::   ==
:: +$  shown-tests  (map @ux shown-test)
:: +$  shown-test
::   $:  name=(unit @t)  ::  optional
::       test-steps-file=path
::       =test-imports
::       subject=(each vase @t)
::       =custom-step-definitions
::       steps=test-steps
::       results=shown-test-results
::       test-id=@ux
::   ==
:: +$  shown-test-results  (list shown-test-result)
:: +$  shown-test-result   (list [success=? expected=@t result=@t])
--
