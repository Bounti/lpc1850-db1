cmake_minimum_required(VERSION 3.8)

function(download_file url filename hash_type hash)
if(NOT EXISTS ${filename})
  file(DOWNLOAD ${url} ${filename}
       TIMEOUT 60  # seconds
       EXPECTED_HASH ${hash_type}=${hash}
       TLS_VERIFY ON)
endif()
endfunction(download_file)

# project name
project(baremetal)

# download lpc1850-db1 software example
download_file(https://diolan.com/media/wysiwyg/downloads/lpc1800-demos.zip ./lpc1800-demos.zip SHA1 b388fc1b7b2f9e2d968300968ffbf0cb17d3858b)
file(ARCHIVE_EXTRACT INPUT ./lpc1800-demos.zip)
file(REMOVE ./build/LPC1800-demos/Drivers/source/sdio.c)

# enable assembly support
enable_language(ASM)

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS)

# select linker script
set(LINKER_SCRIPT "_flash.ld")

# define CPU OPTIONS
set(CPU_OPTIONS -mthumb -mcpu=cortex-m3)

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(CMAKE_C_FLAGS_DEBUG "-Og -g3 -DDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g3")
set(CMAKE_C_FLAGS_RELEASE "-Os -flto")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -flto")

add_definitions(
  -DCORE_M3
  -D__USE_LPCOPEN
  -D__CODE_RED
  -D__LPC18XX__
  -D__MULTICORE_NONE
)

add_compile_options(
    ${CPU_OPTIONS}
    -ffreestanding
    -ffunction-sections
    -fdata-sections
    -fno-builtin
    -std=gnu11
    -mfloat-abi=softfp
    -fomit-frame-pointer
)

include_directories("./build/LPC1800-demos/Drivers/include")
include_directories("./build/LPC1800-demos/Boards")
include_directories("./build/LPC1800-demos/Core/CMSIS/Include")
include_directories("./build/LPC1800-demos/Core/Device/NXP/LPC18xx/Include")
include_directories("./build/LPC1800-demos/Drivers/include")
include_directories("./build/LPC1800-demos/Core/CMSIS/Include")
include_directories("./build/LPC1800-demos/Core/CMSIS/Include")
include_directories(
    ${CMAKE_SOURCE_DIR}
)

link_directories(
    ${CMAKE_SOURCE_DIR}
)

