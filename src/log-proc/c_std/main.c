// SPDX-FileCopyrightText: 2026 TSUKUMO Akito <tsukumoakito99@duck.com>
// SPDX-License-Identifier: MIT

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

int main(int argc, char *argv[]) {
  int n = 10000;
  if (argc > 1) {
    n = atoi(argv[1]);
  }

  uint64_t checksum = 0;
  char buffer[512];

  for (int i = 0; i < n; i++) {
    int len = sprintf(buffer,
                      "{\"id\":%d,\"level\":\"info\",\"msg\":\"performance_"
                      "test_log_entry_number_%d\",\"timestamp\":%ld}",
                      i, i, (long)time(NULL));

    char *id_ptr = strstr(buffer, "\"id\":");
    if (id_ptr) {
      uint64_t id_val = (uint64_t)atoi(id_ptr + 5);
      checksum += id_val;
    }

    char *msg_ptr = strstr(buffer, "\"msg\":\"");
    if (msg_ptr) {
      char *msg_end = strchr(msg_ptr + 7, '\"');
      if (msg_end) {
        checksum += (uint64_t)(msg_end - (msg_ptr + 7));
      }
    }
  }

  printf("Checksum: %llu\n", (unsigned long long)checksum);
  fprintf(stderr, "Limit: %d\n", n);

  return 0;
}
