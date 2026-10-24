#include <mega128.h>
#include <delay.h>

#define rl1 PORTC.3

void io_init(void){
    DDRC.3 = 1;  
    PORTC.3 = 0; 
}

void main(void){
    io_init();
    
    while(1){
        rl1 = 1;    
        delay_ms(500); 
        
        rl1 = 0;   
        delay_ms(500);
    }
}