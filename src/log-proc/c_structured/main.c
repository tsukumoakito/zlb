// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

typedef struct {
  size_t key;
  uint64_t value;
  int occupied;
} HashEntry;

typedef struct {
  HashEntry *entries;
  size_t capacity;
} HashMap;

HashMap *hash_map_init(size_t n) {
  HashMap *map = malloc(sizeof(HashMap));
  map->capacity = n * 2;
  map->entries = calloc(map->capacity, sizeof(HashEntry));
  return map;
}

void hash_map_put(HashMap *map, size_t key, uint64_t value) {
  size_t h = key % map->capacity;
  while (map->entries[h].occupied && map->entries[h].key != key) {
    h = (h + 1) % map->capacity;
  }
  map->entries[h].key = key;
  map->entries[h].value = value;
  map->entries[h].occupied = 1;
}

void hash_map_free(HashMap *map) {
  free(map->entries);
  free(map);
}

int main(int argc, char *argv[]) {
  int n = 10000;
  if (argc > 1) {
    n = atoi(argv[1]);
  }

  HashMap *map = hash_map_init(n);
  char buffer[512];

  for (int i = 0; i < n; i++) {
    sprintf(buffer,
            "{\"id\":%d,\"level\":\"info\",\"msg\":\"performance_test_log_"
            "entry_number_%d\",\"timestamp\":%ld}",
            i, i, (long)time(NULL));

    uint64_t id_v = 0;
    uint64_t m_len = 0;

    char *p = buffer;
    while (*p) {
      if (*p == '"') {
        p++;
        char *start = p;
        while (*p && *p != '"')
          p++;
        size_t len = p - start;
        if (strncmp(start, "id", len) == 0) {
          while (*p && (*p < '0' || *p > '9'))
            p++;
          id_v = (uint64_t)atoll(p);
        } else if (strncmp(start, "msg", len) == 0) {
          while (*p && *p != ':')
            p++;
          while (*p && *p != '"')
            p++;
          p++;
          char *m_start = p;
          while (*p && *p != '"')
            p++;
          m_len = (uint64_t)(p - m_start);
        }
      }
      if (*p)
        p++;
    }
    hash_map_put(map, (size_t)i, id_v + m_len);
  }

  uint64_t checksum = 0;
  for (size_t i = 0; i < map->capacity; i++) {
    if (map->entries[i].occupied) {
      checksum += map->entries[i].value;
    }
  }

  printf("Checksum: %llu\n", (unsigned long long)checksum);
  fprintf(stderr, "Limit: %d\n", n);

  hash_map_free(map);
  return 0;
}
