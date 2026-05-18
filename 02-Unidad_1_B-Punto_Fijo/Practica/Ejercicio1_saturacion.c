#include <stdio.h>
#include <stdint.h>

signed char saturate(int16_t x);

int main() {
    signed char a, b, c, d, s1, s2;
    a = 127;
    b = 127;
    
    int16_t ac = a + b;

    c  = saturate(ac);
    ac = a*b;
    d  = saturate(ac);

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

signed char saturate(int16_t x){
    if (x > 127) return 127;
    if (x < -128) return -128;
    return x;
}
