#include "bch.h"
#include "csprng.h"
#include <stdio.h>
#include <stdlib.h>

int test_generator( csprng * rng )
{
    bch codec;

    int n, delta;

    delta = 10 + (csprng_generate_ulong(rng) % 1000);
    n = 16*delta + 10 + (csprng_generate_ulong(rng) % 100);

    printf("testing bch codec generation with n = %i and delta = %i ... ", n, delta);

    codec = bch_init(n, delta);

    if( codec.k > 0 )
    {
        printf("success, with generator = "); gf2x_print(codec.generator); printf(" and k = %i.\n", codec.k);
    }
    else
    {
        printf("failure: k < 0\n");
    }

    bch_destroy(codec);

    return 1;

}

int main( int argc, char ** argv )
{

    unsigned int random;
    int i;
    int success;
    csprng rng;

    random = 42;

    printf("Running series of tests with randomness %u ...\n", random);

    csprng_init(&rng);
    csprng_seed(&rng, sizeof(unsigned int), (unsigned char*)(&random));

    success = 1;
    for( i = 0 ; i < 1 ; ++i ) success &= test_generator(&rng);

    if( success == 1 )
    {
        printf("success.\n");
        return 1;
    }
    else
    {
        printf("failure.\n");
        return 0;
    }
}

