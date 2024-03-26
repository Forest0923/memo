---
title: 「入門 監視 ― モダンなモニタリングのためのデザインパターン」を読んだメモ
date: 2024-03-21
---

## Memo

### アンチパターン・デザインパターン

- 監視設定の自動化
- json などの構造化ログでメトリクスを収集すれば、その後の自動化が楽になる（場合による）
- 高い SLA を守るためにはその分高頻度のメトリクス収集が必要
  - [標本化定理](https://ja.wikipedia.org/wiki/%E6%A8%99%E6%9C%AC%E5%8C%96%E5%AE%9A%E7%90%86)
- ユーザ視点の監視
- 可能な限り SaaS を使う。コスト・効果ともに優れている場合が多い

### アラート

- 敏感すぎる・鈍感すぎるアラートにならないようにアラートの削除とチューニング
- 自動復旧できないか？
- インシデント対応の役割分担
  - 現場指揮官、起こったことの記録者、調整役、インシデント対応者
  - （実際にこれを分けるのは難しそう）
- [PagerDuty Incident Response](https://response.pagerduty.com)

### 統計

- パーセンタイルの理解が間違ってた…

### ビジネスの監視

- [16 Startup Metrics](https://a16z.com/16-startup-metrics/)
- [16 More Startup Metrics](https://a16z.com/16-more-startup-metrics/)
- ビジネスKPI （key performance indicator）
  - 担当プロダクトの KPI は何？

### フロントエンド監視・アプリケーション監視

- ページロード時間とビジネスの関係について
- [Navigation timing API のタイムライン](https://www.w3.org/TR/navigation-timing/#process)
- https://sentry.io/welcome/
- アプリケーションのヘルスチェック
- [StatsD](https://github.com/statsd/statsd)
- 分散トレーシング
  - マイクロサービスアーキテクチャの監視をするための方法論とツールのこと？
    - マイクロサービス: 機能を小さなサービスに分割して API で連携する
    - どこのリクエストから始まってどこで終わるかなどがわかりにくい
  - リクエストにタグをつけてトレースする
  - https://github.com/openzipkin/zipkin
  - [分散トレーシングシステムのZipkinを使ってみた話](https://qiita.com/miya10kei/items/2532b80fcd8d19eb2e75)

## etc

- nagios
- zabbix
