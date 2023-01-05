## step.01 : インライン・アセンブラを書いてみよう 1

実際に実行可能なアセンブラを含んだ簡単なコードの例を書いてみます。  

### ソースコード
```
#include <Arduino.h>

void setup(void)
{ delay(1000); }

void loop(void)
{
  delay(1000);
  printf("loop:\n");

  for (int32_t y = 0; y < 5; ++y) {
    for (int32_t x = 0; x < 5; ++x) {
      int32_t val;
      __asm__ (
        "add %0, %1, %2 \n"
        : "=r" ( val )
        : "r" ( x ), "r" ( y )
      );
      printf("   %d + %d = %d", x, y, val);
    }
    printf("\n");
  }
}
```

### 実行結果
```
loop:
   0 + 0 = 0   1 + 0 = 1   2 + 0 = 2   3 + 0 = 3   4 + 0 = 4
   0 + 1 = 1   1 + 1 = 2   2 + 1 = 3   3 + 1 = 4   4 + 1 = 5
   0 + 2 = 2   1 + 2 = 3   2 + 2 = 4   3 + 2 = 5   4 + 2 = 6
   0 + 3 = 3   1 + 3 = 4   2 + 3 = 5   3 + 3 = 6   4 + 3 = 7
   0 + 4 = 4   1 + 4 = 5   2 + 4 = 6   3 + 4 = 7   4 + 4 = 8
```

### 概要説明
この例はアセンブラコードを `__asm__ ();` のカッコで囲んでC/C++のソース内に埋め込む「インライン・アセンブラ」と呼ばれる記述方法になります。  
アセンブラの内容は、C/C++では ` int32_t val = x + y; ` と記述できる内容です。  
二重のforループの中で val=x+y を実行した結果を printf で標準出力に表示するコードです。  
各行に説明コメントを追加してみます。
```
      __asm__ (                     // インライン・アセンブラの記述開始
        "add %0, %1, %2 \n"         // val = x + y;
        : "=r" ( val )              // output-list: アセンブラ実行終了時 val = %0   となる
        : "r" ( x ), "r" ( y )      // input-list:  アセンブラ実行開始時 %1=x、%2=y となる
      );                            // インライン・アセンブラの記述終了
```
この例では `add` の行のみがアセンブラで、続く2行は C/C++とアセンブラとの値の受け渡しのための記述です。  
アセンブラコード内にC/C++の変数名をそのまま記述することはできないため、こういった記述が必要になります。  

#### C/C++の変数とアセンブラの汎用レジスタ
C/C++の世界での変数の役割を果たすものは、アセンブラの世界では一般に「汎用レジスタ(general register)」と呼ばれます。Xtensa ではこれを「アドレスレジスタ」と呼称しており、32bitの値を扱える `a0` ~ `a15` の合計16個が用意されています。int32_t,uint32_t型として使える変数のようなものが16個ある、とイメージして頂ければ良いと思います。  

#### output-list / input-list
`output-list`、`input-list`に記述した変数は、`%0` から順に番号が割当てられ、アセンブラ内での記述が可能になります。今回の例では `val`が`%0` 、 `x`が`%1` 、`y`が`%2` になります。実際にはコンパイラが `a0` ~ `a15` の中からどれかを選択してコンパイル時に置き換えて処理しています。どのレジスタが使用されるかはコンパイラ任せとなります。  

アドレスレジスタの個数は16個ですから、インライン・アセンブラとの受渡しに使える変数の個数には上限があります。インライン・アセンブラの外側での処理の都合もあるため、16個すべてをC/C++との受け渡しに使用することはできませんから、なるべく個数を少なく抑えることが望ましいです。  

#### add命令と3つのレジスタの指定
`add` 命令は名前の通り加算を行う命令です。最初に指定したアドレスレジスタに、後の２つのアドレスレジスタの合計値が代入されます。今回の例では `add %0,%1,%2` ですから、`%0` = `%1` + `%2` となります。  

#### 複数行のアセンブラコードの記述
アセンブラの記述は基本的には 1行に 1つの命令を書き、改行で区切って次の命令を記述します。  
インライン・アセンブラではC/C++のコード内に文字列の形で書込むため、各行の文字列の末尾に `\n` を置いて改行とするのが良いでしょう。  