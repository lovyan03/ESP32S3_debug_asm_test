
    .section  .text
    .align    4
    .global   asm_test_func
    .type     asm_test_func,@function

// 汎用レジスタ(Xtensaではアドレスレジスタと呼ばれる) は a0~a15 の合計16個ある。
// ただしa0とa1の扱いは注意。
//  a0 = リターンアドレス
//  a1 = スタックポインタ
// 通常この2つは使用を避ける。
// a0に関しては内容を変更しても良いが、retwを実行する前に元に戻すこと。

// 引数のうち先頭から6個まではレジスタ a2-a7 に入っている。
// 戻り値はretw命令実行時点でa2にセットされた値が使用される。

// uint32_t asm_test_func(uint32_t value)
asm_test_func:                    // 関数 asm_test_func の先頭アドレスにラベルを配置
    entry     a1, 16              // C言語から呼ばれる関数の先頭は必ずentry命令を配置する。
    movi      a10,asm_test_data   // a10 = asm_test_data;           データのアドレスを代入
    extui     a11,a2, 0,  4       // a11 = (a2 >> 0) & 0x0F;        下位4ビットマスク。これでa11の値はa2の下位4ビットの値となる
    add       a12,a11,a10         // a12 = a11 + a10;               a12の内容は asm_test_data[a2 & 0x0F] のアドレスとなる
    l8ui      a2, a12,0           // a2 = asm_test_data[a2 & 0x0F]; a12の示すアドレスの値をa2に代入する
    retw                          // return a2;                     retw命令でa2の値を戻り値とし関数を終了する

// 関数ここまで。

// 以下 データ

    .align    4
    .section  .rodata         // ROM配置を指定
asm_test_data:
    // 文字列データを配置
    .string   "\xDE\xAD\xBE\xEF HELLO WORLD TESTSTRING."

