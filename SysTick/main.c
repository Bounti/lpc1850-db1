/*******************************************************************************
*
* Project: LPC1850-DB1 Development Board Examples
*
* Description: Main code for "SysTick" example.
*
* Author : G. Camurati and N. Corteggiani
*
*******************************************************************************/

// Modified by Giovanni Camurati, Eurecom
// when using with Inception:
//   take all this application, except the generic irq handler, for the host
//   take only the irq handler related stuff for the stub

#include "LPC18xx.h"
#include "lpc1850_db1.h"
#include "lpc18xx_gpio.h"
#include "lpc18xx_scu.h"
#include "lpc18xx_cgu.h"

uint32_t cycleCounter = 0;

void SysTick_Handler(void)
{
    GPIO_ToggleValue(D3_GPIO_PORT, D3_GPIO_MASK);
    cycleCounter++;
}

int main(void)
{
    cycleCounter = 1;

    //SystemInit();
    //CGU_Init();

    // Configure GPIO pins connected to LEDs as outputs
    scu_pinmux(D3_SCU_CONFIG);
    GPIO_SetDir(D3_GPIO_PORT, D3_GPIO_MASK, 1);
    GPIO_ClearValue(D3_GPIO_PORT, D3_GPIO_MASK);

    // Configure GPIO pins connected to push buttons as inputs
    scu_pinmux(S1_SCU_CONFIG);
    GPIO_SetDir(S1_GPIO_PORT, S1_GPIO_MASK, 0);

    while(GPIO_ReadValue(S1_GPIO_PORT) & S1_GPIO_MASK ){};

    // Init SysTick to xx (72000*tck)^-1 = 1kHz
    if(SysTick_Config(7200000)==1){
      while(1);
    }
    GPIO_SetValue(D3_GPIO_PORT, D3_GPIO_MASK);

    while(1){;}
}
