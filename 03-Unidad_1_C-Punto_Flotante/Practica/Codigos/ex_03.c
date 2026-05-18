#include <stdio.h>
#include <math.h> // Para funciones matemáticas como nan()

int main(void) {
    // Inicialización de valores especiales
    double nan_value = nan("");       // NaN
    double nan_macro = NAN;

    double pos_inf = 1.0 / 0.0;         // Infinito positivo
    double neg_inf = -1.0 / 0.0;        // Infinito negativo

    float pos_inf_macro = INFINITY;     // Infinito positivo con macro
    float neg_inf_macro = -INFINITY;    // Infinito negativo con macro

    double pos_inf_hugeval = HUGE_VAL;  // Infinito positivo con macro
    double neg_inf_hugeval = -HUGE_VAL; // Infinito negativo con macro

    float pos_inf_hugevalf = HUGE_VALF;  // Infinito positivo con macro
    float neg_inf_hugevalf = -HUGE_VALF; // Infinito negativo con macro

    // Producción de valores especiales mediante operaciones
    double nan_from_operation = 0.0 / 0.0; // Operación inválida que genera NaN
    // Imprimir los valores especiales
    printf("Valores especiales en punto flotante:\n");
    printf("NaN (Not a Number): %lf\n", nan_value);
    printf("NaN (Not a Number) con macro: %lf\n", nan_macro);

    printf("Inf (Infinito positivo): %lf\n", pos_inf);
    printf("-Inf (Infinito negativo): %lf\n", neg_inf);

    printf("Inf (Infinito positivo) con macro: %f\n", pos_inf_macro);
    printf("-Inf (Infinito negativo) con macro: %f\n", neg_inf_macro);

    printf("Inf (Infinito positivo) con macro HUGE_VAL: %lf\n", pos_inf_hugeval);
    printf("-Inf (Infinito negativo) con macro HUGE_VAL: %lf\n", neg_inf_hugeval);

    printf("Inf (Infinito positivo) con macro HUGE_VALF: %f\n", pos_inf_hugevalf);
    printf("-Inf (Infinito negativo) con macro HUGE_VALF: %f\n", neg_inf_hugevalf);

    printf("NaN generado por operacion: %lf\n", nan_from_operation);

    // Verificar si los valores son especiales
    printf("\nVerificaciones:\n");
    printf("nan_value es NaN: %s\n", isnan(nan_value) ? "Si" : "No");
    printf("nan_macro es NaN: %s\n", isnan(nan_macro) ? "Si" : "No");

    printf("pos_inf es infinito: %s\n", isinf(pos_inf) ? "Si" : "No");
    printf("neg_inf es infinito: %s\n", isinf(neg_inf) ? "Si" : "No");

    printf("pos_inf_macro es infinito: %s\n", isinf(pos_inf_macro) ? "Si" : "No");
    printf("neg_inf_macro es infinito: %s\n", isinf(neg_inf_macro) ? "Si" : "No");

    printf("pos_inf_hugeval es infinito: %s\n", isinf(pos_inf_hugeval) ? "Si" : "No");
    printf("neg_inf_hugeval es infinito: %s\n", isinf(neg_inf_hugeval) ? "Si" : "No");

    printf("pos_inf_hugevalf es infinito: %s\n", isinf(pos_inf_hugevalf) ? "Si" : "No");
    printf("neg_inf_hugevalf es infinito: %s\n", isinf(neg_inf_hugevalf) ? "Si" : "No");

    printf("nan_from_operation es NaN: %s\n", isnan(nan_from_operation) ? "Si" : "No");

    return 0;
}