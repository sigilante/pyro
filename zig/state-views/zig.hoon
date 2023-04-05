^-  (list [who=@p app=(unit @tas) file=path])
::  app=~ -> chain view, not an agent view
=/  pfix  (cury welp `path`/zig/state-views)
:~  [~nec ~ (pfix /chain/transactions/hoon)]
    [~nec ~ (pfix /chain/chain/hoon)]
    [~nec ~ (pfix /chain/holder-our/hoon)]
    [~nec ~ (pfix /chain/source-zigs/hoon)]
::
    [~nec `%wallet (pfix /agent/wallet-metadata-store/hoon)]
    [~nec `%wallet (pfix /agent/wallet-our-items/hoon)]
==
