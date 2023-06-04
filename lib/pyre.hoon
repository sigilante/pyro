|%
::
++  parse-url
  |=  url=tape
  ^-  [ship cord]
  ::  format must be /pyro/~sampel-palnet/...
  =.  url  (slag 6 url)  :: cutting off "/pyro/"
  ?~  loc=(find "/" url)  [(slav %p (crip url)) '']
  :-  (slav %p (crip (scag u.loc url))) :: ~nec
  (crip (slag u.loc url)) :: has /pyro/~nec cut off
::
++  has-cookie
  |=  hed=header-list:http
  |-  ^-  (unit @t)
  ?~  hed  ~
  ?:  =('set-cookie' key.i.hed)
    `value.i.hed
  $(hed t.hed)
::
++  parse-headers
  |=  =header-list:http
  ^-  header-list:http
  %+  murn  header-list
  |=  [key=@t value=@t]
  ?+  key  `[key value]
    %content-length  ~
    %set-cookie      ~
    %location  `[key (crip (weld "/pyro/~nec" (trip value)))]
  == 
--