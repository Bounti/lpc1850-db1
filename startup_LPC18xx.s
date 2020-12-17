/*****************************************************************************/
/* startup_LPC18xx.s: Startup file for LPC18xx device series                 */
/*****************************************************************************/
/* Version: CodeSourcery Sourcery G++ Lite (with CS3)                        */
/*****************************************************************************/

/* Vector Table */
.syntax unified
.cpu cortex-m3
.fpu softvfp
.thumb

.equ    Stack_Size, 0x00000100
.equ    Sign_Value, 0x5A5A5A5A


  .section .interrupt_vector
  //.section .text.interrupt_vector
  .globl  isr_vector
  .type   isr_vector, %object

isr_vector:
  .word __cs3_stack                 /* Top of Stack                 */
  .word Reset_Handler               /* Reset Handler                */
  .word NMI_Handler                 /* NMI Handler                  */
  .word HardFault_Handler           /* Hard Fault Handler           */
  .word MemManage_Handler           /* MPU Fault Handler            */
  .word BusFault_Handler            /* Bus Fault Handler            */
  .word UsageFault_Handler          /* Usage Fault Handler          */
  .word Sign_Value                  /* Reserved                     */
  .word 0                           /* Reserved                     */
  .word 0                           /* Reserved                     */
  .word 0                           /* Reserved                     */
  .word SVC_Handler                 /* SVCall Handler               */
  .word DebugMon_Handler            /* Debug Monitor Handler        */
  .word 0                           /* Reserved                     */
  .word PendSV_Handler              /* PendSV Handler               */
  .word SysTick_Handler             /* SysTick Handler              */
  /* External Interrupts */
  .word	DAC_IRQHandler	 			/* 16 D/A Converter */
  .word	0				/* 17 Event Router */
  .word	DMA_IRQHandler				/* 18 General Purpose DMA */
  .word	0					/* 19 Reserved */
  .word	0					/* 20 Reserved */
  .word	ETH_IRQHandler				/* 21 Ethernet */
  .word	SDIO_IRQHandler				/* 22 SD/MMC */
  .word	LCD_IRQHandler				/* 23 LCD */
  .word	USB0_IRQHandler				/* 24 USB0*/
  .word	USB1_IRQHandler				/* 25 USB1*/
  .word	SCT_IRQHandler				/* 26 State Configurable Timer*/
  .word	RIT_IRQHandler				/* 27 Repetitive Interrupt Timer*/
  .word	TIMER0_IRQHandler			/* 28 Timer0*/
  .word	TIMER1_IRQHandler			/* 29 Timer1*/
  .word	TIMER2_IRQHandler			/* 30 Timer2*/
  .word	TIMER3_IRQHandler			/* 31 Timer3*/
  .word	MCPWM_IRQHandler			/* 32 Motor Control PWM*/
  .word	ADC0_IRQHandler				/* 33 A/D Converter 0*/
  .word	I2C0_IRQHandler				/* 34 I2C0*/
  .word	I2C1_IRQHandler				/* 35 I2C1*/
  .word	0					/* 36 Reserved*/
  .word	ADC1_IRQHandler				/* 37 A/D Converter 1*/
  .word	SSP0_IRQHandler				/* 38 SSP0*/
  .word	SSP1_IRQHandler				/* 39 SSP1*/
  .word	UART0_IRQHandler			/* 40 UART0*/
  .word	UART1_IRQHandler			/* 41 UART1*/
  .word	UART2_IRQHandler			/* 42 UART2*/
  .word	UART3_IRQHandler			/* 43 UART3*/
  .word	I2S0_IRQHandler				/* 44 I2S*/
  .word I2S1_IRQHandler				/* 45 AES Engine*/
  .word SPIFI_IRQHandler			/* 46 SPI Flash Interface*/
  .word	SGPIO_IRQHandler			/* 47 SGPIO*/
  .word	GPIO0_IRQHandler			/* 48 GPIO0*/
  .word	GPIO1_IRQHandler			/* 49 GPIO1*/
  .word	GPIO2_IRQHandler			/* 50 GPIO2*/
  .word	GPIO3_IRQHandler			/* 51 GPIO3*/
  .word	GPIO4_IRQHandler			/* 52 GPIO4*/
  .word	GPIO5_IRQHandler			/* 53 GPIO5*/
  .word	GPIO6_IRQHandler			/* 54 GPIO6*/
  .word	GPIO7_IRQHandler			/* 55 GPIO7*/
  .word	GINT0_IRQHandler			/* 56 GINT0*/
  .word	GINT1_IRQHandler			/* 57 GINT1*/
  .word	EVRT_IRQHandler				/* 58 Event Router*/
  .word	CAN1_IRQHandler				/* 59 C_CAN1*/
  .word	0							/* 60 Reserved*/
  .word	VADC_IRQHandler				/* 61 VADC*/
  .word	ATIMER_IRQHandler			/* 62 ATIMER*/
  .word	RTC_IRQHandler				/* 63 RTC*/
  .word	0							/* 64 Reserved*/
  .word	WDT_IRQHandler				/* 65 WDT*/
  .word	0							/* 66 M0s*/
  .word	CAN0_IRQHandler				/* 67 C_CAN0*/
  .word QEI_IRQHandler				/* 68 QEI*/
  .size isr_vector, . - isr_vector


/* Reset Handler */

//    .text
    .weak Reset_Handler
    .type   Reset_Handler, %function
