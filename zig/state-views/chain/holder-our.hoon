/=  mip    /lib/mip
/=  smart  /lib/zig/sys/smart
::
::  get all our held items
^-  (map @ux item:smart)
=*  who-address=@ux
  (~(got bi:mip configs) [%global [who %address]])
%-  ~(gas by *(map @ux item:smart))
%+  murn  ~(tap by p:chain:(~(got by -) 0x0))
|=  [id=@ux @ =item:smart]
?.  =(who-address holder.p.item)  ~
`[id item]
