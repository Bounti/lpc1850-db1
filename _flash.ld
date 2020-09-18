/*
*****************************************************************************
**

**  File        : LinkerScript.ld
**
**  Abstract    : Linker script for LPC1850-DB1 Device with
**                16MB Spansion S29AL016J70TFI01 and 6KB SRAM
**
**  Target      : LPC1850
**
**  Author      : Nassim Corteggiani
*****************************************************************************
*/

OUTPUT_FORMAT("elf32-littlearm")
OUTPUT_ARCH(arm)

/* Entry Point */
ENTRY(Reset_Handler)

/* Specify the memory areas */
MEMORY
{
FLASH (rx)     : ORIGIN = 0x1c000000, LENGTH = 16M
RAM (xrw)      : ORIGIN = 0x10000000, LENGTH = 50K
}

__cs3_stack = ORIGIN(RAM) + LENGTH(RAM);
Heap_Size = 0x200;
Stack_Size = 0x400;

/* Define output sections */
SECTIONS
{
  . = ORIGIN(FLASH);

  /*
  .interrupt_vector :
  {
    . = ORIGIN(FLASH);
    . = ALIGN(4);
    KEEP(*(.interrupt_vector))
    . = ALIGN(4);
  } >FLASH
  */

  /* The program code and other data goes into FLASH */
  .text :
  {
    . = ALIGN(4);
    KEEP(*(.interrupt_vector))
    KEEP(*(.text))           /* .text sections (code) */
    KEEP(*(.text*))          /* .text* sections (code) */
    *(.glue_7)         /* glue arm to thumb code */
    *(.glue_7t)        /* glue thumb to arm code */
    *(.eh_frame)
    KEEP (*(.init))
    KEEP (*(.fini))
    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  /* Constant data goes into FLASH */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* .rodata sections (constants, strings, etc.) */
    *(.rodata*)        /* .rodata* sections (constants, strings, etc.) */
    . = ALIGN(4);
  } >FLASH

  /* Initialized data sections goes into RAM, load LMA copy after code */
  .data : 
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* .data sections */
    *(.data*)          /* .data* sections */
    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */
  } >RAM AT> FLASH

  
  /* Uninitialized data section */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss secion */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)
    *(.bss*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM AT> FLASH

  .user_heap_stack :
  {
    . = ALIGN(4);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + Heap_Size;
    . = . + Stack_Size;
    . = ALIGN(8);
  } >RAM
  
  /* Remove information from the standard libraries */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  } >FLASH

  .ARM.attributes 0 : { *(.ARM.attributes) }
}
