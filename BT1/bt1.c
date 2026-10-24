/*
 * bt1.c
 * viet chuong trình bat den led xanh la cay ket noi PD5
 phân tích bài toán
 tra bang 1.2 -> LED_G noi chan 30 ki hieu : PD5 (PORT D, bit 5)
 De LED sang , du lieu phai di tu chip ra PD5 vào LED  => la output
 De PD5 la output -> DDR tai PD5 = 1  
 Do LED noi katot vao GND -> LED sang thi phai tac dong output logic HIGH = "1" -> Dien ap = "+5V"   (hình 1.5)
 De tac dong ta ghi "DDRD.5 = 1;"
 DDRD.5 la tac dong thanh ghi DDR vao Port D tai bit 5 (tac dong truc tiep)
 !Chu y : con cach khac tac dong len toan bo Port 
 */ 
#include <io.h>
#include <delay.h>
void main(void)
{
DDRD.4 = 1;
DDRD.5 = 1;
DDRD.6 = 1;
DDRD.7 = 1;
PORTD.7 = 1;
while (1)
    { 
         PORTD.4 = 1;
         delay_ms(1000);
         PORTD.4 = 0;
         delay_ms(1000);
         PORTD.5 = 1; 
         delay_ms(1000); 
         PORTD.5 = 0;
         delay_ms(1000);   
         PORTD.6 = 1; 
         delay_ms(1000);
         PORTD.6 = 0;
         delay_ms(1000);
    }
}
