#include <stdlib.h>
#include "bch.h"

/**
 * bch_init
 * Create a BCH codec object, including generator polynomial and
 * parameters inferred from n and delta. (Subject to m=24).
 */
bch bch_init( unsigned int n, unsigned int delta )
{
    int i, j;
    gf2x * list;
    gf2x * dest_list;
    gf2x * temp_ptr;
    gf2x temp, modulus;
    unsigned int elm;
    unsigned int list_size, dest_list_size;
    bch codec;

    /* populate list */
    list_size = 0;
    list = malloc(sizeof(gf2x)*delta);
    elm = 1;
    temp = gf2x_init(15);
    modulus = gf2x_init(16);
    modulus.degree = 16;
    modulus.data[0] = 0x01;
    modulus.data[1] = 0xe0;
    modulus.data[2] = 0x01;
    for( i = 0 ; i < delta-1 ; ++i )
    {
        elm = gf65536_multiply(elm, BCH_FIELD_GEN);
        temp.data[0] = elm & 0xff;
        temp.data[1] = (elm & 0xff00) >> 8;
        temp.degree = 15;
        gf2x_trim(&temp);
        list[i] = gf2x_init(0);
        gf2x_minpoly(&list[i], temp, modulus);
    }
    list_size = delta-1;
    gf2x_destroy(temp);
    gf2x_destroy(modulus);

    /* collapse list */
    dest_list = malloc(sizeof(gf2x)*(list_size / 2 + 1));
    while( list_size != 1 )
    {
        dest_list_size = 0;
        for( i = list_size ; i > 1 ; i -= 2 )
        {
            dest_list[dest_list_size] = gf2x_init(0);
            gf2x_lcm(&dest_list[dest_list_size], list[i-2], list[i-1]);
            dest_list_size += 1;
            gf2x_destroy(list[i-1]);
            gf2x_destroy(list[i-2]);
        }
        if( i == 1 )
        {
            dest_list[dest_list_size] = gf2x_init(0);
            gf2x_copy(&dest_list[dest_list_size], list[0]);
            gf2x_destroy(list[0]);
            dest_list_size += 1;
        }
        
        list_size = dest_list_size;
        temp_ptr = list;
        list = dest_list;
        dest_list = temp_ptr;
    }
    free(dest_list);
    codec.generator = list[0];
    free(list);

    /* infer remaining parameters */
    codec.n = n;
    codec.t = (delta-1)/2;
    codec.k = n - codec.generator.degree;

    return codec;
}

/**
 * bch_destroy
 * Deallocate memory reserved for the codec object.
 */
int bch_destroy( bch codec )
{
    gf2x_destroy(codec.generator);
    return 1;
}

int bch_encode( unsigned char * codeword, bch codec, unsigned char * message );
int bch_interrupted_euclid( gf65536x * sigma, gf65536x * omega, gf65536x syndrome, gf65536x gcap );
int bch_syndrome( gf65536x * syndrome, gf65536x word );
int bch_decode_syndrome( unsigned char * errors, bch codec, gf65536x syndrome );
int bch_decode_error_free( unsigned char * message, bch codec, unsigned char * codeword );
int bch_decode( unsigned char * message, bch codec, unsigned char * codeword );

