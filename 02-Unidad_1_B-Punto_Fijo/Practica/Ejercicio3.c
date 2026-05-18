#include <stdio.h>
#include <stdint.h>
//Q21.10

int32_t truncation(int64_t X, uint8_t n);
int32_t rounding(int64_t X, uint8_t n);
double fx2fp(int32_t N, uint8_t n);
int32_t fp2fx(double N, uint8_t n);

void main(void){
    double x1fp = -3.65301;
    double x2fp = 2.7430;

    uint8_t n = 10;

    int32_t x1fx = fp2fx(x1fp, n);
    int32_t x2fx = fp2fx(x2fp, n);

    int32_t rt = truncation(x1fx*x2fx, n);
    int32_t rr = rounding(x1fx*x2fx, n);

    printf("x1(fp): %f\n", x1fp);
    printf("x2(fp): %f\n\n", x2fp);

    printf("x1(fx): %d\n", x1fx);
    printf("x2(fx): %d\n\n", x2fx);

    printf("x1(fx->fp): %f\n", fx2fp(x1fx, n));
    printf("x2(fx->fp): %f\n\n", fx2fp(x2fx, n));

    printf("Truncation: %f\n", fx2fp(rt, n));
    printf("Rounding: %f\n", fx2fp(rr, n));
    printf("Double: %f\n", x1fp*x2fp);
}

double fx2fp(int32_t N, uint8_t n){
    return (double)N/(1<<n);
}
int32_t fp2fx(double N, uint8_t n){
    return (int32_t)(N*(1<<n));
}
int32_t truncation(int64_t X, uint8_t n){
    return (int32_t)(X>>n);
}
int32_t rounding(int64_t X, uint8_t n){
    return truncation(X + (int64_t)(1<<(n-1)), n);
}