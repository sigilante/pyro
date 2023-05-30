=/  m  (strand ,vase)
^-  form:m
|^  ted
++  iterate-over-desks
  =/  m  (strand ,~)
  |=  [desk-names=(list @tas) gate=$-(@tas form:m)]
  ^-  form:m
  |-
  ?~  desk-names  (pure:m ~)
  =*  desk-name  i.desk-names
  ;<  ~  bind:m  (gate desk-name)
  $(desk-names t.desk-names)
++  mount-desk
  |=  desk-name=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  ;<  ~  bind:m
    %-  send-raw-card
    :^  %pass  /mount/[desk-name]  %arvo
    [%c %mont desk-name [our.bowl desk-name da+now.bowl] /]
  (pure:m ~)
++  make-new-desk
  |=  desk-name=@tas
  =/  m  (strand ,~)
  ^-  form:m
  =/  file-paths=(list path)
    :~  /mar/noun/hoon
        /mar/hoon/hoon
        /mar/txt/hoon
        /mar/kelvin/hoon
        /sys/kelvin
    ==
  =|  path-to-page=(map path page:clay)
  ;<  =bowl:strand  bind:m  get-bowl
  =.  path-to-page
    |-
    ?~  file-paths  path-to-page
    =*  p  i.file-paths
    =+  .^  file=*
            %cx
            %-  weld  :_  p
            /(scot %p our.bowl)/base/(scot %da now.bowl)
        ==
    %=  $
        file-paths  t.file-paths
        path-to-page
      (~(put by path-to-page) p [(rear p) file])
    ==
  ;<  ~  bind:m
    %-  send-raw-card
    :^  %pass  /new-desk/[desk-name]  %arvo
    %^  new-desk:cloy  desk-name  ~  path-to-page
  (pure:m ~)
++  ted
  ^-  form:m
  =/  desk-names=(list @tas)  ~[%linedb %suite]
  ;<  ~  bind:m
    (iterate-over-desks desk-names make-new-desk)
  ;<  ~  bind:m  (sleep ~s1)
  ;<  ~  bind:m
    (iterate-over-desks desk-names mount-desk)
  ;<  ~  bind:m  (sleep ~s1)
  (pure:m !>('create-desks: success'))
--
