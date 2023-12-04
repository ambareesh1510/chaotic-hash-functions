#import "@preview/polylux:0.3.1": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)
#show link: underline

#polylux-slide[
  #align(horizon + center)[
  = Hash Functions and Chaos

  Ambareesh Shyam Sundar

  4 December 2023

  ]
]

#polylux-slide[
  = What is a hash function?

  #line-by-line(start: 2)[
    - Converts input of arbitrary length into fixed-length output
    - Frequently used in hash tables
  ]
  #only("3-")[
    #align(center)[
      Hash function: `hash(key) = key % 17`
      #table(
        fill: (col, _) => if col == 0 { luma(240) } else { white },
        columns: (auto, auto, auto),
        inset: 10pt,
        [`key`], [`hash(key)`], [`value`],
        [`5`], [`5`], [`"hello"`],
        [`8`], [`8`], [`"goodbye"`],
        [`36`], [`2`], [`"compression"`],
        [`22`], [`5`], [`"collision"`],
      )
    ]
  ]
]

#polylux-slide[
  = Desirable properties of hash functions
  #line-by-line(start: 2)[
    - Deterministic (`a == b` and `hash(a) == X` imply `hash(b) == X`)
    - Non-invertible (given `X == hash(a)`, it is difficult to determine the value of `a`)
    - Resistant to collisions (given `hash(a) == X`, it is difficult to find \ `b != a` such that `hash(b) == X`)
    - Avalanche effect (given `a` and `a'` are slightly different, even if `hash(a) == X` is known, it is hard to predict `hash(a')`)
  ]
]

#polylux-slide[
  = Desirable properties of hash functions
    #align(center + horizon)[
      #one-by-one[
      Avalanche effect
      ][

      #sym.arrow.t.b.stroked

      Sensitive dependence on initial conditions
      ][

      #sym.arrow.t.b.stroked
      
      Chaos?
      ][

        #text(size: 15pt)[(transitivity helps)]
      ]
    ]
]

#polylux-slide[
  #align(horizon + center)[
    #text(size: 25pt)[The big question:]
    = Can chaotic discrete maps be used as effective hash functions?
  ]
]

#polylux-slide[
    #one-by-one[
    == For this experiment:
    ][
      - Hash strings (`char[]`) to 32-bit unsigned integers (`unsigned int`)
    ][
      - 4 different hashing algorithms
        - Rolling hash 
        - Tent map
        - Dyadic map 
        - "Multi-state" hash
    ][
      - 3 different metrics
        - Distribution of hashed values
        - Number of collisions
        - Avalanche effect
    ]
]

#polylux-slide[
  = Rolling hash
  #only(1)[
  ```c
  unsigned int rolling_hash(char *n) {
      unsigned int hash = 0;
      unsigned int curr_pow = 1;
      for (unsigned long i = 0; i < strlen(n); i++) {
          hash += n[i] * curr_pow;
          curr_pow *= 7919;
      }
      return hash;
  }
  ```
  #text(size: 20pt)[(Interpret the string as an integer in base `7919`.)]
  ]
  #only(2)[
    #columns(2)[
    #image("img/rolling_hash_distribution.png", width: 90%)
    #colbreak()
    #image("img/rolling_hash_deviation.png", width: 90%)
    ]
    #align(center)[
    Collision percentage: 0.003%
    ]
  ]
]

#polylux-slide[
  = Tent map hash
  #only(1)[
    $
    T(x) = cases(
      2x &"if" x < (2^32 - 1) / 2,
      2 dot ((2^32 - 1) - x) &"otherwise",
    )
    $
  ```c
unsigned int tent_map_hash(char *n) {
    unsigned int hash = rolling_hash(n);
    int iterations = 53;
    ```
    #text(size: 20pt)[(Find the rolling hash value of the string.)]
    #pagebreak()
    ```c
    for (int i = iterations; i > 0; i--) {
        if (hash < UINT_MAX / 2) {
            hash = 2 * hash;
        } else {
            hash = 2 * (UINT_MAX - hash);
        }
    }
    return hash;
}
  ```
  #text(size: 20pt)[(Perform 53 iterations of the tent map on the hash value.)]
  ]
  #only(2)[
    #columns(2)[
    #image("img/tent_map_hash_distribution.png", width: 90%)
    #colbreak()
    #image("img/tent_map_hash_deviation.png", width: 90%)
    ]
    #align(center)[
    Collision percentage: 0.001%
    ]
  ]
]

