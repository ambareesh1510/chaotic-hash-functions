#include <stdio.h>

#include "hashes.h"

const char* TEST_STRING_1 = "asdfqwer";
const char* TEST_STRING_2 = "asdfqwgr";
const char* TEST_STRING_3 = "asdfqwer.";
// const char* TEST_STRING_1 = "The quick brown fox jumps over the lazy dog";
// const char* TEST_STRING_2 = "The quick brown fox jumps over the lazy dig";
// const char* TEST_STRING_3 = "The quick brown fox jumps over the lazy dog!";

void debug(const char *fn_name, const char *input, int hash) {
    printf("%s with input \"%s\": %u\n", fn_name, input, hash);
}

void debug_all_hashes(void) {
    debug("rolling_hash", TEST_STRING_1, rolling_hash(TEST_STRING_1));
    debug("rolling_hash", TEST_STRING_2, rolling_hash(TEST_STRING_2));
    debug("rolling_hash", TEST_STRING_3, rolling_hash(TEST_STRING_3));
    printf("\n");

    debug("tent_map_hash", TEST_STRING_1, tent_map_hash(TEST_STRING_1));
    debug("tent_map_hash", TEST_STRING_2, tent_map_hash(TEST_STRING_2));
    debug("tent_map_hash", TEST_STRING_3, tent_map_hash(TEST_STRING_3));
    printf("\n");

    debug("dyadic_map_hash", TEST_STRING_1, dyadic_map_hash(TEST_STRING_1));
    debug("dyadic_map_hash", TEST_STRING_2, dyadic_map_hash(TEST_STRING_2));
    debug("dyadic_map_hash", TEST_STRING_3, dyadic_map_hash(TEST_STRING_3));
    printf("\n");

    debug("multi_state_hash", TEST_STRING_1, multi_state_hash(TEST_STRING_1));
    debug("multi_state_hash", TEST_STRING_2, multi_state_hash(TEST_STRING_2));
    debug("multi_state_hash", TEST_STRING_3, multi_state_hash(TEST_STRING_3));
    printf("\n");
}
