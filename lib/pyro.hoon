/-  *pyro,
    spider
/+  *strandio,
    dill
::
=*  strand    strand:spider
::
|%
++  send-events
  |=  events=(list pyro-event)
  =/  m  (strand ,~)
  ^-  form:m
  (poke-our %pyro %pyro-events !>(events))
::
++  take-unix-effect
  =/  m  (strand ,[ship unix-effect])
  ^-  form:m
  ;<  [=path =cage]  bind:m  (take-fact-prefix /effect)
  ?>  ?=(%pyro-effect p.cage)
  (pure:m !<([pyro-effect] q.cage))
::
++  init-ship
  |=  who=ship
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %^  poke-our  %pyro  %pyro-action
    !>([%init-ship who %default])
  (pure:m ~)
::
++  init-ship-cache
  |=  [who=ship cache=@tas]
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %^  poke-our  %pyro  %pyro-action
    !>([%init-ship who cache])
  (pure:m ~)
::
++  ues-to-pe
  |=  [who=ship what=(list unix-event)]
  ^-  (list pyro-event)
  %+  turn  what
  |=  ue=unix-event
  [who ue]
::
++  ue-to-pes
  |=  [hers=(list ship) what=unix-event]
  ^-  (list pyro-event)
  %+  turn  hers
  |=  who=ship
  [who what]
::
++  dojo
  |=  [who=ship =tape]
  (send-events (dojo-events who tape))
::
++  dojo-events
  |=  [who=ship =tape]
  %+  ues-to-pe  who
  ^-  (list unix-event)
  :~  [/d/term/1 %belt %mod %ctl `@c`%e]
      [/d/term/1 %belt %mod %ctl `@c`%u]
      [/d/term/1 %belt %txt ((list @c) tape)]
      [/d/term/1 %belt %ret ~]
  ==
::
++  wait-for-output
  |=  [=ship =tape]
  =/  m  (strand ,~)
  ^-  form:m
  ~&  >  "waiting for output: {tape}"
  |-  ^-  form:m
  ;<  [her=^ship uf=unix-effect]  bind:m  take-unix-effect
  ?:  ?&  =(ship her)
          ?=(%blit -.q.uf)
        ::
          %+  lien  p.q.uf
          |=  =blit:dill
          ?.  ?=(%put -.blit)
            |
          !=(~ (find tape p.blit))
      ==
    (pure:m ~)
  $
::
++  poke
  |=  $:  from=@p
          to=@p
          app=@tas
          mark=@tas
          payload=*
      ==
  %-  send-events
  %+  ues-to-pe  from
  ^-  (list unix-event)
  :_  ~
  :*  /g
      %deal  [from to]  app
      %raw-poke  mark  payload
  ==
::
++  poke-self
  |=  $:  to=@p
          app=@tas
          mark=@tas
          payload=*
      ==
  %-  send-events
  %+  ues-to-pe  to
  ^-  (list unix-event)
  :_  ~
  :*  /g
      %deal  [to to]  app
      %raw-poke  mark  payload
  ==
::
++  task
  ::  TODO move to note-arvo?
  |=  [who=@p v=?(%a %b %c %d %e %g %i %j %k) =task-arvo]
  %-  send-events
  %+  ues-to-pe  who
  ^-  (list unix-event)
  [/[v] task-arvo]~ 
::
++  subscribe
  |=  [who=@p to=@p app=@tas =path]
  (poke who who %subscriber %subscriber-action [%sub to app path])
::
++  park
  |=  [our=ship =desk =case]
  ^-  $>(%park task:clay)
  ::
  =/  desk-path=path  /(scot %p our)/[desk]/(scot case)
  =/  =domo:clay  .^(domo:clay %cv desk-path)
  =*  tako=tako:clay  (~(got by hit.domo) let.domo)
  =*  path-to-lobe
    q:.^(yaki:clay %cs (weld desk-path /yaki/(scot %uv tako)))
  ::
  =*  yoki=yoki:clay
    :+  %&  *(list tako:clay)
    %-  ~(urn by path-to-lobe)
    |=([=path =lobe:clay] %|^lobe)
  =*  rang
    .^(rang:clay %cx /(scot %p our)//(scot case)/rang)
  ::
  [%park desk yoki rang]
::
++  commit
  |=  [hers=(list ship) our=ship =desk =case]
  %-  send-events
  %+  ue-to-pes  hers
  [/c/commit (park our desk case)]
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  =^update
    ^-  json
    ?~  update  ~
    ?-    -.update
        %snaps
      (frond -.update (fleets snap-paths.update))
    ::
        %ships
      (frond -.update (list-ships ships.update))
    ::
        %snap-ships
      (frond -.update (snap-ships [path ships]:update))
    ==
  ::
  ++  fleets
    |=  snap-paths=(list ^path)
    ^-  json
    (frond %snap-paths (list-paths snap-paths))
  ::
  ++  snap-ships
    |=  [p=^path ships=(list @p)]
    ^-  json
    %-  pairs
    :+  [%path (path p)]
      [%ships (list-ships ships)]
    ~
  ::
  ++  list-ships
    |=  ships=(list @p)
    ^-  json
    :-  %a
    %+  turn  ships
    |=(who=@p [%s (scot %p who)])
  ::
  ++  list-paths
    |=  paths=(list ^path)
    ^-  json
    :-  %a
    %+  turn  paths
    |=(p=^path (path p))
  ::
  ++  pyro-effect
    |=  [who=@p ufs=unix-effect]
    ^-  json
    ?+    -.q.ufs  ~  :: ignore non-%blit
        %blit
      %-  pairs
      :~  [%ship s+(scot %p who)]
        :-  %blits
        :-  %a
        %+  turn  `(list blit:dill)`p.q.ufs
        |=  b=blit:dill
        (blit:enjs:dill b)
      ==
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  [%init-ship (se %p)]
        [%kill-ships (ot ~[[%hers (se %p)]])]
        [%snap-ships (ot ~[[%path pa] [%hers (ar (se %p))]])]
        [%restore-snap (ot ~[[%path pa]])]
        [%delete-snap (ot ~[[%path pa]])]
        [%unpause-ships (ot ~[[%hers (ar (se %p))]])]
        [%pause-ships (ot ~[[%hers (ar (se %p))]])]
        [%wish (ot ~[[%hers (ar (se %p))] [%p so]])]
    ==
  --
--
