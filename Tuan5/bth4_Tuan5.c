#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <font5x7.h>

#define BT1 PINB.0
#define BT2 PINB.1
#define BT3 PINB.2

#define LED_R PORTC.0
#define LED_G PORTC.1
#define LED_B PORTC.2

#define RELAY1 PORTD.0
#define RELAY2 PORTD.1
#define RELAY3 PORTD.2
#define RELAY4 PORTD.3

unsigned char current_screen = 0;
unsigned char cursor_pos = 0;

void draw_main_menu(void) {
    glcd_clear();
    glcd_outtextxy(15, 0, "-- MENU --");
    glcd_outtextxy(15, 12, "1. Start");
    glcd_outtextxy(15, 22, "2. Setting");
    glcd_outtextxy(15, 32, "3. About");
    glcd_outtextxy(2, 12 + cursor_pos * 10, "->");
}

void draw_setting_menu(void) {
    glcd_clear();
    glcd_outtextxy(10, 0, "- SETTING -");
    glcd_outtextxy(15, 10, LED_R ? "LED-R: ON" : "LED-R: OFF");
    glcd_outtextxy(15, 20, LED_G ? "LED-G: ON" : "LED-G: OFF");
    glcd_outtextxy(15, 30, LED_B ? "LED-B: ON" : "LED-B: OFF");
    glcd_outtextxy(2, 10 + cursor_pos * 10, "->");
}

void draw_about_menu(void) {
    glcd_clear();
    glcd_outtextxy(15, 0, "- ABOUT -");
    glcd_outtextxy(15, 10, RELAY1 ? "RL1: ON" : "RL1: OFF");
    glcd_outtextxy(15, 20, RELAY2 ? "RL2: ON" : "RL2: OFF");
    glcd_outtextxy(15, 30, RELAY3 ? "RL3: ON" : "RL3: OFF");
    glcd_outtextxy(15, 40, RELAY4 ? "RL4: ON" : "RL4: OFF");
    glcd_outtextxy(2, 10 + cursor_pos * 10, "->");
}

void main(void) {
    GLCDINIT_t glcd_init_data;

    DDRB = 0x00; PORTB = 0x07;
    DDRC = 0xFF; PORTC = 0x00;
    DDRD = 0xFF; PORTD = 0x00;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 80;
    glcd_init_data.bias = 3;
    glcd_init_data.vlcd = 50;
    glcd_init(&glcd_init_data);

    while (1) {
        if (current_screen == 0) draw_main_menu();
        else if (current_screen == 1) draw_setting_menu();
        else if (current_screen == 2) draw_about_menu();

        if (BT1 == 0) {
            delay_ms(20);
            if (BT1 == 0) {
                if (cursor_pos > 0) cursor_pos--;
                while (BT1 == 0);
            }
        }

        if (BT2 == 0) {
            delay_ms(20);
            if (BT2 == 0) {
                unsigned char max_pos = (current_screen == 2) ? 3 : 2;
                if (cursor_pos < max_pos) cursor_pos++;
                while (BT2 == 0);
            }
        }

        if (BT3 == 0) {
            delay_ms(20);
            if (BT3 == 0) {
                if (current_screen == 0) {
                    if (cursor_pos == 1) { current_screen = 1; cursor_pos = 0; }
                    else if (cursor_pos == 2) { current_screen = 2; cursor_pos = 0; }
                } 
                else if (current_screen == 1) {
                    if (cursor_pos == 0) LED_R = !LED_R;
                    else if (cursor_pos == 1) LED_G = !LED_G;
                    else if (cursor_pos == 2) LED_B = !LED_B;
                } 
                else if (current_screen == 2) {
                    if (cursor_pos == 0) RELAY1 = !RELAY1;
                    else if (cursor_pos == 1) RELAY2 = !RELAY2;
                    else if (cursor_pos == 2) RELAY3 = !RELAY3;
                    else if (cursor_pos == 3) RELAY4 = !RELAY4;
                }
                while (BT3 == 0);
            }
        }

        delay_ms(50);
    }
}