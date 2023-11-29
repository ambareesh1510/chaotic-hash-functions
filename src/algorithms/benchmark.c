#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <string.h>

#define NUM_TESTS 100000

int comparator(const void *a, const void *b) {
    int x = *(const int *)a;
    int y = *(const int *)b;
    return (x > y) - (x < y);
}

void benchmark(const char *name, unsigned int (*hash)(const char *)) {
    srand(time(NULL));
    // srandom(19999);

    unsigned int hashes[NUM_TESTS];
    int deviations[NUM_TESTS];

    FILE *benchmark_data;
    benchmark_data = fopen(name, "w");

    for (int i = 0; i < NUM_TESTS; i++) {
        // Generate hash distribution
        unsigned int test_string_length = 
            (unsigned long long) rand() * 128 / RAND_MAX;

        char *new_test_string = malloc(test_string_length + 1);

        for (int j = 0; j < test_string_length; j++) {
            new_test_string[j] =
                (unsigned long long) rand() * (126 - 32) / RAND_MAX + 32;
        }

        hashes[i] = hash(new_test_string);


        // Generate deviation distribution
        unsigned int random_modification =
            (unsigned long long) rand() * test_string_length / RAND_MAX;

        if (rand() > RAND_MAX / 2) {
            new_test_string[random_modification] += 1;
        } else {
            new_test_string[random_modification] -= 1;
        }

        deviations[i] = hash(new_test_string) - hashes[i];

        free(new_test_string);
    }
    
    qsort(hashes, NUM_TESTS, sizeof(unsigned int), comparator);

    unsigned int collisions = 0;

    for (int i = 0; i < NUM_TESTS; i++) {
        if (i == NUM_TESTS - 1) {
            fprintf(benchmark_data, "%u", hashes[i]);
        } else {
            if (hashes[i] == hashes[i + 1]) {
                collisions++;
                // if (strcmp(name, "benchmark_data_rolling_hash.csv") == 0) printf("%u\n", hashes[i]);
            }
            fprintf(benchmark_data, "%u,", hashes[i]);
        }
    }
    fprintf(benchmark_data, "\n");

    fprintf(benchmark_data, "%u\n", collisions);

    for (int i = 0; i < NUM_TESTS; i++) {
        if (i == NUM_TESTS - 1) {
            fprintf(benchmark_data, "%u", deviations[i]);
        } else {
            fprintf(benchmark_data, "%u,", deviations[i]);
        }
    }
    fprintf(benchmark_data, "\n");
}
