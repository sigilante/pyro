# `%dev-suite` Documentation

The `%dev-suite` is comprised of `%pyro`, a ship virtualizer; `%pyre`, a virtual runtime; and `%ziggurat`, the backend for an [IDE](https://github.com/uqbar-dao/ziggurat-ui) that uses `%pyro` and `%pyre` as a foundation.

## [`%pyro` Contents](#pyro-documentation)
* [`%pyro` Quick Start](#pyro-quick-start)
* [`%pyro` Architecture](#pyro-architecture)
* [`%pyro` Inputs](#pyro-inputs)
* [`%pyro` Outputs](#pyro-outputs)
* [`%pyro` Threads](#pyro-threads)

## [`%ziggurat` Contents](#ziggurat-documentation)
* [Broad overview](#broad-overview)
* [Initial installation](#initial-installation)
* [Example usage](#example-usage)
* [Projects and desks](#project-and-desks)
* [Using threads for setup and testing](#using-threads-for-setup-and-testing)
* [Deploying contracts](#deploying-contracts)
* [Project configuration](#project-configuration)

# `%pyro` Documentation
Last updated as of Feb 07, 2023.

## `%pyro` Quick Start
```
:pyro|init ~nec                     :: initialize fake ~nec
:pyro|init ~bud                     :: initialize fake ~bud
:pyro|commit ~nec %foo              :: copy host desk %foo into ~nec
:pyro|dojo ~nec "|install our %foo" :: install %foo desk into ~nec
:pyro|dojo ~nec "=bar 5"            :: run a dojo command
:pyro|snap /baz ~[~nec ~bud]        :: take a snapshot of ~nec and ~bud named /baz
:pyro|restore /baz                  :: restore ~nec and ~bud to /baz state
:pyro|pause ~nec                    :: stop processing events for ~nec
:pyro|unpause ~nec                  :: resume processing events for ~nec
:pyro|kill ~nec                     :: remove ~nec and all it's state
:pyro|pass ~nec ...                 :: same as |pass - for experts only!
```

## `%pyro` Architecture
`%pyro` simulates individual ships, handles their state, their I/O, and snapshots

`%pyre` is the virtual runtime for %pyro ships. It handles ames sends, behn timers, iris requests, eyre responses, and dojo outputs. Not all runtime functionality is implemented - just the most important pieces.

## `%pyro` inputs
Just like a normal ship, the only interface for interacting with a `%pyro` ship is to pass it `$task-arvo`s. Using raw `$task`s requires a good knowledge of `lull.hoon`, so the most common I/O is implemented in `/lib/pyro/pyro.hoon` and `/gen/pyro/` for your convenience.

## `%pyro` outputs
###  Effects
All `$unix-effect`s can be subscribed to by an app or thread. However, `%pyre` automatically handles the most important `$unix-effects` for you. Handling unix effects by yourself in an app/thread requires a good knowledge of `lull.hoon` - to look for a specific output, look at each vane's `$gift`s.

### Scries
You can scry into a `%pyro` ship. Anthing that you can scry out of a normal ship, you can scry out of a `%pyro` ship.
```hoon
.^(wain %gx /=pyro=/i/~nec/cx/~nec/zig/(scot %da now)/desk/bill/bill)
```
Note:
1. All scries into `%pyro` ships must have a double mark at the end (e.g. `/noun/noun`, `/bill/bill`, etc.)
2. The `%pyro` ship and the [care](https://developers.urbit.org/reference/arvo/concepts/scry) must be specified at the start of the path.

There is also a convenience scry for `%gx` cares into agents running on `%pyro` ships:
```hoon
.^(mold %gx /=pyro=/~nec/myapp/my/path/goes/here/mark/mark)
```

## `%pyro` Threads
`%pyro` tests are meant to be written as threads. Common functions for using threads live in `/lib/pyro/pyro.hoon`
```
;<  ~  bind:m  (reset-ship:pyro ~nec)
;<  ~  bind:m  (reset-ship:pyro ~bud)
;<  ~  bind:m  (commit:pyro ~[~nec ~bud] our %base now)
;<  ~  bind:m  (snap:pyro /my-snapshot ~[~nec~bud]) :: TODO this isn't written
;<  ~  bind:m  (dojo:pyro ~nec "(add 2 2)")
;<  ~  bind:m  (wait-for-output:pyro ~nec "4")
;<  ~  bind:m  (poke:pyro ~nec ~bud %dap %mar !>(%payload))
;<  ~  bind:m  (restore:pyro /my-snapshot) :: TODO this isn't written
```

---

# `%ziggurat` documentation

The `%ziggurat` dev suite is built on top of the `%pyro` ship virtualizer and is the backend for the [Ziggurat IDE](https://github.com/uqbar-dao/ziggurat-ui).

Last updated as of Apr 10, 2023.

## Broad overview

`%ziggurat` is the backend for the [Ziggurat IDE](https://github.com/uqbar-dao/ziggurat-ui).
`%pyro` is a ship virtualizer used to run a network of `%pyro` ships and used by `%ziggurat`.

`%pyro` is paired with `%pyre`, an app that plays the role of the runtime for `%pyro`.
For example, `%pyre` picks up ames packets sent from one `%pyro` ship and passes them to the recipient `%pyro` ship.

`%pyro` can snapshot and load `%pyro` ship state.

`%ziggurat` runs threads to put `%pyro` ships into specific states and test functionality of contracts and apps.
These threads can either be added by hand to `/zig/ziggurat/[thread-name]/hoon` or added via the `test-steps` UI.

`%ziggurat` is specifically designed to make smart contract and Gall agent development easy.
As such, `%ziggurat` is the premier development environment for integrated on- and off-chain computing.

##  Initial installation

### Fakeship installation

1. Set env vars pointing to repo-containing and ship-containing dirs.
   ```bash
   export REPO_DIR=~/git
   export SHIP_DIR=~/urbit
   ```
2. Create a fake `~zod`.
   ```bash
   cd $SHIP_DIR
   ./vere -F zod
   ```
3. Clone the official Urbit repository and add required repositories, including this one, as submodules.
   This structure is necessary to resolve symbolic links to other desks like `base-dev` and `garden-dev`.
   ```bash
   cd $REPO_DIR
   git clone https://github.com/urbit/urbit.git
   cd ${REPO_DIR}/urbit/pkg

   git submodule add git@github.com:uqbar-dao/dev-suite.git
   git submodule add git@github.com:uqbar-dao/uqbar-core.git
   git submodule add git@github.com:uqbar-dao/zig-dev.git
   ```
3.5. Set submodules to proper branches -- only required while WIP.
     ```bash
     cd uqbar-core
     git checkout hf/ziggurat-cleanup
     cd ..
     cd dev-suite
     git checkout next/suite
     cd ..
     ```
4. On the fake `~zod`, create and mount appropriate desks.
   ```hoon
   |new-desk %suite
   |new-desk %zig
   |new-desk %zig-dev
   |mount %suite
   |mount %zig
   |mount %zig-dev
   ```
5. Copy submodule contents into the appropriate desks.
   ```bash
   rm -rf ${SHIP_DIR}/nec/suite/* && cp -RL ${REPO_DIR}/urbit/pkg/dev-suite ${SHIP_DIR}/nec/suite
   rm -rf ${SHIP_DIR}/nec/zig/* && cp -RL ${REPO_DIR}/urbit/pkg/uqbar-core ${SHIP_DIR}/nec/zig
   rm -rf ${SHIP_DIR}/nec/zig-dev/* && cp -RL ${REPO_DIR}/urbit/pkg/zig-dev ${SHIP_DIR}/nec/zig-dev
   ```
6. On the fake `~zod`, commit the files.
   ```hoon
   |commit %suite
   |commit %zig
   |commit %zig-dev
   ```
7. Install `%suite`.
   As a part of installation, `%pyro` will start three virtualized ships (`~nec`, `~bud`, and `~wes`) and the `%zig-dev` project will be initialized, installing the `%zig` desk on each `%pyro` ship and starting a testnet, hosted by `~nec`, the same as if these instructions had been followed: https://github.com/uqbar-dao/uqbar-core#starting-a-fakeship-testnet
   ```hoon
   |install our %suite
   ```

### Liveship installation

Coming soon.

## Example usage

### Import %pokur, set up a table, and join it

As a more real-world example, import the %pokur-dev project.

Similar to in the [installation instructions](#fakeship-installation) above, add the pokur-dev repo as a submodule, and get the files into the %pokur-dev desk:
```
#  In terminal
cd ${REPO_DIR}/urbit/pkg
git submodule add git@github.com:uqbar-dao/pokur-dev.git

::  On ship
|new-desk %pokur-dev

#  In terminal
rm -rf ${SHIP_DIR}/nec/pokur-dev && cp -RL ${REPO_DIR}/urbit/pkg/pokur-dev

::  On ship
|commit %pokur-dev
```

Then, adding %pokur-dev using %new-project will create a new project and run the [pokur-dev configuration file](https://github.com/uqbar-dao/pokur-dev/blob/master/zig/configuration/pokur-dev.hoon).

```hoon
:ziggurat &ziggurat-action [%pokur-dev %pokur-dev ~ %new-project ~ !>(~)]
```

The project will have a functional testnet with the escrow contract deployed, with `~nec` as the pokur-host and `~bud` leading a table.

Also included in the %pokur-dev project is a thread that causes `~wes` to join `~bud`s table.
It can be run as follows:
```hoon
::  Examine state of %pokur app running on ~bud: note the table hosted by ~nec and led by ~bud
:pyro|dojo ~bud ":pokur +dbug"

:ziggurat &ziggurat-action [%pokur-dev %pokur-dev ~ %queue-thread %ziggurat-wes-join-table %fard !>(~)]
:ziggurat &ziggurat-action [%pokur-dev %pokur-dev ~ %run-queue ~]

::  Examine state of %pokur app running on ~bud: note the table hosted by ~nec and led by ~bud now has ~wes as a player
:pyro|dojo ~bud ":pokur +dbug"
```

Some other stuff you may want to do:

```hoon
::  Snapshot at any given state to be able to restore to it later:
::   (The `/my-state/0` is an arbitrary `path` that is a label).
:pyro|snap /my-state/0 ~[~nec ~bud ~wes]

::  Restore to a snapshot:
:pyro|restore /my-state/0
```

### `update:zig`

Many pokes will result in an error or change in state that frontends or other apps need to know about.
`%ziggurat` returns `update`s that specify the changed state or the error that occurred.
Frontends or apps should subscribe to `/project/[project-name]` to receive these `update`s.

In addition, scries will also often return `update:zig`.

`update:zig` takes the form of:
* A tag, indicating the action or scry that triggered the update or the piece of state that changed,
* `update-info:zig`, which itself contains metadata about the state/triggering action:
  * `project-name`,
  * `desk-name`,
  * `source`: where did this `update` or error originate from?
  * `request-id`: pokes may include a `(unit @t)`, an optional `request-id` to make finding the resulting update easier; if a poke caused this `update`, and it included a `request-id`, it is copied here.
* `payload`: a piece of data or an error.
  If the `update` is reporting a success this may contain data about the updated state.
  If the `update` is reporting a failure, this includes a:
  * `level`: like a logging level (info, warning, error): how severe was this failure,
  * `message`: an description of the error.
* other optional metadata that should be reported whether a success or a failure.

## Projects and desks

`%ziggurat` projects are sets of desks that maintain state amongst them.
For example, the `%pokur-dev` project comes with the `%zig` desk to run an Uqbar testnet and the `%pokur` desk to run the pokur contracts (specifically escrow) and apps (specifically %pokur and %pokur-host).

A project can be started from scratch using the IDE.

Projects can also be imported.

Imported projects may optionally have a configuration thread.
See [project configuration](#project-configuration) for further discussion.

## Using threads for setup and testing

Aside from running the initial configuration thread when importing a project, threads are used to put `%pyro` ships into specific, consistent states and to run tests.
The [ziggurat threads lib](https://github.com/uqbar-dao/dev-suite/blob/master/lib/zig/ziggurat/threads.hoon) is provided to make manipulation of and testing with `%pyro` ships easier.
Some examples of threads used for testing actions coordinating multiple ships are `%zig-dev`s [`send-bud`](https://github.com/uqbar-dao/zig-dev/blob/master/ted/ziggurat/send-bud.hoon) and `%pokur-dev`s [`wes-join-table`](https://github.com/uqbar-dao/pokur-dev/blob/master/ted/ziggurat/wes-join-table.hoon).

Threads can either be written directly or created through the IDE UI, in which case they are presented in a simplified form, "test steps".

### Test steps

`test-steps` are sequences of `test-step`s.
A `test-step` can be a `%poke`,`%scry`, `%wait`, or `%dojo`.
`%poke` and `%scry` are pretty self-explanatory; `%wait` pauses for the given `@dr`.
`%dojo` executes the given string in the Dojo of the given `%pyro` ship.

`test-steps` are compiled to a thread and run in the same way hand-written threads are.

## Deploying contracts

Contracts can be deployed to the `%pyro` ship testnet for a project using the `%deploy-contract` poke:
```hoon
:ziggurat &ziggurat-action [%foo ~ %deploy-contract town-id=0x0 /con/compiled/nft/jam]
```

## Project configuration

Projects can be configured so that they are in a predictable state when imported.
Configuration is accomplished by a `hoon` file that lives at `/zig/configuration/[project-name]/hoon`, and it must have a `$`-arm that returns a `form:m`.
That `$`-arm is run when the project is installed.
For examples, see the [zig-dev configuration file](https://github.com/uqbar-dao/zig-dev/blob/master/zig/configuration/zig-dev.hoon) and the [pokur-dev configuration file](https://github.com/uqbar-dao/pokur-dev/blob/master/zig/configuration/pokur-dev.hoon).

### State views

Access the state of apps that import the dbug library running on `%pyro` ships using state views in the IDE UI.
Projects can be configured to come pre-loaded with state views.
State view files live in either `/zig/state-views/agent` or `/zig/state-views/chain` -- which retrieve data from Gall apps or the Uqbar chain respectively.
State view files contain Hoon that is directly analogous to Hoon that would be input to the `+dbug` generator.
For example,
```hoon
::  Get entire %ziggurat state.
:ziggurat +dbug [%state '-']

::  Get %zig-dev project from within %ziggurat state.
:ziggurat +dbug [%state '(~(get by projects) %zig-dev)']
```

To load pre-defined state views at import-time, `/zig/state-views/[project-name]/hoon` must exist.
For examples of that file format, see [zig-dev](https://github.com/uqbar-dao/zig-dev/blob/master/zig/state-views/zig-dev.hoon) and [pokur-dev](https://github.com/uqbar-dao/pokur-dev/blob/master/zig/state-views/pokur-dev.hoon).
