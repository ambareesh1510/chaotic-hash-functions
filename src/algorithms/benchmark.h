#ifndef BENCHMARK_H
#define BENCHMARK_H

typedef struct Benchmarks Benchmarks;

Benchmarks *benchmark(const char *name, unsigned int (*hash)(const char *));

#endif /* BENCHMARK_H */
