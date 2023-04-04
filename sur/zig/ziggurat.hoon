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
  $%  [%running-thread ~]
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
  $:  name=@tas
      dir=(list path)
      user-files=(set path)
      to-compile=(set path)
      :: =tests
      threads=(set @tas)
      saved-test-steps=(map thread-name=@tas [test-imports=imports =test-steps])
      special-configuration-args=vase
  ==
::
+$  build-result  (each [bat=* pay=*] @t)
::
+$  configs  (mip:mip project-name=@t [who=@p what=@tas] @)
+$  config   (map [who=@p what=@tas] @)
::
+$  sync-desk-to-vship  (jug @tas @p)
::
+$  imports  (map @tas path)
::
+$  test-steps  (list test-step)
+$  test-step
  $%  [%scry payload=scry-payload expected=@t]
      [%wait until=@dr]
      [%dojo payload=dojo-payload]
      [%poke payload=poke-payload]
  ==
+$  scry-payload
  [who=@p mold-name=@t care=@tas app=@tas =path]
+$  dojo-payload  [who=@p payload=@t]
+$  poke-payload  [who=@p to=@p app=@tas mark=@tas payload=vase]
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
::
+$  template  ?(%fungible %nft %blank)
::
+$  deploy-location  ?(%local testnet)
+$  testnet  ship
::
+$  state-views
  (list [who=@p app=(unit @tas) file=path])
::
+$  action
  $:  project-name=@t
      desk-name=@tas
      request-id=(unit @t)
      $%  [%new-project sync-ships=(list @p) fetch-desk-from-remote-ship=(unit @p) special-configuration-args=vase]
          [%delete-project ~]
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
          [%register-for-compilation file=path]
          [%unregister-for-compilation file=path]
          [%deploy-contract who=(unit @p) town-id=@ux contract-jam-path=path]
      ::
          [%compile-contracts ~]
          [%compile-contract =path]  ::  path of form /con/foo/hoon within given desk
          [%compile-non-contract =path]
          [%read-desk ~]
      ::
          [%queue-thread thread-name=@tas payload=thread-queue-payload]
          [%save-thread thread-name=@tas test-imports=imports =test-steps] :: TODO; take in test-steps(?) and convert to thread
          [%delete-thread thread-name=@tas] :: TODO; take in test-steps(?) and convert to thread
          [%run-queue ~]
          [%clear-queue ~]
      ::
          [%stop-pyro-ships ~]
          [%start-pyro-ships ships=(list @p)]  ::  ships=~ -> ~[~nec ~bud ~wes]
      ::
          [%take-snapshot update-project-snaps=(unit path)]  ::  ~ -> overwrite project snap
      ::
          [%publish-app title=@t info=@t color=@ux image=@t version=[@ud @ud @ud] website=@t license=@t]
      ::
          [%add-user-file file=path]
          [%delete-user-file file=path]
      ::
          [%pyro-agent-state who=@p app=@tas =imports grab=@t]
          [%pyro-chain-state =imports grab=@t]
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
      %queue-thread
      %compile-contract
      %run-queue
      %add-user-file
      %delete-user-file
      %dir
      %poke
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
      %build-result
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
      [%queue-thread update-info payload=(data @tas) ~]
      [%compile-contract update-info payload=(data ~) ~]
      [%run-queue update-info payload=(data ~) ~]
      [%add-user-file update-info payload=(data ~) file=path]
      [%delete-user-file update-info payload=(data ~) file=path]
      [%dir update-info payload=(data (list path)) ~]
      [%poke update-info payload=(data ~) ~]
      [%thread-queue update-info payload=(data shown-thread-queue) ~]
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
      [%build-result update-info payload=(data ~) ~]
  ==
--
