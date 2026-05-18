#include <stdio.h>
#include <stdint.h>
#include <limits.h>

//Q5.26
#define BITS_DECIMAL 26


double fx2fp(int32_t N, uint8_t n);
int32_t fp2fx(double N, uint8_t n);
int32_t saturation(int32_t a, int32_t b);

void main(void){
    int32_t a = fp2fx(28.4567, BITS_DECIMAL);
    int32_t b = fp2fx(15.78923, BITS_DECIMAL);
    int32_t c = saturation(a, b);

    printf("a(fp->fx) = (28.4567->%d)\n", a);
    printf("b(fp->fx) = (15.78923->%d)\n", b);
    printf("a + b (fp) = %f\n", 28.4567 + 15.78923);
    printf("c = a + b (fx) = %d\n\n", c);
    printf("c->fp = %f\n\n", fx2fp(c, BITS_DECIMAL));

    a = fp2fx(-28.4567, BITS_DECIMAL);
    b = fp2fx(-15.78923, BITS_DECIMAL);
    c = saturation(a, b);

    printf("a(fp->fx) = (-28.4567->%d)\n", a);
    printf("b(fp->fx) = (-15.78923->%d)\n", b);
    printf("a + b (fp) = %f\n", -28.4567 + -15.78923);
    printf("c = a + b (fx) = %d\n\n", c);
    printf("c->fp = %f\n\n", fx2fp(c, BITS_DECIMAL));

    a = fp2fx(28.4567, BITS_DECIMAL);
    b = fp2fx(-15.78923, BITS_DECIMAL);
    c = saturation(a, b);

    printf("a(fp->fx) = (28.4567->%d)\n", a);
    printf("b(fp->fx) = (-15.78923->%d)\n", b);
    printf("a + b (fp) = %f\n", 28.4567 + -15.78923);
    printf("c = a + b (fx) = %d\n\n", c);
    printf("c->fp = %f\n\n", fx2fp(c, BITS_DECIMAL));
}

double fx2fp(int32_t N, uint8_t n){
    return (double)N/(1<<n);
}
int32_t fp2fx(double N, uint8_t n){
    return (int32_t)(N*(1<<n));
}
int32_t saturation(int32_t a, int32_t b){
    int64_t ac = (int64_t)a + (int64_t)b;
    if (ac > INT_MAX) return INT_MAX;
    if (ac < INT_MIN) return INT_MIN;
    return (int32_t)ac;
}