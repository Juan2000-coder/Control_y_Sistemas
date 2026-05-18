#include <stdio.h>
#include <stdint.h>
#include <limits.h>

//Q21.10
#define BITS_DECIMAL 22

double fx2fp(int32_t N, uint8_t n);
int32_t fp2fx(double N, uint8_t n);

int32_t saturation(int32_t a, int32_t b);

int32_t truncation(int64_t X, uint8_t n);
int32_t rounding(int64_t X, uint8_t n);

int32_t MAC_1(int32_t* X, int32_t* Y, uint8_t len, uint8_t n);
int32_t MAC_2(int32_t* X, int32_t* Y, uint8_t len, uint8_t n);


void main(void){
    float X[5] = {1.1, 2.2, 3.3, 4.4, 5.5};
    float Y[5] = {6.6, 7.7, 8.8, 9.9, 10.10};
    double MACfp = 0;

    int32_t X_fx[5];
    int32_t Y_fx[5];

    // Convertir los vectores a punto fijo y multiplicar en fp
    for (uint8_t i = 0; i < 5; i++){
        Y_fx[i] = fp2fx(Y[i], BITS_DECIMAL);
        X_fx[i] = fp2fx(X[i], BITS_DECIMAL);
        MACfp += X[i]*Y[i];
    }

    printf("\nQ21.10\n");
    printf("MACfp = %f\n", MACfp);
    printf("MAC_1(truncar antes de sumar) = %f\n", fx2fp(MAC_1(X_fx, Y_fx, 5, BITS_DECIMAL), BITS_DECIMAL));
    printf("MAC_2(truncar al final) = %f\n\n", fx2fp(MAC_2(X_fx, Y_fx, 5, BITS_DECIMAL), BITS_DECIMAL));

    // MAC_1 funciona bien para este caso en Q21.10
    // Pero cuando pasamos a una representación con n mayor, por ejemplo Q16.15
    // MAC_1 no funciona bien, ya que el producto de los números sin castear a int64_t
    // se desborda. En cambio, MAC_2 funciona bien en ambos casos.

    // Tiene sentido que ocurra este problema cuando se aumenta n, ya que
    // en última instancia esto provoca que se multipliquen enteros con valores más grandes
    // aunque en punto fijo representen lo mismo que antes.
    // Es decir que al aumentar n, mas probable es que se produzca un desborde incluso para
    // multiplicaciones de números flotantes pequeños.

    // Por eso es importante notar que la representación de punto flotante solo esta
    // en la cabeza del programador.

    // Además hay que tener en cuenta que al truncar mientras se suma
    // se van acumulando los errores de las multiplicaciones asi que tendría sentido
    // que MAC_2 sea más preciso.
}
double fx2fp(int32_t N, uint8_t n){
    return (double)N/(1<<n);
}
int32_t fp2fx(double N, uint8_t n){
    return (int32_t)(N*(1<<n));
}
int32_t saturation(int32_t a, int32_t b){
    int64_t ac = (int64_t)a + (int64_t)b;
    if (ac > INT32_MAX) return INT32_MAX;
    if (ac < INT32_MIN) return INT32_MIN;
    return (int32_t)ac;
}
int32_t truncation(int64_t X, uint8_t n){
    return (int32_t)(X>>n);
}
int32_t rounding(int64_t X, uint8_t n){
    return (X + (int64_t)(1<<(n-1))) >> n;
}
int32_t MAC_1(int32_t* X, int32_t* Y, uint8_t len, uint8_t n){
    int32_t acc = 0;
    for (uint8_t i = 0; i < len; i++){
        // Si no se hace la conversión a 64 antes de la multiplicación
        // puede desbordar.
        // Creo que la forma correcta es convirtiendo antes necesariamente
        // a 64 bits.
        acc = saturation(acc, truncation((int64_t)X[i]*(int64_t)Y[i], n));
    }
    return acc;
}
int32_t MAC_2(int32_t* X, int32_t* Y, uint8_t len, uint8_t n){
    int64_t acc = 0;
    for (uint8_t i = 0; i < len; i++){
        acc += (int64_t)X[i]*(int64_t)Y[i];
    }
    return truncation(acc, n);
}