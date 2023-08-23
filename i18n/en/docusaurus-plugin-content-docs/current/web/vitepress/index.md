---
title: "Vitepress"
draft: false
weight: 999
---

## Links

- [VitePress](https://vitepress.dev/)

## Setup

```sh
yarn add vitepress
yarn vitepress init
```

- package.json に script が作成される

```json
{
  ...
  "scripts": {
    "docs:dev": "vitepress dev docs",
    "docs:build": "vitepress build docs",
    "docs:preview": "vitepress preview docs"
  },
  ...
}
```

- local でデプロイ:

```sh
yarn docs:dev
```

- html を docs/ にエクスポート:

```sh
yarn docs:build
```

- build してから local で確認:

```sh
yarn docs:preview
```

## Problems

- docs/ のサイドバーが自動で生成されない
  - 自分で `docs/.vitepress/config.mts` に書くか、自作するしかない
  - 一応自作したもの↓

```ts
function getContentsDir(dir) {
  const contentsDir = fs
    .readdirSync(`docs/${dir}`, { withFileTypes: true })
    .filter((dirent) => dirent.isDirectory())
    .map((dirent) => {
      const text = dirent.name;
      const link = `${dir}${text}/`;
      const items = getContentsDir(link);
      if (items.length == 0) return { text, link };
      else return { text, collapsed: true, items };
    });
  return contentsDir;
}

export default defineConfig({
  ...
  themeConfig: {
    ...
    sidebar: {
      "/contents/": [
        {
          text: "Contents",
          items: getContentsDir("contents/"),
        },
      ],
      "/blogs/": [
        {
          text: "Blogs",
          items: getContentsDir("blogs/"),
        },
      ],
    },
    ...
  }
  ...
})
```

- Blog を勝手にいい感じに表示してくれる機能がない。
  - タグをまとめたり、日付順に並んだリストを表示したりする機能がない
  - [jcamp-code/vitepress-blog-theme](https://github.com/jcamp-code/vitepress-blog-theme/tree/main) を使うとかなりいい感じ
