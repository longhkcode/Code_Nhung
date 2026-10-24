#include <io.h>
#include <delay.h>

unsigned char char_code[] = {
    0xC0, // 0
    0xF9, // 1
    0xA4, // 2
    0xB0, // 3
    0x99, // 4
    0x92, // 5
    0x82, // 6
    0xF8, // 7
    0x80, // 8
    0x90  // 9
};

void hienthi_haiso(int num) {
    int chuc = num / 10;
    int donvi = num % 10;
    int i;
    
    for (i = 0; i < 50; i++) {
        PORTA = char_code[chuc];
        PORTF = 0x01;
        delay_ms(10);

        PORTA = char_code[donvi];
        PORTF = 0x02;
        delay_ms(10);
    }
}

void main() {
    int count = 30;

    DDRA = 0xFF;
    DDRF = 0xFF;
    DDRC = 0xFF;
    
    PORTC = 0x00;

    while (1) {
        hienthi_haiso(count);

        if (count > 0) {
            count--;
            PORTC &= ~(1 << 3);
        } else {
            PORTC |= (1 << 3);
        }
    }
}