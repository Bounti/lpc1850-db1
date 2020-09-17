cmake_minimum_required(VERSION 3.0)

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

file(GLOB SOURCES ./build/LPC1800-demos/Examples/ButtonsLedsSimple/*.c
    ./build/LPC1800-demos/Core/Device/NXP/LPC18xx/Source/Templates/*.c
    ./build/LPC1800-demos/Drivers/source/*.c
    ./startup_LPC18xx.s
    ./build/LPC1800-demos/Boards/syscalls.c
    ./syscalls.c
)

set_source_files_properties(./startup_LPC18xx.s PROPERTIES COMPILE_FLAGS "-mthumb -mcpu=cortex-m3")

add_executable(${PROJECT_NAME} ${SOURCES})

target_link_libraries(${PROJECT_NAME}
    ${CPU_OPTIONS}
    -T${LINKER_SCRIPT}
    -nostartfiles
    -fno-builtin
    -mfloat-abi=softfp
    #    m
    -nostdlib
    -lnosys
#    -lc
#    -lgcc
#    -lm
)

set_property(TARGET ${PROJECT_NAME} PROPERTY LINK_DEPENDS ${CMAKE_SOURCE_DIR}/${LINKER_SCRIPT})

include("./arm-none-eabi.cmake")
