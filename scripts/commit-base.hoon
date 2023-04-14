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
++  ted
  ^-  form:m
  =/  commit-desk-names=(list @tas)  ~[%base]
  =/  install-desk-names=(list @tas)  ~
  ;<  ~  bind:m
    (iterate-over-desks commit-desk-names commit-desk)
  (pure:m !>('commit-base: success'))
--
