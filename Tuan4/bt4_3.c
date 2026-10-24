#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>

#define BT1 PINB.2

unsigned char bt1_count = 0;

void main(void) {
    char text[] = "Hello-World";
    int len = strlen(text);
    int i, j, k, start_pos, land_pos;

    DDRB = 0x00;  
    PORTB = 0x04;  
    DDRA = 0xFF;
    DDRD = 0x80;  
    PORTD = 0x80;

    lcd_init(16);  
    lcd_clear();

    while (1) {
        if (BT1 == 0) {  
            delay_ms(50);
            if (BT1 == 0) { 
                bt1_count++;
                if (bt1_count > 3) bt1_count = 1;

                switch (bt1_count) {
                    case 1:
                        lcd_clear();
                        start_pos = 16 - len;
                        for (i = len - 1; i >= 0; i--) {
                            land_pos = start_pos + i;
                            for (j = 0; j <= land_pos; j++) {
                                lcd_clear();
                                for (k = i + 1; k < len; k++) {
                                    lcd_gotoxy(start_pos + k, 0);
                                    lcd_putchar(text[k]); 
                                }
                                lcd_gotoxy(j, 0);
                                lcd_putchar(text[i]);
                                delay_ms(30); 
                            }
                        }
                        break;

                    case 2:
                        lcd_clear();
                        for (i = 0; i < len; i++) {
                            for (j = 15; j >= i; j--) {
                                lcd_clear();
                                for (k = 0; k < i; k++) {
                                    lcd_gotoxy(k, 0);
                                    lcd_putchar(text[k]); 
                                }
                                lcd_gotoxy(j, 0);
                                lcd_putchar(text[i]);
                                delay_ms(30); 
                            }
                        }
                        break;

                    case 3:
                        lcd_clear();
                        break; 
                }

                while (BT1 == 0); 
            }
        }
    }
}