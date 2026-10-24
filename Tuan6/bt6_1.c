#include <io.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>

int keypad[3][3] = {
    {1, 2, 3}, {4, 5, 6}, {7, 8, 9} };
char data[16];

void show_key(char key, char row, char col) {
    lcd_clear(); lcd_gotoxy(0, 0);
    sprintf(data, "KEY:%d", key);
    lcd_puts(data); lcd_gotoxy(0, 1);
    sprintf(data, "R:%d C:%d", row, col);
    lcd_puts(data); }

void button(void) {
    char r;
    for (r = 0; r < 3; r++) {
        if (r == 0) {
            PORTC = 0x30; PORTE = 0x03; PORTD = 0x81; }
        if (r == 1) {
            PORTC = 0x70; PORTE = 0x01; PORTD = 0x81; }
        if (r == 2) {
            PORTC = 0x70; PORTE = 0x03; PORTD = 0x80; }
        delay_us(10);
        if ((PINC & 0x10) == 0) { delay_ms(20);
            if ((PINC & 0x10) == 0) {
                show_key(keypad[r][0], (char)(r + 1), 1);
                while ((PINC & 0x10) == 0) delay_ms(10);
                return; } }
        if ((PINC & 0x20) == 0) { delay_ms(20);
            if ((PINC & 0x20) == 0) {
                show_key(keypad[r][1], (char)(r + 1), 2);
                while ((PINC & 0x20) == 0) delay_ms(10);
                return; } }
        if ((PINE & 0x01) == 0) { delay_ms(20);
            if ((PINE & 0x01) == 0) {
                show_key(keypad[r][2], (char)(r + 1), 3);
                while ((PINE & 0x01) == 0) delay_ms(10);
                return; } } } }

void main(void) {
    lcd_init(16); lcd_clear(); lcd_gotoxy(0, 0);
    lcd_putsf("Press keypad...");
    lcd_gotoxy(0, 1);
    lcd_putsf("Show KEY Row, Col");
    DDRC = 0x40; PORTC = 0x70; DDRE = 0x02;
    PORTE = 0x03; DDRD = 0x81; PORTD = 0x81;
    while (1) {
        button(); }
}