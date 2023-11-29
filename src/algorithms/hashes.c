#include <string.h>
#include <limits.h>
#include <stdlib.h>

unsigned int rolling_hash(const char *n) {
    unsigned int hash = 0;
    unsigned int curr_pow = 1;
    for (unsigned long i = 0; i < strlen(n); i++) {
        hash += n[i] * curr_pow;
        curr_pow *= 7919;
    }
    return hash;
}

unsigned int tent_map_hash(const char *n) {
    unsigned int hash = rolling_hash(n);
    int iterations = 53;
    for (int i = iterations; i > 0; i--) {
        if (hash < UINT_MAX / 2) {
            hash = 2 * hash;
        } else {
            hash = 2 * (UINT_MAX - hash);
        }
    }
    return hash;
}

unsigned int dyadic_map_hash(const char *n) {
    unsigned int hash = rolling_hash(n);
    int iterations = 53;
    for (int i = iterations; i > 0; i--) {
        if (hash < UINT_MAX / 2) {
            hash = 2 * hash;
        } else {
            hash = 2 * (hash - UINT_MAX / 2);
        }
    }
    return hash;
}

unsigned int multi_state_hash(const char *n) {
    unsigned short a = 1, b = 1, c = 1, d = 1;
    int input_length = strlen(n);
    int padded_length = ((input_length / 32) + 1) * 32;
    char *padded_input = malloc(padded_length * sizeof(char));
    memset(padded_input, 0, padded_length);
    strcpy(padded_input, n);
    unsigned int scale_factor = 32;
    for (int i = scale_factor * padded_length; i > 0; i--) {
        a += ((unsigned short *)padded_input)[i / scale_factor];
        if (a < USHRT_MAX / 2) {
            a = 2 * a;
        } else {
            a = 2 * (USHRT_MAX - a);
        }
        unsigned short temp = d;
        d = c;
        c = b;
        b = a;
        a = temp;
    }
    free(padded_input);
    unsigned int hash = (a << 24) + (b << 16) + (c << 8) + d;
    return hash;
}
