## step.02 : インライン・アセンブラを書いてみよう 2

実際に実行可能なアセンブラを含んだ、より具体的なコードの例を書いてみます。  
RGB565の16bit色データが格納された配列を基に、別の配列にRGB332の8bit色データを出力してみます。

### ソースコード
```
#include <Arduino.h>
void setup(void)
{ delay(1000); }

void loop(void)
{
  delay(1000);
  printf("loop:\n");
  static uint32_t count = 0;

  uint32_t array_size = 16;
  uint8_t rgb332[array_size];
  uint16_t rgb565[array_size];

  // 変換元のRGB565のカラーデータを用意する
  for (int i = 0; i < array_size; ++i) {
    rgb565[i] = count;
    count += 136;
  }

  __asm__ (
    "   loop    %2, LABEL_LOOP  \n"   // ここからLABEL_LOOPまでを array_size の回数だけループする
    "   l16ui   a10,%1, 0       \n"   // a10 = rgb565[0]; 変換元配列から 2Byte読取り
    "   addi    %1, %1, 2       \n"   // 変換元データのrgb565のアドレスを2Byte進める
    "   extui   a12,a10,13, 3   \n"   // a12 = (a10 >> 13) & (0b00000111); 赤色成分を取り出す
    "   extui   a11,a10,8,  3   \n"   // a11 = (a10 >>  8) & (0b00000111); 緑色成分を取り出す
    "   extui   a10,a10,3,  2   \n"   // a10 = (a10 >>  3) & (0b00000011); 青色成分を取り出す
    "   addx8   a11,a12,a11     \n"   // a11 = (a12 << 3) + a11;  a11の中身は 0b00RRRGGG になる
    "   addx4   a10,a11,a10     \n"   // a10 = (a11 << 2) + a10;  a10の中身は 0bRRRGGGBB になる
    "   s8i     a10,%0, 0       \n"   // rgb332[0] = a10 変換先配列に 1Byte書込み;
    "   addi    %0, %0, 1       \n"   // 変換先データのrgb332のアドレスを1Byte進める
    "LABEL_LOOP:                \n"
    : /* outputなし */
    : "r" (rgb332)                    // %0 = rgb332;
    , "r" (rgb565)                    // %1 = rgb565;
    , "r" (array_size)                // %2 = array_size;
    : "a10","a11","a12"               // 使用したレジスタを列挙
  );

  // 変換先のRGB332と変換元のRGB565の値を出力する
  for (int i = 0; i < array_size; ++i) {
    printf("RGB332:0x%02x  = RGB565:0x%04x\n", rgb332[i], rgb565[i]);
  }
}
```

### 実行結果
```
loop:
RGB332:0x01  = RGB565:0x0088
RGB332:0x00  = RGB565:0x0000
RGB332:0x06  = RGB565:0x0110
RGB332:0x07  = RGB565:0x0198
RGB332:0x08  = RGB565:0x0220
RGB332:0x09  = RGB565:0x02a8
RGB332:0x0e  = RGB565:0x0330
RGB332:0x0f  = RGB565:0x03b8
RGB332:0x10  = RGB565:0x0440
RGB332:0x11  = RGB565:0x04c8
RGB332:0x16  = RGB565:0x0550
RGB332:0x17  = RGB565:0x05d8
RGB332:0x18  = RGB565:0x0660
RGB332:0x19  = RGB565:0x06e8
RGB332:0x1e  = RGB565:0x0770
RGB332:0x1f  = RGB565:0x07f8
```

### 概要説明
C/C++側で確保したふたつの配列のアドレスと配列の要素数をアセンブラに渡し、配列内の全てにRGB565からRGB332への変換処理を行います。  
2進数風に表現すると RGB565の16bitは 0bRRRRRGGGGGGBBBBB , RGB332の8bitは 0bRRRGGGBB となります。  
RGB565→RGB332の手順は、RGB565からRの上3bit、Gの上3bit、Bの上2bitを取り出し1Byteにまとめるだけです。  

