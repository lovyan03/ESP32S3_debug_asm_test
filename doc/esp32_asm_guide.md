# ESP32 ( 含む S2, S3 ) アセンブラの書き方ガイド
 ※ ESP32-C3などの、コアが Xtensa ではないものは本記事の対象から外れます。

本記事の想定読者
 - ArduinoIDE または VSCode + PlatformIO で ESP32 用のC/C++プログラムを記述し実行できる。
 - アセンブラというものがあることは何となく知っているが、具体的に書いたことはない。

### 公式情報の入手

 - ESP32のコアは Xtensa LX6 、 ESP32-S2とESP32-S3のコアは Xtensa LX7 です。  
 - アセンブラで使用できる命令の詳細を知るためには Xtensa の公式資料を探して下さい。  
 - Google等で「Xtensa Instruction Set Architecture」と検索し、`Overview` や `Reference Manual` の PDF を見つけて下さい。
 - 公式資料の企業名が複数存在しますが、ケイデンス「cadence」がテンシリカ「tensilica」を買収したためです。

### 記事一覧

#### step.1 インライン・アセンブラを書いてみよう

[step.1-1 : とりあえずインライン・アセンブラを書いてみよう](step_01_01.md)  

[step.1-2 : 複数行のインライン・アセンブラを書いてみよう](step_01_02.md)  

[step.1-3 : インライン・アセンブラのみの関数を書いてみよう](step_01_03.md)  

#### step.2 アセンブラコードを .S ファイルに分けてみよう

#### step.3 C/C++のコンパイル結果を参考にしてみよう

Compiler explorerを使ってみる  
PlatformIO のデバッガで Disassemble 機能を使ってみる  

