#include <mega128.h>
#include <delay.h>

#define bt1 PINB.0

#define led_G PORTD.5
void io_init(void){
    DDRD = 0x20;
    DDRB = 0x00;
    PORTD = 0x00;
    PORTB = 0x04;
}
void main(void){
    io_init();
    while(1){
        if(bt1 == 0){
            delay_ms(250);
            if(bt1 == 0){
                led_G = !led_G;
                while(bt1 == 0);
            }
        }
    }
}