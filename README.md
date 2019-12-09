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

