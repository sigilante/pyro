/=  wal  /sur/zig/wallet
::
/=  mip  /lib/mip
::
::  get our held items
^-  book:wal
=*  who-address=@ux
  (~(got bi:mip configs) [%global [who %address]])
(~(got by tokens) who-address)
