#include <io.h>
#include <delay.h>

unsigned char char_code[] = {
    0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90
};

void hienthi_mot_khung(int num) {
    int chuc = (num / 10) % 10;
    int donvi = num % 10;

    PORTA = char_code[chuc];
    PORTF = 0x01;
    delay_ms(5);

    PORTA = char_code[donvi];
    PORTF = 0x02;
    delay_ms(5);
}

void main() {
    int count = 0;
    int running = 0;
    int timer_ms = 0;

    DDRA = 0xFF;
    DDRF = 0xFF;
    DDRB = 0x00;
    PORTB = 0x0E;

    while (1) {
        if (PINB.2 == 0) {
            delay_ms(20);
            if (PINB.2 == 0) {
                count = 0;
                running = 1;
                timer_ms = 0;
                while (PINB.2 == 0) {
                    hienthi_mot_khung(count);
                }
            }
        }

        if (PINB.3 == 0) {
            delay_ms(20);
            if (PINB.3 == 0) {
                running = 0;
                while (PINB.3 == 0) {
                    hienthi_mot_khung(count);
                }
            }
        }

        if (PINB.1 == 0) {
            delay_ms(20);
            if (PINB.1 == 0) {
                count = 0;
                running = 0;
                timer_ms = 0;
                while (PINB.1 == 0) {
                    hienthi_mot_khung(count);
                }
            }
        }

        hienthi_mot_khung(count);

        if (running == 1) {
            timer_ms += 10;
            if (timer_ms >= 1000) {
                timer_ms = 0;
                count++;
                if (count > 99) count = 0;
            }
        }
    }
}
