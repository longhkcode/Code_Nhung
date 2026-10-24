// d?c vào tr?ng thái 3 nút b?m m?i nút b?m là 1 màu và t?i 1 th?i di?m ch? có 1 dèn sáng
#include <mega128.h>
#include <delay.h>

#define bt1 PINB.0
#define bt2 PINB.2
#define bt3 PINB.3

#define led_R PORTD.4
#define led_G PORTD.5
#define led_B PORTD.6
void io_init(void){
    DDRD = 0b01110000;
    DDRB = 0x00;
    PORTD = 0x00;
    PORTB = 0x0D;
}
void ledOff(void){
    led_R = 0;
    led_G = 0;
    led_B = 0;
}
void main(void){
    io_init();
    while(1){
        if(bt1 == 0){ledOff();led_G = 1;}
        else if (bt2 == 0){ledOff();led_B = 1;}
        else if (bt3 == 0){ledOff();led_R = 1;}
        else{ledOff();}
        delay_ms(10);
    }
}