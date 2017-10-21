#include "reedsolomon.h"
#include <stdio.h>

int main( int argc, char ** argv )
{
    unsigned char message[RS_K];
    unsigned char codeword[RS_N];
    unsigned char noisy[RS_N];
    unsigned char recovered[RS_K];

    int num_trials;
    int trial_index, num_successes;
    int i;

    if( argc != 2 )
    {
        printf("argument count: %i\n", argc);
        printf("usage: ./test_reed_solomon 1337\n");
        return 0;
    }

    num_trials = atoi(argv[1]);

    if( num_trials <= 0 )
    {
        printf("number of trials: %i\n", num_trials);
        printf("usage: ./test_reed_solomon 1337");
        return 0;
    }

    num_successes = 0;
    for( trial_index = 0 ; trial_index < num_trials ; ++trial_index )
    {
        /* create random message */
        for( i = 0 ; i < RS_K ; ++i )
        {
            message[i] = rand() % 256;
        }

        if( num_trials == 1 )
        {
            printf("message: ");
            for( i = 0 ; i < RS_K ; ++i )
                printf("%02x", message[i]);
            printf("\n");
        }

        /* encode message */
        rs_encode(codeword, message);

        if( num_trials == 1 )
        {
            printf("codeword: ");
            for( i = 0 ; i < RS_N ; ++i )
                printf("%02x", codeword[i]);
            printf("\n");
        }

        /* disturb with noise */
        for( i = 0 ; i < RS_N ; ++i )
        {
            noisy[i] = codeword[i];
        }
        for( i = 0 ; i < RS_T ; ++i )
        {
            noisy[rand()%RS_N] = rand()%256;
        }

        if( num_trials == 1 )
        {
            printf("noisy word: ");
            for( i = 0 ; i < RS_N ; ++i )
                printf("%02x", noisy[i]);
            printf("\n");
        }

        /* decode message */
        rs_decode(recovered, noisy);

        if( num_trials == 1 )
        {
            printf("recovered message: ");
            for( i = 0 ; i < RS_K ; ++i )
                printf("%02x", recovered[i]);
            printf("\n");
        }
    }

    return 1;
}

