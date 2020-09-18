target remote localhost:2331

file ./build/baremetal.ButtonsLedsSimple

load

monitor halt

set $pc=0x1c000115

#continue
