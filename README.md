# マクスウェルの悪魔ゲーム

あなたに悪魔としての素質があるかを試すゲームです。

## ルール

1. 舞台は真ん中を壁で仕切られた、断熱・定圧の箱の中です。
1. あなたは悪魔です。
1. あなたは、箱の真ん中の壁の真ん中にいます。
1. 壁の真ん中には小さな扉があります。
1. あなたはその扉を開け閉めできます。
1. 箱の中は高温で運動の激しい粒子と、低温で運動の穏やかな粒子が動き回っています。
1. 扉を開けたり閉めたりして、高温の粒子を右の部屋に移動させ、低温の粒子を左の部屋に分離したらクリアです。
1. 最後は扉を閉じてください。

## ファイル

|file|description|
|-|-|
|main.m|メインコードです。これを実行してください。|
|fieldBox.m|箱の状態を設定&保持するクラス|
|particles.m|粒子の状態を設定&保持するクラス|
|MaxwellDemonGame.m|ゲームクラス。クリア判定などをします。|

## 操作方法

`s`キーで扉を開けたり閉めたりできます。それだけです。