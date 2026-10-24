#include <mega128.h>
#include <delay.h>

#define bt1 PINB.0
#define bt2 PINB.2

#define rl1 PORTC.3
#define rl2 PORTC.2

unsigned char dem = 0;
unsigned char state = 0;

void update_relays(){
    if (dem >=1) rl1 = 1;
    else rl1 = 0;
    if (dem > 4) rl2 = 1;
    else rl2 = 0;
}

void io_init(){
    DDRB = 0x00;
    DDRC = 0x0C;
    PORTB = 0x0C;
    PORTC = 0x00;
    dem = 0;
    state = 0;
    update_relays();
}

void main(){
    io_init();
    while(1){
        if(state == 0){
            if(bt1 == 0) {
                delay_ms(20);
                if(bt1 == 0){
                    while(bt1 == 0);
                    delay_ms(250);
                    state = 1;
                }
            }else if(bt2 == 0) {
                delay_ms(20);
                if(bt2 == 0){
                    while(bt2 == 0);
                    delay_ms(20);
                    state = 2;
                }
            }
        }else if(state == 1){
            if(bt2 == 0){
                delay_ms(20);
                if(bt2==0){
                    while(bt2 == 0);
                    delay_ms(20);
                    if(dem<255){
                        dem++;
                        update_relays();
                        state = 0;
                    }
                }
            }
        }else if(state == 2){
            if(bt1 == 0){
                delay_ms(20);
                if(bt1 == 0){
                    while(bt1 == 0);
                    delay_ms(20);
                    if(dem > 0){
                        dem--;
                        update_relays();
                        state =0;
                    }
                }
            }
        }
    }
}