#!/usr/bin/env bash

#rm -rf build && mkdir build
cd build && cmake -DDMon=ON -DCMAKE_BUILD_TYPE=Debug .. && make clean && make

reset_handler=$(readelf -a ./baremetal.$1 | grep "Reset_Handler" | awk '{print $2}')

arm-none-eabi-objcopy ./baremetal.$1 -O binary ./callee.bin
#arm-none-eabi-objcopy --set-start 0x1c000000 ./baremetal.$1 -O binary ./callee.bin

arm-none-eabi-objdump -S -marm -D ./baremetal.$1 > ./baremetal.$1.dis

readelf -S ./baremetal.$1

echo "h" > flash.jlink
echo "loadbin ./baremetal."$1".bin 1C000000" >> flash.jlink
echo "SetPC "$reset_handler >> flash.jlink
echo "mem32 1C000000 5" >> flash.jlink
echo "g" >> flash.jlink

#JLinkExe -device "ZYNQ 7020" -if JTAG -jtagconf -1,-1 -speed 4000 -autoconnect 1 -NoGui 1 -CommanderScript ./flash.jlink
