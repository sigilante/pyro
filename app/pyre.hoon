::  This agent simulates vere. This includes packet routing (ames),
::  unix timers (behn), terminal drivers (dill), and http requests/
::  responses (iris/eyre).
::
/-  *zig-pyro
/+  dbug, default-agent, pyre=pyro-pyre
::
%-  agent:dbug
^-  agent:gall
=<
|_  bowl=bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
    card  $+(card card:agent:gall)
++  on-init
  ^-  (quip card _this)
  :_  this
  [%pass /bind %arvo %e %connect `/pyro %pyre]~
::
++  on-save  on-save:def
++  on-load  on-load:def
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %handle-http-request
    =+  !<([rid=@tas req=inbound-request:^eyre] vase)
    =^  who=ship  url.request.req
      (parse-url:pyre (trip url.request.req))
    :_  this
    cards:(pass-request:(eyre:hc who) rid req)
  ::
      %pyro-effect
    =+  ef=!<([pyro-effect] vase)
    ?-    -.q.uf.ef
    ::  ames
        %send  [(send:ames:hc who.ef uf.ef) this]
    ::  behn
        %doze
      =^  cards  behn-piers
        abet:(doze:(behn:hc who.ef) uf.ef)
      [cards this]
    ::  clay
        %ergo  `this
    ::  dill
        %blit
      =+  out=(blit:dill:hc ef)
      ~?  !=(~ out)  out
      [%give %fact [/blit]~ pyro-effect+!>(ef)]~^this
    ::  eyre
        %thus  `this
        %response
      =^  cards  eyre-piers
        abet:(handle-response:(eyre who.ef) uf.ef)
      [cards this]
    ::  iris
        %request
      =^  cards  iris-piers
        abet:(request:(iris:hc who.ef) uf.ef)
      [cards this]
    ::  gall
        %poke-ack  `this
    ::  pyro specific
        %kill
      =.  iris-piers  (~(del by iris-piers) who.ef)
      =.  behn-piers  (~(del by behn-piers) who.ef)
      `this
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+  path  (on-watch:def path)
    [%http-response *]  `this
    [%blit ~]           `this
  ==
::
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  ?+    wire  (on-arvo:def wire sign-arvo)
      [%b @ ~]
    ?>  ?=([%behn %wake *] sign-arvo)
    =/  who  (,@p (slav %p i.t.wire))
    =^  cards  behn-piers
      abet:(take-wake:(behn:hc who) error.sign-arvo)
    [cards this]
  ::
      [%i @ @ ~]
    ?>  ?=([%iris %http-response %finished *] sign-arvo)
    =/  who=@p    (slav %p i.t.wire)
    =/  num=@ud   (slav %ud i.t.t.wire)
    =*  red       response-header.client-response.sign-arvo
    =/  fuf
      ?~(ful=full-file.client-response.sign-arvo ~ `data.u.ful)
    =^  cards  iris-piers
      abet:(take-sigh-httr:(iris:hc who) num red fuf)
    [cards this]
  ::
      [%bind ~]  ?>(?=([%eyre %bound %.y *] sign-arvo) `this)
  ==
::
++  on-agent  on-agent:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-fail   on-fail:def
--
::
=|  behn-piers=(map ship behn-pier)
=|  eyre-piers=(map ship eyre-pier)
=|  iris-piers=(map ship iris-pier)
|_  bowl=bowl:gall
++  ames
  |%
  ++  send
    =,  ^ames
    |=  [sndr=@p way=wire %send lan=lane pac=@]
    ^-  (list card:agent:gall)
    =/  rcvr=ship
      ?-  -.lan
        %&  p.lan
        %|  `ship``@`p.lan
      ==
    =/  =shot  (sift-shot pac)
    ?.  &(!sam.shot req.shot) :: TODO I beleive this is right
      ::  normal packet
      ::
      :_  ~
      :*  %pass  /pyro-events  %agent  [our.bowl %pyro]  %poke
          %pyro-events  !>([rcvr /a/newt/0v1n.2m9vh %hear %|^`address``@`sndr pac]~)
      ==
    ::  remote scry packet
    ::
    =/  =peep  +:(sift-wail `@ux`content.shot)
    :: unpack path.peep
    =+  bal=(de-path:balk path.peep)
    =+  .^  pacs=(list yowl)  %gx
            ;:  weld
              /(scot %p our.bowl)/pyro/(scot %da now.bowl)/r            ::  /=pyro=/r
              /(scot %p her.bal)/(scot %ud rif.bal)/(scot %ud lyf.bal)  ::  /~wes/0/1/
              /[van.bal]/[car.bal]/(scot cas.bal)                       ::  /c/x/1
              spr.bal                                                   ::  /kids/ted/keen/hoon
              /noun :: TODO swap out for noun or something else
        ==  ==
    %+  turn  pacs
    |=  =yowl
    :*  %pass  /pyro-events  %agent  [our.bowl %pyro]  %poke
        %pyro-events
        :: =+  shot=(sift-shot `@`yowl)
        :: =/  asdf  (etch-shot shot(sndr sndr, rcvr rcvr))
        !>([sndr /a/newt/0v1n.2m9vh %hear %|^`address``@`rcvr `blob``@`yowl]~)
    ==
  --
::
++  behn
  |=  who=ship
  =+  (~(gut by behn-piers) who *behn-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ::
  ++  abet
    ^-  (quip card:agent:gall _behn-piers)
    =.  behn-piers  (~(put by behn-piers) who pier-data)
    [(flop cards) behn-piers]
  ::
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
  ::
  ++  doze
    |=  [way=wire %doze tim=(unit @da)]
    ^+  ..abet
    ?~  tim
      ?~  next-timer
        ..abet
      cancel-timer
    ?~  next-timer
      (set-timer u.tim)
    (set-timer:cancel-timer u.tim)
  ::
  ++  set-timer
    |=  tim=@da
    =.  next-timer  `tim
    =.  this  (emit-cards [%pass /b/(scot %p who) %arvo %b %wait tim]~)
    ..abet
  ::
  ++  cancel-timer
    =.  this
      (emit-cards [%pass /b/(scot %p who) %arvo %b %rest (need next-timer)]~)
    =.  next-timer  ~
    ..abet
  ::
  ++  take-wake
    |=  error=(unit tang)
    =.  next-timer  ~
    =.  this
      %-  emit-pyro-events
      ?^  error
        ::  Should pass through errors to pyro, but doesn't
        ((slog leaf+"pyro-behn: timer failed" u.error) ~)
      [who /b/behn/0v1n.2m9vh [%wake ~]]~
    ..abet
  --
::
++  dill
  |%
  ++  blit
    |=  [who=@p way=wire %blit blits=(list blit:^dill)]
    ^-  tape
    %+  roll  blits
    |=  [b=blit:^dill line=tape]
    ?-  -.b
      %bel  line
      %clr  ""
      %hop  ""
      %klr  (tape (zing (turn p.b tail)))
      %mor  (blit who way %blit p.b)
      %nel  ""
      %put  ~&  (weld "{<who>}: " (tufa p.b))  ""
      %sag  ~&  [%save-jamfile-to p.b]  line
      %sav  ~&  [%save-file-to p.b]     line
      %url  ~&  [%activate-url p.b]     line
      %wyp  ""
    ==
  --
::
++  eyre
  |=  who=ship
  =+  (~(gut by eyre-piers) who *eyre-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ::
  ++  abet
    ^-  (quip card:agent:gall _eyre-piers)
    =.  eyre-piers  (~(put by eyre-piers) who pier-data)
    [cards eyre-piers] :: TODO might need to flop if I start chaining calls
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
  ::
  ++  pass-request
    |=  [rid=@t req=inbound-request:^eyre]
    ::  add auth cookie to request, if we have it
    =?  header-list.request.req  ?=(^ cookie)
      [['cookie' u.cookie] header-list.request.req]
    %-  emit-pyro-events
    [~nec /e/(scot %p who)/[rid] %request [secure address request]:req]~
  ::
  ++  handle-response
    |=  [way=wire %response ev=http-event:http]
    ^+  ..abet
    ?>  ?=([@ @ ~] way)
    =/  paths  [/http-response/[i.t.way]]~
    =/  kicks  [%give %kick paths ~]~
    ?-    -.ev
    :: TODO to get zero edits to eyre, we need to create our own pyro frontend
    ::   that auto-pokes the correct POST endpoint with the requisite data
    ::   rather than editing the login page within eyre. This should be easy
        %start
      =*  hed  response-header.ev
      =.  cookie  ?~(new=(has-cookie:pyre headers.hed) cookie new)
      =.  headers.hed  (parse-headers:pyre headers.hed)
      =.  this
        %-  emit-cards
        :+  [%give %fact paths [%http-response-header !>(hed)]]
          [%give %fact paths %http-response-data !>(data.ev)]
        ?:(complete.ev kicks ~)
      ..abet
    ::
        %continue
      =.  this
        %-  emit-cards
        :-  [%give %fact paths %http-response-data !>(data.ev)]
        ?:(complete.ev kicks ~)
      ..abet
    ::
        %cancel  =.(this (emit-cards kicks) ..abet)
    ==
  --
::
++  iris
  ::  :pyro|dojo ~nec "|pass [%i %request [%'GET' 'https://urbit.org' ~ ~] *outbound-config:iris]"
  ::  :pyro|dojo ~nec "|pass [%i %cancel-request ~]"
  ::  
  |=  who=ship
  =+  (~(gut by iris-piers) who *iris-pier)
  =*  pier-data  -
  =|  cards=(list card:agent:gall)
  |%
  ++  this  .
  ::
  ++  abet
    ^-  (quip card:agent:gall _iris-piers)
    =.  iris-piers  (~(put by iris-piers) who pier-data)
    [(flop cards) iris-piers]
  ::
  ++  emit-cards
    |=  cs=(list card:agent:gall)
    %_(this cards (weld cs cards))
  ::
  ++  emit-pyro-events
    |=  aes=(list pyro-event)
    %-  emit-cards
    [%pass /pyro-events %agent [our.bowl %pyro] %poke %pyro-events !>(aes)]~
  ::
  ++  request
    |=  [way=wire %request id=@ud req=request:http]
    ^+  ..abet
    =.  http-requests  (~(put in http-requests) id)
    =.  this
      %-  emit-cards  :_  ~
      :^  %pass  /i/(scot %p who)/(scot %ud id)  %arvo
      [%i %request req *outbound-config:^iris]
    ..abet
  ::
  ::  Pass HTTP response back to virtual ship
  ::
  ++  take-sigh-httr
    |=  [num=@ud =response-header:http data=(unit octs)]
    ^+  ..abet
    ?.  (~(has in http-requests) num)
      ~&  [who=who %ignoring-httr num=num]
      ..abet
    =.  http-requests  (~(del in http-requests) num)
    =.  this
      %-  emit-pyro-events
      :_  ~
      :^  who  /i/http/0v1n.2m9vh  %receive
      [num %start response-header data &]
    ..abet
  --
--
