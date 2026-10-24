#include <io.h>
#include <glcd.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <font5x7.h>

#define BT1 PINB.0
#define BT2 PINB.1
#define BT3 PINB.2

GLCDINIT_t glcd_init_data;

void update_display_and_glcd(void) {
    char buf[17];
    
    glcd_init(&glcd_init_data);
    
    lcd_clear();
    
    lcd_gotoxy(0, 0);
    sprintf(buf, "B:%d  Temp:%d", glcd_init_data.bias, glcd_init_data.temp_coef);
    lcd_puts(buf);
    
    lcd_gotoxy(0, 1);
    sprintf(buf, "Vlcd:%d", glcd_init_data.vlcd);
    lcd_puts(buf);
}

void main(void) {
    DDRB = 0x00;
    PORTB = 0x07;

    glcd_init_data.font = font5x7;
    glcd_init_data.bias = 1;
    glcd_init_data.temp_coef = 40;
    glcd_init_data.vlcd = 50;

    lcd_init(16);
    update_display_and_glcd();

    while (1) {
        if (BT1 == 0) {
            delay_ms(20);
            if (BT1 == 0) {
                glcd_init_data.bias++;
                if (glcd_init_data.bias > 5) glcd_init_data.bias = 1;
                update_display_and_glcd();
                while (BT1 == 0);
            }
        }

        if (BT2 == 0) {
            delay_ms(20);
            if (BT2 == 0) {
                glcd_init_data.temp_coef += 5;
                if (glcd_init_data.temp_coef > 120) glcd_init_data.temp_coef = 40;
                update_display_and_glcd();
                while (BT2 == 0);
            }
        }

        if (BT3 == 0) {
            delay_ms(20);
            if (BT3 == 0) {
                glcd_init_data.vlcd += 5;
                if (glcd_init_data.vlcd > 90) glcd_init_data.vlcd = 30;
                update_display_and_glcd();
                while (BT3 == 0);
            }
        }
    }
}