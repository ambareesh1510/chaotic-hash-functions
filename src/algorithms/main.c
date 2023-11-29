#include <stdio.h>
#include <string.h>
#include <math.h>
#include <limits.h>
#include <stdlib.h>

#include "hashes.h"
#include "debug.h"
#include "benchmark.h"

int main(int argc, char **argv) {
    debug_all_hashes();
    benchmark("benchmark_data_rolling_hash.csv", *rolling_hash);
    benchmark("benchmark_data_tent_map_hash.csv", *tent_map_hash);
    benchmark("benchmark_data_dyadic_map_hash.csv", *dyadic_map_hash);
    benchmark("benchmark_data_multi_state_hash.csv", *multi_state_hash);
}