#polylux-slide[
  = Dyadic map hash
  #only(1)[
    $
    D(x) = cases(
      2x &"if" x < (2^32 - 1) / 2,
      2 dot (x - (2^32 - 1) / 2) &"otherwise",
    )
    $
  ```c
unsigned int dyadic_map_hash(char *n) {
    unsigned int hash = rolling_hash(n);
    int iterations = 53;
    ```
    #text(size: 20pt)[(Find the rolling hash value of the string.)]
    #pagebreak()
    ```c
    for (int i = iterations; i > 0; i--) {
        if (hash < UINT_MAX / 2) {
            hash = 2 * hash;
        } else {
            hash = 2 * (hash - UINT_MAX / 2);
        }
    }
    return hash;
}
  ```
  #text(size: 20pt)[(Perform 53 iterations of the dyadic map on the hash value.)]
  ]
  #only(2)[
    #columns(2)[
    #image("img/dyadic_map_hash_distribution.png", width: 90%)
    #colbreak()
    #image("img/dyadic_map_hash_deviation.png", width: 90%)
    ]
    #align(center)[
    Collision percentage: 0.002%
    ]
  ]
]

#polylux-slide[
  = The dyadic map and tent map
  #only("-3")[
  #one-by-one[
    - Suspiciously similar hashes between tent map and dyadic map
  ][
    - Only for certain strings
  ][
    ```
    tent_map_hash with input "asdfqwer": 914563734
    tent_map_hash with input "asdfqwgr": 1406886406
    tent_map_hash with input "asdfqwer.": 4153872816

    dyadic_map_hash with input "asdfqwer": 914564396
    dyadic_map_hash with input "asdfqwgr": 1406886924
    dyadic_map_hash with input "asdfqwer.": 141098142
    ```
  ]
  ]
  #only("4-")[
  #one-by-one(start: 4)[

    - Topological conjugacy:
      $ T(x) = C^(-1)(D(C(x))) $
      where
      $ C(x) = sin(pi x) $

  ][

    - If $C(x) = sin(pi x) approx x$, then $T(x) approx D(x)$
  ]
  ]
]

#polylux-slide[
  = What can we improve?
  #line-by-line(start: 2)[
    - Rolling hash is weak
    - Easy to find collisions
      - Degrades performance due to lots of accidental collisions
    - Not chaotic, so small perturbations #sym.arrow.r small changes in hash
      - Transfers over to tent map and dyadic map hashes
    - *Solution:* remove dependence on rolling hash
  ]
]

#polylux-slide[
  = MD5 algorithm
  #line-by-line(start: 2)[
    - Maintain four state variables: A, B, C, D (each 1/4 of the output)
    - Pad input in order to break it into chunks
    - For each chunk:
      - Apply a (chaotic) map on (B, C, D) and store it in A
      - Rotate all values (A #sym.arrow.r B, B #sym.arrow.r C, ...)
      - After the chunk is processed, add the values of A, B, C, D to the global state
    - Return A concat B concat C concat D
  ]
]

#polylux-slide[
  = Multi-state hash
  #only("-5")[
  #line-by-line(start: 2)[
    - Maintain four state variables: A, B, C, D (each an 8-bit integer)
    - Pad input to be a multiple of `32 * 4 = 128` bits 
    - Add the next 8-bit chunk of input to A, apply the tent map to A, then rotate state values
      - Repeat 32 times per 8-bit chunk
    - Return A concat B concat C concat D
  ]
  ]
  #only("6-")[
    #columns(2)[
    #image("img/multi_state_hash_distribution.png", width: 90%)
    #colbreak()
    #image("img/multi_state_hash_deviation.png", width: 90%)
    ]
    #align(center)[
    Collision percentage: 1.162%
    ]
  ]
]

#polylux-slide[
  = Conclusions
  #only("-6")[
  #one-by-one(start: 2)[

    Can a chaotic map be used to construct a simple and effective hash function?

  ][
    Yes! ][#text(size: 15pt)[(mostly)]
  ][

    Things that worked:
      - Determinism
      - Hash distribution with multi-state hash
      - Avalanche effect

  ][
    Things that didn't really work:
      - Collision resistance
  ]
  ]
]

#polylux-slide[
  = Potential future research:
    - How can collision resistance for the multi-state hash be improved?
    - How much padding is really necessary for the multi-state hash to be effective?
]

#polylux-slide[
  #align(horizon + center)[
    = Thanks for listening!
    Source code for hashes + ipynb of analysis available at \
    #link("github.com/ambareesh1510/chaotic-hash-functions")
  ]
]
