# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


画面のレイアウトについては、「画面設計書」を正として実装しました。
したがって、一部、画面遷移等のレイアウトなどと異なる場合があります。
ただし、「残業指示、指示者は、今回必要ないので消去します」との記載があったため、
これらの列については、勤怠表示画面、勤怠編集画面の両方について、消去しています。

基本勤怠情報は、管理者の時間を全員が参照しています。
管理者が2人以上いる場合、idの若い管理者の時間が使用されます。


[勤怠システムB]

※Userモデルのバリデーション
1 ユーザー名:存在性の有無、最大文字数５０文字
2 メールアドレス：存在性の有無、パターン制限、最大文字数１００文字、一意性
3 パスワード：存在性の有無、８文字以上かつ２０文字以下、大文字小文字記号を含む制限
4 確認用パスワードの要求

※Attendanceモデルのバリデーション
仕様書通り
但し、テスト仕様書９項及び２１項の
「退社時間もしくは出社時間のみの更新ができないこと」に関しては、
趣旨を考慮して、
「前日以前の勤怠情報に関しては、退社をブランクとする更新はできない」
というバリデーションを加えた。
《理由》
本日に関しては、出勤時間を間違えたということもありうるので、
退勤時間を入力してからでないと出勤時間の更新ができないのは不便だと考えた為。

《追加機能》
最後の１５分切り捨ての実装について。
勤怠表示ページのみの実装とし、更新ページでは、
切り捨て前の時間を確認できるようにした。


《テスト仕様》

《ログイン》
[管理者]
  メールアドレス：sample@email.com
  パスワード：password
[一般ユーザー]
  メールアドレス：sample-1@email.com
  パスワード：password
  
  ※　n=0..59に対して下記の通り作成
  メールアドレス：sample-#{n+1}@email.com
  パスワード：password

