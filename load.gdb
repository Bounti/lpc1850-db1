target remote localhost:3000
monitor halt
file ./build/baremetal.multithreads
load
set $pc=Reset_Handler
b main
add-symbol-file ~/Projects/dmon/build/top.sdk/app/Debug/app.elf 0x100000
continue
