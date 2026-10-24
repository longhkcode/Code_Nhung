#include <io.h>
#include <alcd.h>
#include <delay.h>
void show_text(void){
    lcd_clear();
    lcd_gotoxy(0,0); lcd_puts("Hello");     // dua tro ve 00 và in hello
    lcd_gotoxy(0,1); lcd_puts("Bai 4");     // dua tro ve 01 va in bai 4
}
void main(void)
{
    unsigned char i;
    DDRD = 0x80; PORTD = 0x80;
    lcd_init(16);  // khoi tao man hinh lcd 16 ki tu
    lcd_clear();   // xoa man hinh ban dau
    for (i = 0;i<2;i++){
        show_text(); delay_ms(1000);
        lcd_clear(); delay_ms(1000);
    }
    show_text();
    while (1){}
}
