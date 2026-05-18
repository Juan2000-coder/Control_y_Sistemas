// Version: 002
// Date:    2022/04/05
// Author:  Rodrigo Gonzalez <rodralez@frm.utn.edu.ar>

// Compile usando el siguiente comando
// compile: gcc -Wall -std=c99 ex_01.c -o ex_01

#include <stdio.h>
#include <float.h> // Platform dependant
// Define una serie de macros o constantes asociados a los datos de tipo flotante
// como float, double, long double. Estas macros son para definir por ejemplo los valores máximos
// los valores mínimos, la precisión, etc.

// Ejemplos de esto son:
// FLT_MIN: Valor mínimo de un float
// FLT_MAX: Valor máximo de un float
// FLT_EPSILON: Precisión de un float
// DBL_MIN: Valor mínimo de un double
// DBL_MAX: Valor máximo de un double
// DBL_EPSILON: Precisión de un double...


#include <math.h>
#include <fenv.h>  // Floating Point Enviroment.
// Maneja flags de estado de excepciones asociadas a las operaciones en números de punto flotante.
// Estas excepciones son: división por cero, overflow, underflow, inexacto, inválido, etc.
// Algunos ejemplos de las banderas de excepción son:
// FE_DIVBYZERO: División por cero
// FE_OVERFLOW: Overflow
// FE_UNDERFLOW: Underflow

// Además maneja banderas para control de operaciones como redondeo, precisión, etc.
// El estado de las banderas de estado puede afectar el resultado de las operaciones
// en punto flotante, así como también lo hacen las banderas de control de operaciones.
// Algunos ejemplos son:
// feclearexcept(FE_ALL_EXCEPT): Limpia todas las banderas de excepción.
// feraiseexcept(FE_ALL_EXCEPT): Activa todas las banderas de excepción.


// typedef long int int64_t; // en mi computadora long int es de 4 bytes
typedef long long int int64_t; // long long int es de 8 bytes

/*
#define PRINT_TYPE(var) _Generic((var), \
    int: "int", \
    float: "float", \
    double: "double", \
    char*: "char*", \
    default: "unknown")
*/
int main(void)
{	
	float a, b, c, f1, f2;
	double d1;

	a = 1000000000.0;	// mil millones
	b =   20000000.0;	// 20 millones
	c =   20000000.0;

	
	f1 = (a * b) * c;	// Genera error por exceso
	f2 = a * (b * c);	// Genera error por defecto

	d1 = (double) (a) * (double) (b) * (double) (c);

	printf("\na = 1000 millon = %f \n", a );
	printf("b = 20 millon = %f \n", b );
	printf("c = 20 millon = %f \n", c );

	printf("\nf1 = (a*b)*c = %lf \n", f1 );
	printf("f2 = a*(b*c) = %lf \n", f2 );
	printf("d1 = a*b*c = %lf \n", d1 );

	printf("\n40e23 = %lf\n", 400000000000000000000000.0);
	
	//printf("\nEl tipo de 400000000000000000000000.0 es: %s\n", PRINT_TYPE(400000000000000000000000.0));
	printf("\nError en f1 = %10e \n", f1 - 400000000000000000000000.0 );
	printf("Error en f2 = %10e \n", f2 - 400000000000000000000000.0 );
	printf("Error en d1 = %20e \n", d1 - 400000000000000000000000.0 );

	double acum_1;
	float acum_2;
	
	acum_1 = 0.0;
	for (int64_t i = 0; i < 10000000; i++){ acum_1 += 0.01; } 

	acum_2 = 0.0;
	b = 0.333;
	for (int64_t i = 0; i < 100000000; i++){ acum_2 += b / b; }
	
	printf("\nacum_1 = %f \n", acum_1 );
	printf("acum_2 = %f \n", acum_2 );
	
	printf("\nError en acum_1 = %10e \n", acum_1 - (100000.0));
	printf("Error en acum_2 = %10e \n\n", acum_2 - (100000000.0));
	
	return 0;
}
