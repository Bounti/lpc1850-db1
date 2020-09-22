cmake_minimum_required(VERSION 3.8)

function(lpc_add_component target_name files)
  add_executable("${PROJECT_NAME}.${target_name}"    ${files})
  target_include_directories("${PROJECT_NAME}.${target_name}" PUBLIC "${EXAMPLES_DIR}/${target_name}")
  target_link_libraries("${PROJECT_NAME}.${target_name}"      LPC_CORE)
  target_link_libraries("${PROJECT_NAME}.${target_name}"      ${CPU_OPTIONS} -T${LINKER_SCRIPT} -nostartfiles -fno-builtin -mfloat-abi=softfp -nostdlib -lnosys)
  set_property(TARGET "${PROJECT_NAME}.${target_name}"        PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})
endfunction()

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
IF(NOT EXISTS ./lpc1800-demos)
	download_file(https://diolan.com/media/wysiwyg/downloads/lpc1800-demos.zip ./lpc1800-demos.zip SHA1 b388fc1b7b2f9e2d968300968ffbf0cb17d3858b)
	file(ARCHIVE_EXTRACT INPUT ./lpc1800-demos.zip)
	file(REMOVE ./build/LPC1800-demos/Drivers/source/sdio.c)
endif()

execute_process(COMMAND bash -c "find -type f -print0 | xargs -0 sed -i 's/EMAC/emac/g'")
execute_process(COMMAND bash -c "find -type f -print0 | xargs -0 sed -i 's/lpc18xx.h/LPC18xx.h/g'")
execute_process(COMMAND bash -c "find -type f -print0 | xargs -0 sed -i 's/WebPage/webpage/g'")

# enable assembly support
enable_language(ASM)

set(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS)

# select linker script
set(LINKER_SCRIPT "_flash.ld")

# define CPU OPTIONS
set(CPU_OPTIONS -mthumb -mcpu=cortex-m3)

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(CMAKE_C_FLAGS_DEBUG "-O0 -g3 -DDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-O0 -g3")
#"-Os -flto")
set(CMAKE_CXX_FLAGS_RELEASE "-O0 -g3")
#"-Os -flto")

add_definitions(
  -DCORE_M3
  -D__USE_LPCOPEN
  -D__CODE_RED
  -D__LPC18XX__
  -D__MULTICORE_NONE
)

add_compile_options(
    ${CPU_OPTIONS}
    -fno-builtin
    -ffreestanding
    -std=gnu11
    #-mfloat-abi=softfp
    -fomit-frame-pointer
    -nostdlib
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

# set properties for startup file
set_source_files_properties(./startup_LPC18xx.s PROPERTIES COMPILE_FLAGS "-mthumb -mcpu=cortex-m3")

# create LPC_CORE library linked with all examples
add_library(LPC_CORE STATIC ${SOURCES})

# set compile options for LPC_CORE
target_compile_options(LPC_CORE PUBLIC ${CPU_OPTIONS})

set(EXAMPLES_DIR "./build/LPC1800-demos/Examples/")

#AUX_SOURCE_DIRECTORY(./build/LPC1800-demos/Examples/Web W_SRC)
#file(GLOB_RECURSE W_SRC ${EXAMPLES_DIR}/Web/*.c ${EXAMPLES_DIR}/Web/easyweb/*.c)
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

function(create_list relative_path)
  execute_process(COMMAND bash -c "find ${PROJECT_SOURCE_DIR} -type f -name '*.c' | grep '${relative_path}' | tr '\n' ' '" OUTPUT_VARIABLE TMP)
  #execute_process(COMMAND bash -c "find -type f -name '*.c' | grep '${relative_path}' | awk -F. '{print $2}' | tr '\n' ' '" OUTPUT_VARIABLE TMP)
  #execute_process(COMMAND bash -c "find -type f -name '*.c' | grep 'Web' | tr '\n' ' ' | awk '{gsub(\" \",\"\", $0); print $0, \"\"}'" OUTPUT_VARIABLE TMP)
  separate_arguments(TMP UNIX_COMMAND ${TMP})
  set(SOURCES ${TMP} PARENT_SCOPE)
endfunction()

message(${PROJECT_SOURCE_DIR})

#create_list("Web")
#lpc_add_component("Web" ${SOURCES})
create_list("ButtonsLedsSimple")
lpc_add_component("ButtonsLedsSimple" ${BLS_SRC})
create_list("GPIO_Interrupts")
lpc_add_component("GPIO_Interrupts" ${GI_SRC})

include("./arm-none-eabi.cmake")
