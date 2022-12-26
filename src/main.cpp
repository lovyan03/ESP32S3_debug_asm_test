#include <Arduino.h>

extern "C" {
  // アセンブラコード内の関数宣言
  uint32_t asm_test_func(uint32_t);
};

void setup() {
  printf("setup\n");
}

void loop() {
  delay(500);
  static uint32_t count;
  uint32_t result = asm_test_func(count);
  printf("loop %d : char %c : %02x\n", count, (char)result, result);
  ++count;
}
