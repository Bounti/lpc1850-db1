#include "LPC18xx.h"
#include "lpc1850_db1.h"
#include "lpc18xx_gpio.h"
#include "lpc18xx_scu.h"
#include "lpc18xx_cgu.h"

#include <stddef.h>
#include <stdint.h>
#include "reg.h"
#include "threads.h"

static void delay(volatile int count)
{
	count *= 50000;
	while (count--);
}

void test1(void *userdata)
{
  int i = 0;
  while(1) {
    // for(i=0; i< 10; i++) {
      delay(10);
      GPIO_ToggleValue(D3_GPIO_PORT, D3_GPIO_MASK);
    // }
		// *SCB_ICSR |= SCB_ICSR_PENDSVSET;
  }
}

void test2(void *userdata)
{
  int i = 0;
  while(1) {
    // for(i=0; i< 10; i++) {
      delay(10);
      GPIO_ToggleValue(D4_GPIO_PORT, D4_GPIO_MASK);
    // }
		// *SCB_ICSR |= SCB_ICSR_PENDSVSET;
  }
}

void SysTick_Handler()
{
	*SCB_ICSR |= SCB_ICSR_PENDSVSET;
}

int main(void)
{
   // Configure LEDs
   scu_pinmux(D3_SCU_CONFIG);
   scu_pinmux(D4_SCU_CONFIG);
   scu_pinmux(D5_SCU_CONFIG);
   scu_pinmux(D6_SCU_CONFIG);
   GPIO_SetDir(D3_GPIO_PORT, D3_GPIO_MASK, 1);
   GPIO_SetDir(D4_GPIO_PORT, D4_GPIO_MASK, 1);
   GPIO_SetDir(D5_GPIO_PORT, D5_GPIO_MASK, 1);
   GPIO_SetDir(D6_GPIO_PORT, D6_GPIO_MASK, 1);
   GPIO_ClearValue(D3_GPIO_PORT, D3_GPIO_MASK);
   GPIO_ClearValue(D4_GPIO_PORT, D4_GPIO_MASK);
   GPIO_ClearValue(D5_GPIO_PORT, D5_GPIO_MASK);
   GPIO_ClearValue(D6_GPIO_PORT, D6_GPIO_MASK);

	if (thread_create(test1, (void *) 0xABABABAB) == -1) {
    while(1);
  }

	if (thread_create(test2, (void *) 0xCDCDCDCD) == -1) {
    while(1);
  }

  // Configure GPIO pins connected to push buttons as inputs
  //scu_pinmux(S1_SCU_CONFIG);
  //GPIO_SetDir(S1_GPIO_PORT, S1_GPIO_MASK, 0);
  //while(GPIO_ReadValue(S1_GPIO_PORT) & S1_GPIO_MASK ){};

  // Init SysTick to xx (72000*tck)^-1 = 1kHz
  if(SysTick_Config(7200000)==1){
    while(1);
  }

	thread_start();

  while(1){;}

	return 0;
}
