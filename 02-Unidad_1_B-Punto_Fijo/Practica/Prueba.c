#include <stdint.h>
#include <stdio.h>

//Q21.10
#define BITS_DECIMAL 22

float fx2fp(int32_t N, uint8_t n);
int32_t fp2fx(float N, uint8_t n);

int32_t saturation(int32_t a, int32_t b);
int32_t truncation(int64_t X, uint8_t n);

void main(void){
    float X = 1.3921, Y = 2.3722;
    printf("Valores en punto flotante\n");
    printf("X = %.10f\n", X);
    printf("Y = %.10f\n", Y);

    int32_t X_fx = fp2fx(X, BITS_DECIMAL);
    int32_t Y_fx = fp2fx(Y, BITS_DECIMAL);

    printf("\nValores en punto fijo\n");
    printf("X_fx = %d\n", X_fx);
    printf("Y_fx = %d\n", Y_fx);

    printf("\nConversion de fx a fp\n");
    printf("X_fx->fp = %.10f\n", fx2fp(X_fx, BITS_DECIMAL));
    printf("Y_fx->fp = %.10f\n", fx2fp(Y_fx, BITS_DECIMAL));

    // Multiplicación de los números en punto fijo con cast a int64_t después
    // de la multiplicación seguido de truncamiento
    int32_t multi1 = truncation(X_fx*(int64_t)Y_fx, BITS_DECIMAL);

    // Multiplicación de los números en punto fijo con cast a int64_t implicito
    // después de la multiplicación seguido de truncamiento
    int32_t multi2 = truncation(X_fx*Y_fx, BITS_DECIMAL);

    // Multiplicación de los números en punto fijo con cast a int64_t de cada uno
    // antes de la multiplicación seguido de truncamiento
    int32_t multi3 = truncation((int64_t)X_fx*(int64_t)Y_fx, BITS_DECIMAL);

    // Multiplicación de los núermos en punto flotante
    printf("\nMultiplicacion de los numeros en punto flotante\n");
    printf("X*Y = %.10f\n", X*Y);

    // Multiplicación de los números en fx->fp
    printf("\nMultiplicacion de los numeros en fx->fp\n");
    printf("Xfx->fp*Yfx->fp = %.10f\n", fx2fp(X_fx, BITS_DECIMAL)*fx2fp(Y_fx, BITS_DECIMAL));

    printf("\nMultiplicacion de los numeros como enteros\n");
    printf("X_fx*Y_fx = %lld\n", (int64_t)(X_fx*Y_fx));
    printf("(int64_t)X_fx*(int64_t)Y_fx = %lld\n", (int64_t)X_fx*(int64_t)Y_fx);
    printf("X_fx*(int64_t)Y_fx = %lld\n", X_fx*(int64_t)Y_fx);

    // Valores en punto flotante
    printf("\nValores en punto flotante\n");
    printf("multi1 = %.10f\n", fx2fp(multi1, BITS_DECIMAL));
    printf("multi2 = %.10f\n", fx2fp(multi2, BITS_DECIMAL));
    printf("multi3 = %.10f\n", fx2fp(multi3, BITS_DECIMAL));

    // Valores como enteros
    printf("\nValores como enteros\n");
    printf("multi1 = %d\n", multi1);
    printf("multi2 = %d\n", multi2);
    printf("multi3 = %d\n", multi3);

    int32_t aux = 13851014;
    printf("aux = %f\n", fx2fp(aux, BITS_DECIMAL));

    /* CONCLUSIONES

    El casteo luego de la multiplicación es equivalente al casteo implicito cuando
    se llama a truncation y da errores en ambos casos debido a OVERFLOW.
    Lo que ocurre es que cuando se utiliza un Qm.n con un n muy grande, el resultado de
    convertir un float (aunque sea pequeño) a punto fijo puede dar un valor entero muy grande,
    que al multiplicarse con otro valor entero grande (resultado de la conversión de otro float),
    da un valor que no cabe en un int32_t. Lo que la computadora hace internamente
    cuando eso ocurre, es directamente quedarse con los 32 bits menos significativos.
    Al castear luego a int64_t, lo único que hace es poner 0 a la izquierda, pero ya se perdió
    la información de los bits más significativos de la multiplicación.

    El resultado da bien cuando se castean explicitamente los valores antes de multiplicar
    o cuando solamente uno de ellos se castea antes de la multiplicación.
    Supongo que cuando se castea uno solo, el otro se castea implicitamente.

    Otra cosa que hay que tener en cuenta es que cuanto se imprimen enteros con printf
    utilizando el modificador de formato %d, se imprime el valor de tipo entero convirtiendolo
    implicitamente a int (4 bytes, 32 bits) por lo tanto, si el valor es mayor a INT32_MAX
    se pierden los bits más significativos y se imprime el decimal correspondiente solo a los
    32 bits menos significativos, que es un valor incorrecto.
    */
}

float fx2fp(int32_t N, uint8_t n){
    return (float)N/(1<<n);
}
int32_t fp2fx(float N, uint8_t n){
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