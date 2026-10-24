#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <font5x7.h>

flash unsigned char font8x10_VN[][10] = {
    {0x38, 0x44, 0x00, 0x38, 0x44, 0x82, 0xFE, 0x82, 0x82, 0x00},
    {0x10, 0x28, 0x00, 0x38, 0x44, 0x82, 0xFE, 0x82, 0x82, 0x00},
    {0x10, 0x28, 0x00, 0xFE, 0x80, 0xF8, 0x80, 0x80, 0xFE, 0x00},
    {0x10, 0x28, 0x00, 0x3C, 0x42, 0x81, 0x81, 0x81, 0x3C, 0x00},
    {0xFC, 0x82, 0x82, 0xFE, 0x82, 0x82, 0x82, 0x82, 0xFC, 0x00}
};

void draw_char8x10(unsigned char x, unsigned char y, flash unsigned char *char_map) {
    unsigned char row, col;
    for (row = 0; row < 10; row++) {
        for (col = 0; col < 8; col++) {
            if (char_map[row] & (0x80 >> col)) {
                glcd_setpixel(x + col, y + row);
            }
        }
    }
}

void main(void) {
    GLCDINIT_t glcd_init_data;
    unsigned char i;

    DDRD = 0x80;
    PORTD = 0x80;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 80;
    glcd_init_data.bias = 3;
    glcd_init_data.vlcd = 50;

    glcd_init(&glcd_init_data);
    glcd_clear();

    for (i = 0; i < 5; i++) {
        draw_char8x10(10 + i * 12, 18, font8x10_VN[i]);
    }

    while (1) { }
}
