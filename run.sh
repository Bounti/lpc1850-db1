#!/usr/bin/env bash

#rm -rf build && mkdir build
cd build && cmake -DCMAKE_BUILD_TYPE=Debug .. && make clean && make

exit

reset_handler=$(readelf -a ./baremetal.$1 | grep "Reset_Handler" | awk '{print $2}')

arm-none-eabi-objcopy --set-start 0x1c000000 ./baremetal.$1 -O binary ./baremetal.$1.bin

arm-none-eabi-objdump -S -marm -D ./baremetal.$1 > ./baremetal.$1.dis

readelf -S ./baremetal.$1

exit

echo "h" > flash.jlink
echo "loadbin ./baremetal."$1".bin 1C000000" >> flash.jlink
echo "SetPC "$reset_handler >> flash.jlink
echo "mem32 1C000000 5" >> flash.jlink
echo "g" >> flash.jlink

#JLinkExe -device "ZYNQ 7020" -if JTAG -jtagconf -1,-1 -speed 4000 -autoconnect 1 -NoGui 1 -CommanderScript ./flash.jlink
