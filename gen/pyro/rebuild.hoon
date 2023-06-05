::  Rebuild a desk in a pyro cache and insert into all running ships
::  Usage: :pyro|cache %my-cache ~[%desk-1 %desk-2 ...]
::
::  To boot a ship with this cache:
::    :pyro|init ~nec, =cache %my-cache
::
::  To update this cache after a commit to the host desk:
::    :pyro|rebuild %cax %desk-1
::
/+  pyro=pyro
:-  %say
|=  [[* * =beak] [name=@tas =desk ~] ~]
:-  %pyro-action
[%rebuild name (park:pyro p.beak desk r.beak)]