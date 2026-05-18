#include <stdio.h>
#include <stdint.h>
//Q23.8
//Q21.10
//Q2.29

float fx2fp(int32_t N, uint8_t n);
int32_t fp2fx(float N, uint8_t n);

void main(void){
    float b;
    b = fx2fp(fp2fx(2.4515, 8), 8);
    printf("Con Q23.8: %f\n", b);
    b = fx2fp(fp2fx(2.4515, 10), 10);
    printf("Con Q21.10: %f\n", b);
    b = fx2fp(fp2fx(2.4515, 29), 29);
    printf("Con Q2.29: %f\n", b);
}
float fx2fp(int32_t N, uint8_t n){
    return (float)N/(1<<n);
}
int32_t fp2fx(float N, uint8_t n){
    return (int32_t)(N*(1<<n));
}