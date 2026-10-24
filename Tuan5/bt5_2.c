#include <io.h>
#include <glcd.h>
#include <font5x7.h>
#include <delay.h>

flash unsigned char heart[] = {
    0x08, 0x00, 0x08, 0x00,
    0x1C, 0x22, 0x41, 0x82, 0x82, 0x41, 0x22, 0x1C
};

flash unsigned char heart_1[] = {
    0x08, 0x00, 0x08, 0x00,
    0x1C, 0x3E, 0x7F, 0xFE, 0xFE, 0x7F, 0x3E, 0x1C
};

void main(void) {
    GLCDINIT_t glcd_init_data;
    
    DDRD = 0x80; PORTD = 0x80;
    DDRB = 0x00; PORTB = 0x0C;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 80;
    glcd_init_data.bias = 5;
    glcd_init_data.vlcd = 60;

    glcd_init(&glcd_init_data);
    glcd_putimagef(38, 20, heart, 1);

    while (1) {
        if (PINB.2 == 0) {
            delay_ms(20);
            if (PINB.2 == 0) {
                glcd_putimagef(38, 20, heart_1, 1);
                delay_ms(300);
                glcd_putimagef(38, 20, heart_1, 1);
                delay_ms(300);
            }
        }

        if (PINB.3 == 0) {
            delay_ms(20);
            if (PINB.3 == 0) {
                glcd_clear();
                while (PINB.3 == 0);
            }
        }
    }
}