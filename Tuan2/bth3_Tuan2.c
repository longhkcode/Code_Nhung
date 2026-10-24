#include <mega128.h>
#include <delay.h>

#define LED_R PORTD.4 
#define LED_G PORTD.5  

void io_init(void){
    DDRD = 0x30; 
    PORTD = 0x00;  
}

void main(void){
    io_init();
    
    while(1){
        LED_R = 1;
        LED_G = 0;
        delay_ms(500);

        LED_R = 0;
        LED_G = 1;
        delay_ms(500); 
    }
}