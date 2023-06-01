::  Usage: :pyro|cache %my-cache ~[%desk-1 %desk-2 ...]
::
::  To boot a ship with this cache:
::    :pyro|init ~nec, =cache %my-cache
::
::  To update this cache after a commit to the host desk:
::    :pyro|rebuild ~nec
::
:-  %say
|=  [* [name=@tas desks=(list desk) ~] ~]
:-  %pyro-action
[%cache name ~ desks]
