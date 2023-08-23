---
title: "Docusaurus"
draft: false
weight: 999
---

## Link

- [Docusaurus official page](https://docusaurus.io/)

## Project structure

```txt
.
├── blog
├── docs
├── docusaurus.config.js
├── node_modules
├── package.json
├── README.md
├── sidebars.js
├── src
│  ├── components
│  │  └── HomepageFeatures
│  ├── css
│  │  └── custom.css
│  └── pages
├── static
│  └── img
├── tsconfig.json
└── yarn.lock
```

## Blog

```txt
.
├── blog
│  ├── 2019-05-28-first-blog-post.md
│  ├── 2019-05-29-long-blog-post.md
│  ├── 2021-08-01-mdx-blog-post.mdx
│  ├── 2021-08-26-welcome
│  │  ├── docusaurus-plushie-banner.jpeg
│  │  └── index.md
│  └── authors.yml
```

- authors.yml
  - 著者の情報を保存してブログページにいい感じに表示してくれる
  - Blog 本文の frontMatter に直接書いてもOK

```yml
endi:
  name: Endilie Yacop Sucipto
  title: Maintainer of Docusaurus
  url: https://github.com/endiliey
  image_url: https://github.com/endiliey.png

yangshun:
  name: Yangshun Tay
  title: Front End Engineer @ Facebook
  url: https://github.com/yangshun
  image_url: https://github.com/yangshun.png

slorber:
  name: Sébastien Lorber
  title: Docusaurus maintainer
  url: https://sebastienlorber.com
  image_url: https://github.com/slorber.png
```

- ブログ本文
  - `first-blog.md` でも `first-blog/index.md` でもOK
  - frontMatter
    - slug: URL に表示される path の名前
    - date: 日付を書けば反映される。ファイル名を `2023-08-01-first-blog.md` のようにすればなくても平気
    - title, authors, tags: そのまま。
    - category はないみたい。

```md
---
slug: welcome
title: Welcome
authors: [slorber, yangshun]
tags: [facebook, hello, docusaurus]
---

contents
```

- `https://example.com/blog` にアクセスするとブログのリストが出てくるが、ブログが長すぎたときに `<!-- truncate -->` 以下を表示しないようにできる。
- Markdown 内で React の機能を使うことができる(?) MDX という拡張形式を使うことができる。

## Document

```text
├── docs
│  ├── intro.md
│  ├── tutorial-basics
│  │  ├── _category_.json
│  │  ├── congratulations.md
│  │  ├── create-a-blog-post.md
│  │  ├── create-a-document.md
│  │  ├── create-a-page.md
│  │  ├── deploy-your-site.md
│  │  └── markdown-features.mdx
│  └── tutorial-extras
│     ├── _category_.json
│     ├── img
│     ├── manage-docs-versions.md
│     └── translate-your-site.md
```

- `docs/` 直下に intro.md のように直接ファイルを置いてもいいし、ディレクトリを挟んでもいい
- `docs/title.md`, `docs/title/index.md` のどちらでもいい
- `_category_.json` でサイドバーの設定ができる
  - label: 表示名
  - position: 順番
  - link: `generated-index` にすると小ページのリンクがパネル形式で表示される

```json
{
  "label": "Tutorial - Basics",
  "position": 2,
  "link": {
    "type": "generated-index",
    "description": "5 minutes to learn the most important Docusaurus concepts."
  }
}
```

- ドキュメントの frontmatter
  - sidebar_position: label 内での表示順序を指定
  - slug: URL の path 指定
  - title: sidebar, パンくずリストに表示されるタイトル。指定しない場合は md 内の `# title` が入る。
  - sidebar_label: docs 直下に作成した場合にlabel を指定する

```md
---
sidebar_position: 2
slug: hello
title: short title
---

# Very looooooooooooooooooooooooooooong title
```

## Page

```text
├── src
│  ├── components
│  │  └── HomepageFeatures
│  ├── css
│  │  └── custom.css
│  └── pages
│     ├── index.module.css
│     ├── index.tsx
│     ├── markdown-page.md
│     └── my-react-page.js
```

- docs, blog 以外に独立してページを作成する場合に使用する
- `src/pages/index.*` -> `/`, `src/pages/foo.md` -> `/foo` のように対応する

## Markdown features

### Admonitions

```md
:::tip My tip
Use this awesome feature option
:::

:::info
info
:::

:::caution
caution
:::

:::danger Take care
This action is dangerous
:::
```

### Code block

- ファイル名の表示

````md
```jsx title="src/components/HelloDocusaurus.js"
function HelloDocusaurus() {
    return (
        <h1>Hello, Docusaurus!</h1>
    )
}
```
````

- ハイライト

````md
```js title="sidebars.js"
module.exports = {
  tutorialSidebar: [
    'intro',
    // highlight-next-line
    'hello',
    {
      type: 'category',
      label: 'Tutorial',
      items: ['tutorial-basics/create-a-document'],
    },
  ],
};
```
````

````md
```text title="my-doc.md"
// highlight-start
---
id: my-doc-id
title: My document title
description: My document description
slug: /my-custom-url
---
// highlight-end

## Markdown heading

Markdown text with [links](./hello.md)
```
````

## i18n

- 各言語に対応した `docs` のファイルは `i18n/locale/docusaurus-plugin-content-docs/current` に保存する。
- `blog`, `pages` は current なし。

```text
.
├── babel.config.js
├── blog
│  ├── 2019-05-28-first-blog-post.md
│  ├── 2019-05-29-long-blog-post.md
│  ├── 2021-08-01-mdx-blog-post.mdx
│  ├── 2021-08-26-welcome
│  └── authors.yml
├── docs
│  ├── intro.md
│  ├── tutorial-basics
│  └── tutorial-extras
├── docusaurus.config.js
├── i18n
│  └── en
│     ├── docusaurus-plugin-content-docs  <-- english version of docs
│     │  └── current
│     │     ├── intro.md
│     │     ├── tutorial-basics
│     │     └── tutorial-extras
│     ├── docusaurus-plugin-content-blog  <-- english version of blog
│     │  ├── 2019-05-28-first-blog-post.md
│     │  ├── 2019-05-29-long-blog-post.md
│     │  ├── 2021-08-01-mdx-blog-post.mdx
│     │  ├── 2021-08-26-welcome
│     │  └── authors.yml
│     └── socusaurus-plugin-content-pages <-- english version of pages
│        ├── index.module.css
│        ├── index.tsx
│        ├── markdown-page.md
│        └── my-react-page.js
├── package.json
├── README.md
├── sidebars.js
├── src
│  ├── components
│  │  └── HomepageFeatures
│  ├── css
│  │  └── custom.css
│  └── pages
│     ├── index.module.css
│     ├── index.tsx
│     ├── markdown-page.md
│     └── my-react-page.js
```

## local search

- 検索機能はいくつか方法がある（[Search](https://docusaurus.io/docs/search)）
  - Local search の場合は下記リンクのプラグインを使える
  - [Local Search](https://docusaurus.io/community/resources#search)

- docusaurus-lunr-search を使う場合は下記を実行

```sh
yarn add docusaurus-lunr-search
```

- docusaurus.config.js にプラグインを追加する。

```js
module.exports = {
  // ...
  plugins: [require.resolve('docusaurus-lunr-search')],
}
```
