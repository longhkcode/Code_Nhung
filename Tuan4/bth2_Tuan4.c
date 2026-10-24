#include <io.h>
#include <alcd.h>
#include <delay.h>

#define BT1 PINB.2
#define BT2 PINB.3
#define BT3 PINB.0

#define RELAY1 PORTA.0
#define RELAY2 PORTA.1
#define RELAY3 PORTA.2
#define RELAY4 PORTA.3

int level = 1;
int sel2 = 0;
int sel4 = 0;

void display_menu(void) {
    lcd_clear();
    if (level == 1) {
        lcd_gotoxy(0, 0);
        lcd_puts("> MENU CHINH");
        lcd_gotoxy(0, 1);
        lcd_puts("BT3: Chon");
    } else if (level == 2) {
        if (sel2 == 0) {
            lcd_gotoxy(0, 0);
            lcd_puts("> Menu 1");
            lcd_gotoxy(0, 1);
            lcd_puts("  Menu 2");
        } else {
            lcd_gotoxy(0, 0);
            lcd_puts("  Menu 1");
            lcd_gotoxy(0, 1);
            lcd_puts("> Menu 2");
        }
    } else if (level == 3) {
        lcd_gotoxy(0, 0);
        if (sel2 == 0) {
            lcd_puts("> Menu 1_1");
        } else {
            lcd_puts("> Menu 2_2");
        }
        lcd_gotoxy(0, 1);
        lcd_puts("BT3: Vao Cap 4");
    } else if (level == 4) {
        if (sel4 == 0) {
            lcd_gotoxy(0, 0);
            lcd_puts("> Bat Role 1");
            lcd_gotoxy(0, 1);
            lcd_puts("  Bat Role 2");
        } else if (sel4 == 1) {
            lcd_gotoxy(0, 0);
            lcd_puts("  Bat Role 1");
            lcd_gotoxy(0, 1);
            lcd_puts("> Bat Role 2");
        } else if (sel4 == 2) {
            lcd_gotoxy(0, 0);
            lcd_puts("> Bat Role 3");
            lcd_gotoxy(0, 1);
            lcd_puts("  Bat Role 4");
        } else if (sel4 == 3) {
            lcd_gotoxy(0, 0);
            lcd_puts("  Bat Role 3");
            lcd_gotoxy(0, 1);
            lcd_puts("> Bat Role 4");
        }
    }
}

void execute_relay(void) {
    PORTA = 0x00;
    if (sel4 == 0) RELAY1 = 1;
    else if (sel4 == 1) RELAY2 = 1;
    else if (sel4 == 2) RELAY3 = 1;
    else if (sel4 == 3) RELAY4 = 1;
}

void main(void) {
    DDRB = 0x00;
    PORTB = 0x0D;

    DDRA = 0xFF;
    PORTA = 0x00;

    DDRD = 0x80;
    PORTD = 0x80;

    lcd_init(16);
    display_menu();

    while (1) {
        if (BT1 == 0) {
            delay_ms(50);
            if (BT1 == 0) {
                if (level > 1) level--;
                display_menu();
                while (BT1 == 0);
            }
        }

        if (BT2 == 0) {
            delay_ms(50);
            if (BT2 == 0) {
                if (level == 2) {
                    sel2 = (sel2 + 1) % 2;
                } else if (level == 4) {
                    sel4 = (sel4 + 1) % 4;
                }
                display_menu();
                while (BT2 == 0);
            }
        }

        if (BT3 == 0) {
            delay_ms(50);
            if (BT3 == 0) {
                if (level < 4) {
                    level++;
                } else if (level == 4) {
                    execute_relay();
                }
                display_menu();
                while (BT3 == 0);
            }
        }
    }
}