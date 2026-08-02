// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
  struct Node *left;
  struct Node *right;
} Node;

Node *createTree(int depth) {
  Node *node = (Node *)malloc(sizeof(Node));
  if (depth > 0) {
    node->left = createTree(depth - 1);
    node->right = createTree(depth - 1);
  } else {
    node->left = NULL;
    node->right = NULL;
  }
  return node;
}

void deleteTree(Node *node) {
  if (node->left)
    deleteTree(node->left);
  if (node->right)
    deleteTree(node->right);
  free(node);
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

  Node *root = createTree(depth);
  uint64_t count = countNodes(root);

  printf("Checksum: %llu\n", (unsigned long long)count);
  fprintf(stderr, "Depth: %d\n", depth);

  deleteTree(root);
  return 0;
}
