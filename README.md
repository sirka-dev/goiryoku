# README

## build

1. `docker-compose build`
2. `docker-compose up -d`
3. `docker-compose exec web bin/setup`
4. 必要なら `docker-compose exec web rails db:seed_fu`
5. `web/app/public` に twilogから落としてきたCSVを `tweet.csv` という名前で保存
6. `http://localhost:3000/` にアクセスして、`つぶやき情報` の `CSV読み込み` からCSVを読み込み
7. `ライブ情報` で行ったライブ情報を編集
8. `語彙力ちぇっく` を押すと語彙力低下度が判定される！（かも）

## 補足

ライブ後のつぶやきかどうかの判定は「つぶやいた日時がイベント開始日の18時〜終了日の26時内に入っているか」です。
`web/app/models/tweet.rb` あたりをいじると調整ができるはず。

## ToDo

- [ ] つぶやきのCSVをブラウザからアップロードしたい
- [ ] 直接Twitter APIでつぶやきを拾ってきたい
- [ ] ライブ後かどうかの判定調整
- [ ] イベントデータをどこかから拾ってくる
