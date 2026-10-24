#include <io.h>
#include <glcd.h>
#include <delay.h>
#include <font5x7.h>

#define BT1 PINB.0

void draw_fill_rect(unsigned char x1, unsigned char y1, unsigned char x2, unsigned char y2) {
    unsigned char y;
    for (y = y1; y <= y2; y++) {
        glcd_line(x1, y, x2, y);
    }
}

void main(void) {
    GLCDINIT_t glcd_init_data;
    unsigned char percent = 0;
    int fill_w;

    DDRB = 0x00;
    PORTB = 0x01;

    glcd_init_data.font = font5x7;
    glcd_init_data.temp_coef = 80;
    glcd_init_data.bias = 3;
    glcd_init_data.vlcd = 50;
    glcd_init(&glcd_init_data);

    while (1) {
        glcd_clear();

        glcd_rectangle(10, 18, 74, 30);

        if (percent > 0) {
            fill_w = (int)(percent * 62) / 100;
            draw_fill_rect(11, 19, 11 + fill_w, 29);
        }

        if (percent >= 100) {
            glcd_outtextxy(16, 34, "complete!");
        }

        if (BT1 == 0) {
            delay_ms(20);
            if (BT1 == 0) {
                if (percent < 100) {
                    percent += 10;
                }
                while (BT1 == 0);
            }
        }

        delay_ms(30);
    }
}