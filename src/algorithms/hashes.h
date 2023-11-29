#ifndef HASHES_H
#define HASHES_H

unsigned int rolling_hash(const char *n);
unsigned int tent_map_hash(const char *n);
unsigned int dyadic_map_hash(const char *n);
unsigned int multi_state_hash(const char *n);

#endif /* HASHES_H */
