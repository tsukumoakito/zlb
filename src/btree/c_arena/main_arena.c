// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
  struct Node *left;
  struct Node *right;
} Node;

typedef struct {
  char *buffer;
  size_t capacity;
  size_t offset;
} Arena;

void *arena_alloc(Arena *arena, size_t size) {
  if (arena->offset + size > arena->capacity)
    return NULL;
  void *ptr = &arena->buffer[arena->offset];
  arena->offset += size;
  return ptr;
}

Node *createTree(Arena *arena, int depth) {
  Node *node = (Node *)arena_alloc(arena, sizeof(Node));
  if (depth > 0) {
    node->left = createTree(arena, depth - 1);
    node->right = createTree(arena, depth - 1);
  } else {
    node->left = NULL;
    node->right = NULL;
  }
  return node;
}

uint64_t countNodes(Node *node) {
  if (!node)
    return 0;
  return 1 + countNodes(node->left) + countNodes(node->right);
}

int main(int argc, char *argv[]) {
  int depth = 20;
  if (argc > 1)
    depth = atoi(argv[1]);

  size_t total_nodes = (1ULL << (depth + 1)) - 1;
  size_t required_size = total_nodes * sizeof(Node);

  Arena arena;
  arena.capacity = required_size;
  arena.buffer = (char *)malloc(arena.capacity);
  arena.offset = 0;

  if (!arena.buffer) {
    fprintf(stderr, "Failed to allocate arena of size %zu\n", required_size);
    return 1;
  }

  Node *root = createTree(&arena, depth);
  uint64_t count = countNodes(root);

  printf("Checksum: %llu\n", (unsigned long long)count);
  fprintf(stderr, "Depth: %d\n", depth);

  free(arena.buffer);

  return 0;
}
