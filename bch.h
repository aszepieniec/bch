#ifndef BCH_H
#define BCH_H

#include "gf65536x.h"
#include "gf2x.h"

typedef struct
{
    unsigned int n, k, t;
    gf2x generator;
} bch;

#define BCH_FIELD_GEN 0x42bd
bch bch_init( unsigned int n, unsigned int delta );
int bch_destroy( bch codec );
int bch_encode( unsigned char * codeword, bch codec, unsigned char * message );
int bch_interrupted_euclid( gf65536x * sigma, gf65536x * omega, gf65536x syndrome, gf65536x gcap );
int bch_syndrome( gf65536x * syndrome, gf65536x word );
int bch_decode_syndrome( unsigned char * errors, bch codec, gf65536x syndrome );
int bch_decode_error_free( unsigned char * message, bch codec, unsigned char * codeword );
int bch_decode( unsigned char * message, bch codec, unsigned char * codeword );

#endif