Reset_Handler:
    MOV     R0, #0
    LDR     R1, =__bss_start__
    LDR     R2, =__bss_end__
    CMP     R1,R2
    BEQ     BSSIsEmpty
    LoopZI:
    CMP     R1, R2
    BHS		BSSIsEmpty
    STR   	R0, [R1]
    ADD		R1, #4
    BLO     LoopZI
    BSSIsEmpty:
    LDR     R0,=main
    BX      R0
  .size   Reset_Handler,.-Reset_Handler

/* Exception Handlers */

  .weak   NMI_Handler
  .type   NMI_Handler, %function
NMI_Handler:
  B       .
  .size   NMI_Handler, . - NMI_Handler

  .weak   HardFault_Handler
  .type   HardFault_Handler, %function
HardFault_Handler:
  B       .
  .size   HardFault_Handler, . - HardFault_Handler

  .weak   MemManage_Handler
  .type   MemManage_Handler, %function
MemManage_Handler:
  B       .
  .size   MemManage_Handler, . - MemManage_Handler

  .weak   BusFault_Handler
  .type   BusFault_Handler, %function
BusFault_Handler:
  B       .
  .size   BusFault_Handler, . - BusFault_Handler

  .weak   UsageFault_Handler
  .type   UsageFault_Handler, %function
UsageFault_Handler:
  B       .
  .size   UsageFault_Handler, . - UsageFault_Handler

  .weak   SVC_Handler
  .type   SVC_Handler, %function
SVC_Handler:
  B       .
  .size   SVC_Handler, . - SVC_Handler

  .weak   DebugMon_Handler
  .type   DebugMon_Handler, %function
DebugMon_Handler:
  B       .
  .size   DebugMon_Handler, . - DebugMon_Handler

  .weak   PendSV_Handler
  .type   PendSV_Handler, %function
PendSV_Handler:
  B       .
  .size   PendSV_Handler, . - PendSV_Handler

  .weak   SysTick_Handler
  .type   SysTick_Handler, %function
SysTick_Handler:
  B       .
  .size   SysTick_Handler, . - SysTick_Handler


/* IRQ Handlers */

  .globl  Default_Handler
  .type   Default_Handler, %function
Default_Handler:
  B       .
  .size   Default_Handler, . - Default_Handler

  .macro  IRQ handler
  .weak   \handler
  .set    \handler, Default_Handler
  .endm

  IRQ DAC_IRQHandler
	IRQ DMA_IRQHandler
	IRQ ETH_IRQHandler
	IRQ SDIO_IRQHandler
	IRQ LCD_IRQHandler
	IRQ USB0_IRQHandler
	IRQ USB1_IRQHandler
	IRQ SCT_IRQHandler
	IRQ RIT_IRQHandler
	IRQ TIMER0_IRQHandler
	IRQ TIMER1_IRQHandler
	IRQ TIMER2_IRQHandler
	IRQ TIMER3_IRQHandler
	IRQ MCPWM_IRQHandler
	IRQ ADC0_IRQHandler
	IRQ I2C0_IRQHandler
	IRQ I2C1_IRQHandler
	IRQ ADC1_IRQHandler
	IRQ SSP0_IRQHandler
	IRQ SSP1_IRQHandler
	IRQ UART0_IRQHandler
	IRQ UART1_IRQHandler
	IRQ UART2_IRQHandler
	IRQ UART3_IRQHandler
	IRQ I2S0_IRQHandler
	IRQ I2S1_IRQHandler
	IRQ SPIFI_IRQHandler
	IRQ	SGPIO_IRQHandler
	IRQ	GPIO0_IRQHandler
	IRQ	GPIO1_IRQHandler
	IRQ	GPIO2_IRQHandler
	IRQ	GPIO3_IRQHandler
	IRQ	GPIO4_IRQHandler
	IRQ	GPIO5_IRQHandler
	IRQ	GPIO6_IRQHandler
	IRQ	GPIO7_IRQHandler
	IRQ	GINT0_IRQHandler
	IRQ	GINT1_IRQHandler
	IRQ	EVRT_IRQHandler
	IRQ	CAN1_IRQHandler
	IRQ	VADC_IRQHandler
	IRQ	ATIMER_IRQHandler
	IRQ	RTC_IRQHandler
	IRQ	WDT_IRQHandler
	IRQ	CAN0_IRQHandler
	IRQ	QEI_IRQHandler

	.globl  getPC
  .type   getPC, %function
  .thumb_func
getPC:
	MOV     R0,LR
	BX		LR
	.size   getPC,.-getPC
  .end


///*
//// <h> Stack Configuration
////   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
//// </h>
//*/
//
//    .equ    Stack_Size, 0x00000100
//    .equ    Sign_Value, 0x5A5A5A5A
//    .section ".stack", "w"
//    .align  3
//    .globl  __cs3_stack_mem
//    .globl  __cs3_stack_size
//__cs3_stack_mem:
//    .if     Stack_Size
//    .space  Stack_Size
//    .endif
//    .size   __cs3_stack_mem,  . - __cs3_stack_mem
//    .set    __cs3_stack_size, . - __cs3_stack_mem
//
//
///*
//// <h> Heap Configuration
////   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
//// </h>
//*/
//
//    .equ    Heap_Size,  0x00001000
//    .section ".heap", "w"
//    .align  3
//    .globl  __cs3_heap_start
//    .globl  __cs3_heap_end
//__cs3_heap_start:
//    .if     Heap_Size
//    .space  Heap_Size
//    .endif
//__cs3_heap_end:

