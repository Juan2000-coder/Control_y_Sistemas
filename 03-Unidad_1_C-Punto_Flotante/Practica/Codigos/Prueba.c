#include <stdio.h>
#include <float.h>
#include <math.h>
#include <fenv.h>

void show_fe_exceptions(void)
{
    printf("current exceptions raised: ");
    if(fetestexcept(FE_DIVBYZERO))     printf(" FE_DIVBYZERO");
    if(fetestexcept(FE_INEXACT))       printf(" FE_INEXACT");
    if(fetestexcept(FE_INVALID))       printf(" FE_INVALID");
    if(fetestexcept(FE_OVERFLOW))      printf(" FE_OVERFLOW");
    if(fetestexcept(FE_UNDERFLOW))     printf(" FE_UNDERFLOW");
    if(fetestexcept(FE_DENORMAL))   printf(" FE_DENORMAL");
    if(fetestexcept(FE_ALL_EXCEPT)==0) printf(" none");
    printf("\n");
}

int main(void){
    feclearexcept(FE_ALL_EXCEPT);

    printf("\nGenerando FE_UNDERFLOW...\n");
    printf("%+.10e\n", DBL_MIN/9); // División que produce un número muy cercano a 0
    show_fe_exceptions();
    return 0;
}