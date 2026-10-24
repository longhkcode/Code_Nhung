#include <io.h>
#include <alcd.h>
#include <delay.h>

#define LCD_BL PORTD.7

int keypad[3][3] = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

const char key_chars[9][5] = {
    {'1', 'a', 'b', 'c', 'd'}, // Phím 1
    {'2', 'e', 'f', 'g', 'h'}, // Phím 2
    {'3', 'i', 'j', 'k', 'l'}, // Phím 3
    {'4', 'm', 'n', 'o', 'p'}, // Phím 4
    {'5', 'q', 'r', 's', 't'}, // Phím 5
    {'6', 'u', 'v', 'w', 'x'}, // Phím 6
    {'7', 'y', 'z', '.', ','}, // Phím 7
    {'8', '?', '!', '@', '#'}, // Phím 8
    {'9', ' ', '-', '_', '+'}  // Phím 9
};

unsigned char scan_key_index(void) {
    unsigned char r;
    for (r = 0; r < 3; r++) {
        if (r == 0) { PORTC = (PORTC & 0x0F) | 0x30; PORTE = 0x03; PORTD = 0x81; }
        if (r == 1) { PORTC = (PORTC & 0x0F) | 0x70; PORTE = 0x01; PORTD = 0x81; }
        if (r == 2) { PORTC = (PORTC & 0x0F) | 0x70; PORTE = 0x03; PORTD = 0x80; }

        delay_us(10);

        if ((PINC & 0x10) == 0) {
            delay_ms(20);
            if ((PINC & 0x10) == 0) {
                while ((PINC & 0x10) == 0) delay_ms(10);
                return keypad[r][0];
            }
        }
        if ((PINC & 0x20) == 0) {
            delay_ms(20);
            if ((PINC & 0x20) == 0) {
                while ((PINC & 0x20) == 0) delay_ms(10);
                return keypad[r][1];
            }
        }
        if ((PINE & 0x01) == 0) {
            delay_ms(20);
            if ((PINE & 0x01) == 0) {
                while ((PINE & 0x01) == 0) delay_ms(10);
                return keypad[r][2];
            }
        }
    }
    return 0;
}

void main(void) {
    unsigned char key_pressed;
    unsigned char last_key = 0;
    unsigned char char_idx = 0;
    unsigned char col_pos = 0;
    unsigned int timer_counter = 0;
    
    lcd_init(16);
    DDRC = 0x4F;  PORTC = 0x70;
    DDRE = 0x02;  PORTE = 0x03;
    DDRD = 0x81;  PORTD = 0x81;
    LCD_BL = 1;

    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_putsf("MULTI-TAP INPUT:");
    lcd_gotoxy(0, 1);

    while (1) {
        key_pressed = scan_key_index();

        if (key_pressed != 0) {
            if (key_pressed == last_key) {
                char_idx = (char_idx + 1) % 5;
            } else {
                if (last_key != 0) {
                    col_pos++;
                    if (col_pos >= 16) col_pos = 0;
                }
                last_key = key_pressed;
                char_idx = 0;
            }

            lcd_gotoxy(col_pos, 1);
            lcd_putchar(key_chars[last_key - 1][char_idx]);

            timer_counter = 0;
        } else { 
            if (last_key != 0) {
                delay_ms(10);
                timer_counter += 10;
                if (timer_counter >= 1200) {
                    last_key = 0;
                    char_idx = 0;
                    col_pos++;
                    if (col_pos >= 16) col_pos = 0;
                    timer_counter = 0;
                }
            }
        }
    }
}