file(GLOB SOURCES ./build/LPC1800-demos/Core/Device/NXP/LPC18xx/Source/Templates/*.c
    ./build/LPC1800-demos/Drivers/source/*.c
    ./startup_LPC18xx.s
    ./build/LPC1800-demos/Boards/syscalls.c
    ./syscalls.c
)

set_source_files_properties(./startup_LPC18xx.s PROPERTIES COMPILE_FLAGS "-mthumb -mcpu=cortex-m3")

file(GLOB ADC_SRC  ./build/LPC1800-demos/Examples/ADC/*.c)
file(GLOB BLS_SRC  ./build/LPC1800-demos/Examples/ButtonsLedsSimple/*.c)
file(GLOB CD_SRC   ./build/LPC1800-demos/Examples/CombinedDemo/*.c ./build/LPC1800-demos/Examples/CombinedDemo/usbd/*.c ./build/LPC1800-demos/Examples/CombinedDemo/easyweb/*.c)
file(GLOB GI_SRC   ./build/LPC1800-demos/Examples/GPIO_Interrupts/*.c)
file(GLOB H_SRC    ./build/LPC1800-demos/Examples/HDMI/*.c)
file(GLOB IE_SRC   ./build/LPC1800-demos/Examples/I2C_EEPROM/*.c)
file(GLOB LCD_SRC  ./build/LPC1800-demos/Examples/LCD/*.c)
file(GLOB LCDE_SRC ./build/LPC1800-demos/Examples/LCD_ExtSDRAM/*.c)
file(GLOB ST_SRC   ./build/LPC1800-demos/Examples/SDRAM_Test/*.c)
file(GLOB SDF_SRC  ./build/LPC1800-demos/Examples/SPI_DataFlash/*.c)
file(GLOB UHR_SRC  ./build/LPC1800-demos/Examples/USB_ROM_HIDmouse/*.c)
file(GLOB W_SRC   ./build/LPC1800-demos/Examples/Web/*.c ./build/LPC1800-demos/Examples/Web/easyweb/*.c)

add_executable("${PROJECT_NAME}.ADC"               ${SOURCES}  ${ADC_SRC})
add_executable("${PROJECT_NAME}.ButtonsLedsSimple" ${SOURCES}  ${BLS_SRC})  
add_executable("${PROJECT_NAME}.CombinedDemo"      ${SOURCES}  ${CD_SRC}) 
add_executable("${PROJECT_NAME}.GPIO_Interrupts"   ${SOURCES}  ${GI_SRC}) 
add_executable("${PROJECT_NAME}.HDMI"              ${SOURCES}  ${H_SRC}) 
add_executable("${PROJECT_NAME}.I2C_EEPROM"        ${SOURCES}  ${IE_SRC}) 
add_executable("${PROJECT_NAME}.LCD"               ${SOURCES}  ${LCD_SRC}) 
add_executable("${PROJECT_NAME}.LCD_ExtSDRAM"      ${SOURCES}  ${LCDE_SRC}) 
add_executable("${PROJECT_NAME}.SDRAM_Test"        ${SOURCES}  ${ST_SRC}) 
add_executable("${PROJECT_NAME}.SPI_DataFlash"     ${SOURCES}  ${SDF_SRC}) 
add_executable("${PROJECT_NAME}.USB_ROM_HIDmouse"  ${SOURCES}  ${UHR_SRC})
add_executable("${PROJECT_NAME}.Web"               ${SOURCES}  ${W_SRC}) 

target_include_directories("${PROJECT_NAME}.ADC"               PUBLIC "./build/LPC1800-demos/Examples/ADC")
target_include_directories("${PROJECT_NAME}.ButtonsLedsSimple" PUBLIC "./build/LPC1800-demos/Examples/ButtonsLedsSimple") 
target_include_directories("${PROJECT_NAME}.CombinedDemo"      PUBLIC "./build/LPC1800-demos/Examples/CombinedDemo")
target_include_directories("${PROJECT_NAME}.GPIO_Interrupts"   PUBLIC "./build/LPC1800-demos/Examples/GPIO_Interrupts")
target_include_directories("${PROJECT_NAME}.HDMI"              PUBLIC "./build/LPC1800-demos/Examples/HDMI")
target_include_directories("${PROJECT_NAME}.I2C_EEPROM"        PUBLIC "./build/LPC1800-demos/Examples/I2C_EEPROM")
target_include_directories("${PROJECT_NAME}.LCD"               PUBLIC "./build/LPC1800-demos/Examples/LCD")
target_include_directories("${PROJECT_NAME}.LCD_ExtSDRAM"      PUBLIC "./build/LPC1800-demos/Examples/LCD_ExtSDRAM") 
target_include_directories("${PROJECT_NAME}.SDRAM_Test"        PUBLIC "./build/LPC1800-demos/Examples/SDRAM_Test")
target_include_directories("${PROJECT_NAME}.SPI_DataFlash"     PUBLIC "./build/LPC1800-demos/Examples/SPI_DataFlash") 
target_include_directories("${PROJECT_NAME}.USB_ROM_HIDmouse"  PUBLIC "./build/LPC1800-demos/Examples/USB_ROM_HIDmouse")
target_include_directories("${PROJECT_NAME}.Web"               PUBLIC "./build/LPC1800-demos/Examples/Web")

target_link_libraries("${PROJECT_NAME}.ADC"               ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.ButtonsLedsSimple" ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.CombinedDemo"      ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.GPIO_Interrupts"   ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.HDMI"              ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.I2C_EEPROM"        ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.LCD"               ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.LCD_ExtSDRAM"      ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.SDRAM_Test"        ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.SPI_DataFlash"     ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.USB_ROM_HIDmouse"  ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
target_link_libraries("${PROJECT_NAME}.Web"               ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)

set_property(TARGET "${PROJECT_NAME}.ADC"               PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.ButtonsLedsSimple" PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.CombinedDemo"      PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.GPIO_Interrupts"   PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.HDMI"              PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.I2C_EEPROM"        PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.LCD"               PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.LCD_ExtSDRAM"      PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.SDRAM_Test"        PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.SPI_DataFlash"     PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.USB_ROM_HIDmouse"  PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
set_property(TARGET "${PROJECT_NAME}.Web"               PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})

include("./arm-none-eabi.cmake")
