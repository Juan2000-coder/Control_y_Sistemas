#include <stdio.h>
#include <stdint.h>

int main() {
    signed char a, b, s1, s2;
	a = 127;
	b = 127;

    int16_t c = a + b;
    int16_t d = a*b;

	s1 = (-8) >> 2;
	s2 = (-1) >> 5;

    printf("\nsizeof(signed char) = %zu\n", sizeof(signed char));
	printf("a = %d\n", a);
	printf("b = %d\n\n", b);
	
	printf("c = a + b = %d\n", c);
	printf("d = a*b  = %d\n", d);
	printf("s1 = (-8) >> 2 = %d\n", s1);
	printf("s2 = (-1) >> 5 = %d\n", s2);

    return 0;
}
