#ifndef BCH_H
#define BCH_H

#include "gf16777216x.h"
#include "gf2x.h"

typedef struct
{
    unsigned int n, k, t;
    gf2x generator;
} bch;

#define BCH_FIELD_GEN 0x42bd7e
int bch_minpoly( gf2x * poly, unsigned int field_element );
bch bch_init( unsigned int n, unsigned int delta );
int bch_destroy( bch codec );
int bch_encode( unsigned char * codeword, bch codec, unsigned char * message );
int bch_interrupted_euclid( gf167772167x * sigma, gf16777216x * omega, gf16777216x syndrome, gf16777216x gcap );
int bch_syndrome( gf16777216x * syndrome, gf16777216x word );
int bch_decode_syndrome( unsigned char * errors, bch codec, gf16777216x syndrome );
int bch_decode_error_free( unsigned char * message, bch codec, unsigned char * codeword );
int bch_decode( unsigned char * message, bch codec, unsigned char * codeword );

#endif

