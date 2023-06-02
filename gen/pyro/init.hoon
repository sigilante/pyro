:: Start a pyro ship
:: Usage: :pyro|init ~nec
::        :pyro|init ~nec, =cache %my-cache
::
:-  %say
|=  [* [her=ship ~] cache=@tas]
:-  %pyro-action
[%init-ship her ?~(cache %default cache)]
