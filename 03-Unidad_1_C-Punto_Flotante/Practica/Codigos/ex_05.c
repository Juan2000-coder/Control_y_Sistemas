#include <stdio.h>
#include <float.h>
#include <math.h>
#include <signal.h>
#include <stdlib.h>
#include <fenv.h>

// Función para mostrar las excepciones de punto flotante activadas
void show_fe_exceptions(void) {
    printf("Current exceptions raised: ");
    if (fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if (fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if (fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if (fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if (fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if (fetestexcept(FE_ALL_EXCEPT) == 0) printf(" none");
    printf("\n");
}

int main(void) {
    // Limpia todas las excepciones previas
    feclearexcept(FE_ALL_EXCEPT);

    printf("** Generando excepciones de punto flotante **\n");

    // 1. Generar FE_DIVBYZERO (División por cero)
    printf("\nGenerando FE_DIVBYZERO...\n");
    printf("%f\n", 1.0 / 0.0); // División por cero
    show_fe_exceptions();

    // Limpia las excepciones antes de la siguiente operación
    feclearexcept(FE_ALL_EXCEPT);

    // 2. Generar FE_INVALID (Operación inválida)
    printf("\nGenerando FE_INVALID...\n");
    printf("%f\n",sqrt(-1.0)); // Raíz cuadrada de un número negativo
    show_fe_exceptions();

    // Limpia las excepciones antes de la siguiente operación
    feclearexcept(FE_ALL_EXCEPT);

    // 3. Generar FE_OVERFLOW (Desbordamiento)
    printf("\nGenerando FE_OVERFLOW...\n");
    printf("%lf\n", 1e308 * 1e308); // Multiplicación que excede el rango de un double
    show_fe_exceptions();

    // Limpia las excepciones antes de la siguiente operación
    feclearexcept(FE_ALL_EXCEPT);

    // 4. Generar FE_UNDERFLOW (Subdesbordamiento)
    printf("\nGenerando FE_UNDERFLOW...\n");
    printf("%lf\n", 1e-308 / 1e308); // División que produce un número muy cercano a 0
    show_fe_exceptions();

    // Limpia las excepciones antes de la siguiente operación
    feclearexcept(FE_ALL_EXCEPT);

    // 5. Generar FE_INEXACT (Resultado inexacto)
    printf("\nGenerando FE_INEXACT...\n");
    printf("%f\n", 10.0 / 3.0); // División que produce un resultado inexacto
    show_fe_exceptions();

    printf("\nGenerando 0.0/0.0...\n");
    printf("%f\n", 0.0 / 0.0); // División que produce un resultado inexacto
    show_fe_exceptions();

    return 0;
}