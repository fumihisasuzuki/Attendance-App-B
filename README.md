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


「勤怠システムB」のご提出

「人口インターン」ご担当
久保様

平素大変お世話になっております。
題記の件、下記の通りご提出いたしますので、お忙しいところ大変恐縮ではございますが、
ご確認・レビューいただき、コメントをご連絡いただけると幸いです。


記

提出物：勤怠システムB
作成者：鈴木文悠(2019/9/30 入会)
作成期間：2019/12/4 - 2019/12/15

《URL》
https://hidden-falls-34993.herokuapp.com/

《ログインアカウント》
管理者
  メールアドレス：sample@email.com
  パスワード：password
一般ユーザー
  メールアドレス：sample-1@email.com
  パスワード：password
  ※　上記他、n=0..99に対して下記の通り作成
  メールアドレス：sample-#{n+1}@email.com
  パスワード：password


《特記事項》

※　画面のレイアウトについて
「画面設計書」を正として実装した。
したがって、一部、画面遷移等のレイアウトなどと異なる場合がある。
ただし、「残業指示、指示者は、今回必要ないので消去します」との記載があったため、
これらの列については、勤怠表示画面、勤怠編集画面の両方について、列なしで実装した。
また、レイアウトに追加したデバッグ情報についても、「画面設計書」を正とし、残している。

※　基本勤怠情報について
管理者の設定時間を全員が参照している。
仮に管理者を2人以上作成した場合、id番号の若い管理者の設定時間が使用される。

※　Attendanceモデルのバリデーションについて
テスト仕様書No.９及び２１の
「退社時間もしくは出社時間のみの更新ができないこと」に関しては、
当日、退勤前に編集することがあることを想定すると、
当日の退勤時間がブランクで更新できないのは不便なため、
「前日以前の勤怠情報に関して、退社時間もしくは出社時間のどちらかをブランクとする更新はできない」
と解釈し実装した。

※　追加機能No.9
空欄で検索すると、全てのユーザーを表示。

※　追加機能No.10
１５分切り捨ては勤怠表示ページのみの実装とした。
更新(編集)ページでは、DBと同じ値。
（切り捨て前の時間が確認可能）

以上