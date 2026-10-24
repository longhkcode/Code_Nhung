/*
 * bt2.c
 *
 * Created: 9/20/2026 8:18:33 AM
 * Author: Admin
 */

#include <io.h>
#include <delay.h>
void main(void)
{
DDRC.3 = 1;
DDRC.2 = 1;
DDRC.1 = 1;
DDRC.0 = 1;
while (1)
    {        
         PORTC.3 = 1;
         delay_ms(1000);
         PORTC.3 = 0;
         delay_ms(1000);
         PORTC.2 = 1; 
         delay_ms(1000); 
         PORTC.2 = 0;
         delay_ms(1000);   
         PORTC.1 = 1; 
         delay_ms(1000);
         PORTC.1 = 0;
         delay_ms(1000);
         PORTC.0 = 1; 
         delay_ms(1000);
         PORTC.0 = 0;
         delay_ms(1000);
    }
}
