# ESP32 ( 含む S2, S3 ) アセンブラの書き方ガイド

本記事の対象者
 - ArduinoIDE または VSCode + PlatformIO で ESP32 用のプログラムを記述し実行できる。
 - アセンブラというものがあることを何となく知っているが、具体的に書いたことはない。

 ※ ESP32-C3などの、コアが Xtensa ではないものは本記事の対象から外れます。

### 公式情報の入手

 - ESP32のコアは Xtensa LX6 、 ESP32-S2とESP32-S3のコアは Xtensa LX7 です。  
 - アセンブラで使用できる命令の詳細を知るためには Xtensa の公式資料を探して下さい。  
 - Google等で「Xtensa Instruction Set Architecture」と検索し、Overview や Reference Manual の PDF を見つけて下さい。
 - 公式資料の企業名が複数存在しますが、ケイデンス「cadence」がテンシリカ「tensilica」を買収したためです。

### 記事一覧

[step.01 : インライン・アセンブラを書いてみよう 1](step01_inline_asm_1.md)  

以下 作成中…  

[step.02 : インライン・アセンブラを書いてみよう 2](step02_inline_asm_2.md)  

