#include <stdio.h>

void main(void) {
    signed char a, b, c, d, s1, s2;
	a = 127;
	b = 127;
	c = a + b;
	d = a*b;
	s1 = (-8) >> 2;
	s2 = (-1) >> 5;

    printf("\nsizeof(signed char) = %zu\n", sizeof(signed char));
	printf("sizeof(int) = %zu\n", sizeof(int));
	printf("a = %d\n", a);
	printf("b = %d\n\n", b);
	
	printf("c = a + b = %d\n", c);
	printf("d = a*b  = %d\n", d);
	printf("s1 = (-8) >> 2 = %d\n", s1);
	printf("s2 = (-1) >> 5 = %d\n", s2);
}
