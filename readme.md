# `%pyro` Documentation

## [`%pyro` Contents](#pyro-documentation)
* [`%pyro` Quick Start](#pyro-quick-start)
* [`%pyro` Architecture](#pyro-architecture)
* [`%pyro` Inputs](#pyro-inputs)
* [`%pyro` Outputs](#pyro-outputs)
* [`%pyro` Threads](#pyro-threads)

# `%pyro` Documentation
Last updated as of June 05, 2023.

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
:pyro|cache %cax ~[%desk-1 %d2 ...] :: create a cache named %cax with %desk-1 and %d2 
```

## `%pyro` Workflow
### `:pyro|cache` : Quickly Initializing a ship with many desks
To quick boot many desks on a fake-ship, first make sure that the desks you want are installed on the host ship. For example, if we want to make a cache called `%cax` to quick boot `%desk-1`, `%desk-2` and `%desk-3`, those three desks *must* be installed on the host ship. Create the cache with this command:
```
:pyro|cache %cax ~[%desk-1 %desk-2 %desk-2]
```
To boot a ship with this cache:
```
:pyro|init ~nec, =cache %cax
```
And it will come preloaded with `%base`, `%desk-1`, `%desk-2`, and `%desk-3` - and boot *extremely* quickly.

### `:pyro|snap` : Taking Snapshots
Snapshots store the state of your fake ships so that you can return to them later
```
:pyro|snap /my/snaps/name ~[~nec ~bud ~wes ~rus]
```
To restore the snapshot:
```
:pyro|restore /my/snaps/name
```
NOTE: this will kill all running ships and restore *just* the ships in that snapshot - in this case, `~nec` `~bud` `~wes` and `~rus`

### Scries
You can scry into a `%pyro` ship. Anything that you can scry out of a normal ship, you can scry out of a `%pyro` ship.
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

### Remote Scry
Remote scry works on pyro ships!
```
:pyro|dojo ~nec "-keen [~bud /c/x/1/kids/ted/keen/hoon]"
```
NOTE: this feature has not been thoroughly tested - please message `~dachus-tiprel` with any errors

## `%pyro` Threads
`%pyro` tests are meant to be written as threads. Common functions for using threads live in `/lib/pyro/pyro.hoon`
NOTE: This documentation is outdated
```
;<  ~  bind:m  (init:pyro ~nec)
;<  ~  bind:m  (init:pyro ~bud)
;<  ~  bind:m  (commit:pyro ~[~nec ~bud] our %base now)
;<  ~  bind:m  (snap:pyro /my-snapshot ~[~nec~bud])
;<  ~  bind:m  (dojo:pyro ~nec "(add 2 2)")
;<  ~  bind:m  (poke:pyro ~nec ~bud %my-app %my-mark !>(%payload))
;<  ~  bind:m  (restore:pyro /my-snapshot) :: TODO this isn't written
```

# Architecture Documentation (Advanced)
`%pyro` simulates individual ships, handles their state, their I/O, and snapshots

`%pyre` is the virtual runtime for %pyro ships. It handles ames sends, behn timers, iris requests, eyre responses, and dojo outputs. Not all runtime functionality is implemented - just the most important pieces.

## `%pyro` inputs
Just like a normal ship, the only interface for interacting with a `%pyro` ship is to pass it `$task-arvo`s. Using raw `$task`s requires a good knowledge of `lull.hoon`, so the most common I/O is implemented in `/lib/pyro/pyro.hoon` and `/gen/pyro/` for your convenience.

## `%pyro` outputs
###  Effects
All `$unix-effect`s can be subscribed to by an app or thread. However, `%pyre` automatically handles the most important `$unix-effects` for you. Handling unix effects by yourself in an app/thread requires a good knowledge of `lull.hoon` - to look for a specific output, look at each vane's `$gift`s.
