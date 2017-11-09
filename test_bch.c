#include "bch.h"
#include "csprng.h"

int test_minpoly( unsigned int * randomness )
{
    csprng rng;
    unsigned int element;
    gf2x poly;

    csprng_init(&rng);
    csprng_seed(&rng, sizeof(unsigned int), (unsigned char *)randomness);
    *randomness = csprng_generate_ulong(&rng);

    element = csprng_generate_ulong(&rng) & 0xffffff;

    printf("testing minpoly.\n");

    poly = gf2x_init(0);
    
    bch_minpoly(&poly, element);

    printf("element: %06x\n", element);
    printf("minimal poly: "); gf2x_print(poly); printf("\n");

    gf2x_destroy(poly);

    return 1;

}

