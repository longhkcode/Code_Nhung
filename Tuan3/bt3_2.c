/*
 * bai3-2.c
 *
 * Created: 26/09/2026 7:17:06 CH
 * Author: Owner
 */

#include <io.h>
#include <delay.h>
#include <mega128.h>

int cnt = 0;

void io_init(void)
{
    DDRF = 0xFF;
    DDRD = 0xFF;
    DDRA = 0xFF;

    DDRB = 0x00;
    PORTB = 0x0D;
}

void hienthi(int i, unsigned char select_mask)
{
    PORTF &= 0x00;
    PORTA &= 0x7F;
    PORTD &= 0xF1;
    if (i == 0)
    {
        PORTF = 0x26 | select_mask; 
        PORTA = 0x80;
        PORTD = 0x06;
    }
    else if (i == 1)
    {
        PORTF = 0x20 | select_mask; 
        PORTA = 0x80;
        PORTD = 0x00;
    }
    else if (i == 2)
    {
        PORTF = 0x22 | select_mask; 
        PORTA = 0x00;
        PORTD = 0x0E;        
    }
    else if (i == 3)
    {
        PORTF = 0x22 | select_mask;  
        PORTA = 0x80;
        PORTD = 0x0A;     
    }
    else if (i == 4)
    {
        PORTF = 0x24 | select_mask;
        PORTA = 0x80;
        PORTD = 0x08;        
    }
    else if (i == 5)
    {
        PORTF = 0x06 | select_mask;
        PORTA = 0x80;
        PORTD = 0x0A;       
    }
    else if (i == 6)
    {
        PORTF = 0x06 | select_mask;
        PORTD = 0x0E;
        PORTA = 0x80;
    }
    else if (i == 7)
    {
        PORTF = 0x22 | select_mask; 
        PORTA = 0x80;
        PORTD = 0x00;        
    }
    else if (i == 8)
    {
        PORTF = 0x26 | select_mask;
        PORTA = 0x80;
        PORTD = 0x0E;       
    }
    else if (i == 9)
    {
        PORTF = 0x26 | select_mask;
        PORTA = 0x80;
        PORTD = 0x0A;        
    }
}

void refreshDisplay()
{
    hienthi(cnt / 10, 0x58);
    delay_ms(5);
    hienthi(cnt % 10, 0x51);
    delay_ms(5);
}

void main(void)
{
    io_init();
    while (1)
    {
        // Please write your application code here
        if (PINB.2 == 0)
        {
            delay_ms(20);
            if (PINB.2 == 0)
            {
                if (cnt < 99)
                {
                    cnt++;
                }
                while (PINB.2 == 0)
                    ;
                refreshDisplay();
            }
        }
        if (PINB.3 == 0)
        {
            delay_ms(20);
            if (PINB.3 == 0)
            {
                if (cnt > 0)
                {
                    cnt--;
                }
                while (PINB.3 == 0)
                    ;
                refreshDisplay();
            }
        }
        if (PINB.0 == 0)
        {
            delay_ms(20);
            if (PINB.0 == 0)
            {
                cnt = 0;
                while (PINB.0 == 0)
                    ;
                refreshDisplay();
            }
        }
        refreshDisplay();
    }
}