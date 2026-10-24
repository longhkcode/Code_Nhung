#include <mega128.h>
#include <delay.h>
#include <stdio.h>
#include <alcd.h>

#define BT_1 PINB.2
#define BT_2 PINB.3
#define BT_3 PINB.0  

#define RELAY_1 PORTC.3
#define RELAY_2 PORTC.2
#define RELAY_3 PORTC.1
#define RELAY_4 PORTC.0

eeprom unsigned int threshold_ee;

char buf[17];
unsigned int current_adc, adc_dark = 0, adc_light = 0, threshold = 512;
bit monitor_mode = 0;

// Hàm d?c ADC co b?n t? kênh ch? d?nh
unsigned int read_adc(unsigned char adc_input) {
    ADMUX = (adc_input & 0x1F) | 0x40;
    delay_us(10);
    ADCSRA |= 0x40;
    while ((ADCSRA & 0x10) == 0);
    ADCSRA |= 0x10;
    return ADCW;
}

// Hàm d?c ADC 10 l?n và l?y trung bình d? ch?ng nhi?u
unsigned int read_adc_avg(unsigned char adc_input) {
    unsigned long sum = 0;
    unsigned char i;
    for (i = 0; i < 10; i++) {
        sum += read_adc(adc_input);
        delay_ms(10); // Ð? tr? gi?a các l?n d?c
    }
    return (unsigned int)(sum / 10);
}

void role_off(void) {
    RELAY_1 = 0; 
    RELAY_2 = 0; 
    RELAY_3 = 0; 
    RELAY_4 = 0;
}

void role_on(void) {
    RELAY_1 = 1; delay_ms(200);
    RELAY_2 = 1; delay_ms(200);
    RELAY_3 = 1; delay_ms(200);
    RELAY_4 = 1; delay_ms(200);
}

void main(void) {
    DDRC = 0x0F; 
    PORTC = 0x00; 
    
    DDRB = 0x00;
    PORTB = 0x1C; // C?u hình di?n tr? kéo lên cho PB2, PB3, PB4 (BT_1, BT_2, BT_3)
    
    DDRD = 0x80; 
    PORTD = 0x80;
    
    ADMUX = 0x40; 
    ADCSRA = 0x87; 
    SFIOR = 0x00;

    lcd_init(16); 
    lcd_clear();

    // Ð?c giá tr? ngu?ng dã luu s?n trong EEPROM (n?u có)
    threshold = threshold_ee;
    if (threshold == 0xFFFF || threshold == 0) {
        threshold = 500; // Ngu?ng m?c d?nh an toàn n?u EEPROM tr?ng
    }

    // Hi?n th? hu?ng d?n ban d?u
    lcd_gotoxy(0, 0); 
    lcd_puts("BT1:Toi | BT2:Sang");
    lcd_gotoxy(0, 1); 
    lcd_puts("BT3: Giam Sat");

    while (1) {
        // --- 1. NH?N NÚT 1: Ð?c 10 l?n trong di?u ki?n T?I ---
        if (BT_1 == 0) {
            delay_ms(20);
            if (BT_1 == 0) {
                monitor_mode = 0;
                role_off();
                
                lcd_clear();
                lcd_gotoxy(0, 0); 
                lcd_puts("Dang doc 10x TOI");
                
                adc_dark = read_adc_avg(7); // Ð?c kênh ADC 7
                
                lcd_clear();
                lcd_gotoxy(0, 0); 
                lcd_puts("ADC TOI (Avg):");
                sprintf(buf, "%4u", adc_dark);
                lcd_gotoxy(0, 1); 
                lcd_puts(buf);
                
                while (BT_1 == 0); // Ch? nh? nút
            }
        }

        // --- 2. NH?N NÚT 2: Ð?c 10 l?n trong di?u ki?n SÁNG & Tính ngu?ng ---
        if (BT_2 == 0) {
            delay_ms(20);
            if (BT_2 == 0) {
                monitor_mode = 0;
                role_off();
                
                lcd_clear();
                lcd_gotoxy(0, 0); 
                lcd_puts("Dang doc 10x SANG");
                
                adc_light = read_adc_avg(7); // Ð?c kênh ADC 7
                
                // Tính ngu?ng trung bình và ghi vào EEPROM
                threshold = (adc_dark + adc_light) / 2;
                threshold_ee = threshold;
                
                lcd_clear();
                lcd_gotoxy(0, 0); 
                lcd_puts("NGUONG MOI (EE):");
                sprintf(buf, "%4u", threshold);
                lcd_gotoxy(0, 1); 
                lcd_puts(buf);
                
                while (BT_2 == 0); // Ch? nh? nút
            }
        }

        // --- 3. NH?N NÚT 3: Chuy?n sang ch? d? giám sát liên t?c ---
        if (BT_3 == 0) {
            delay_ms(20);
            if (BT_3 == 0) {
                monitor_mode = !monitor_mode;
                if (!monitor_mode) role_off();
                
                lcd_clear();
                lcd_gotoxy(0, 0);
                lcd_puts(monitor_mode ? "GIAM SAT: ON" : "GIAM SAT: OFF");
                delay_ms(800);
                
                lcd_clear();
                lcd_gotoxy(0, 0);
                sprintf(buf, "Th: %u", threshold);
                lcd_puts(buf);
                
                while (BT_3 == 0); // Ch? nh? nút
            }
        }

        // --- CH? Ð? GIÁM SÁT LIÊN T?C (Khi b?t BT_3) ---
        if (monitor_mode) {
            current_adc = read_adc(7);
            
            // So sánh v?i ngu?ng: N?u ADC nh? hon ngu?ng (t?i) thì b?t ro-le, ngu?c l?i t?t
            if (current_adc < threshold) {
                role_on();
            } else {
                role_off();
            }

            lcd_gotoxy(0, 1);
            sprintf(buf, "ADC:%4u %s", current_adc, (current_adc < threshold) ? "TOI " : "SANG");
            lcd_puts(buf);
            
            delay_ms(200);
        }
    }
}