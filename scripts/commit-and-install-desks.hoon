=/  m  (strand ,vase)
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
++  commit-desk
  |=  desk-name=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  ~  bind:m
    %-  send-raw-card
    :^  %pass  /mount/[desk-name]  %arvo  [%c %dirk desk-name]
  (pure:m ~)
++  install-desk
  |=  desk-name=@tas
  =/  m  (strand ,~)
  ^-  form:m
  ;<  =bowl:strand  bind:m  get-bowl
  ;<  ~  bind:m
    %+  poke-our  %hood
    :-  %kiln-install
    !>([desk-name our.bowl desk-name])
  (pure:m ~)
++  ted
  ^-  form:m
  =/  commit-desk-names=(list @tas)  ~[%linedb %suite]
  =/  install-desk-names=(list @tas)  ~[%linedb]
  ;<  ~  bind:m
    (iterate-over-desks commit-desk-names commit-desk)
  ;<  ~  bind:m  (sleep (mul ~s1 (lent commit-desk-names)))
  ;<  ~  bind:m
    (iterate-over-desks install-desk-names install-desk)
  ;<  ~  bind:m  (sleep ~s1)
  (pure:m !>('commit-and-install-desks: success'))
--
