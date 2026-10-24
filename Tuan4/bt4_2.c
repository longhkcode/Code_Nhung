#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <string.h>

#define BT1 PINB.2
#define BT2 PINB.3
#define BT3 PINB.0

void main(void) {
    char text[] = "Hello-World";
    int i; 
    
    DDRB = 0x00; 
    PORTB = 0x0D; 
    DDRD = 0x80;
    PORTD = 0x80; 
    
    lcd_init(16); 
    lcd_clear();

    while (1) {
        if (BT1 == 0) { 
            delay_ms(50);
            if (BT1 == 0) {
                for (i = 0; i <= 5; i++) {
                    lcd_clear(); 
                    lcd_gotoxy(i, 0);
                    lcd_puts(text); 
                    delay_ms(200); 
                }
                while (BT1 == 0); 
            }
        }

        if (BT2 == 0) { 
            delay_ms(50);
            if (BT2 == 0) {
                for (i = 5; i >= 0; i--) {
                    lcd_clear(); 
                    lcd_gotoxy(i, 0);
                    lcd_puts(text); 
                    delay_ms(200); 
                }
                while (BT2 == 0); 
            }
        }

        if (BT3 == 0) { 
            delay_ms(50);
            if (BT3 == 0) { 
                lcd_clear(); 
            }
            while (BT3 == 0); 
        }
    }
}