# GitHubSearchAPIApp
## 概要
- GitHubの[Search API](https://developer.github.com/v3/search/#search-users)を利用したユーザなどの情報を表示するアプリ
- 対象はiOS11以降

## 機能
- Search APIで取得した検索結果を一覧で表示
- 任意のレコードをタップ後、詳細画面で任意の情報を表示
- 検索結果が0件のときその旨のメッセージを表示
- エラー時にダイアログでその旨のメッセージを表示（Ex. ネットワーク未接続のときなど）

## 画面構成
- 検索結果一覧表示画面
- 詳細画面

## ライブラリ情報
### 管理ツール
- [CocoaPods](https://cocoapods.org/)
### 利用ライブラリ
- [SwiftyJson](https://cocoapods.org/pods/SwiftyJSON)
  - JSONデータを簡単にパースするために導入
  - iOS標準で実装できる部分は標準で実装

## その他
- 比較的規模の小さいアプリだったためテストは未実装
- 設計モデル（MVPなど）の基本的な概念をもっとよく勉強する必要がある
