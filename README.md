# Allen@lunarithm

Source code of my personal blog.

我的博客源码。

## Clone

```bash
git clone https://github.com/AllenWu233/lunarithm.git
git submodule update --init --recursive # needed when you reclone your repo (submodules may not get cloned automatically)
```

## 主题定制说明（Theme customisation）

本站基于 [risotto](https://github.com/joeroe/risotto)（作为 git submodule 置于 `themes/risotto/`），**不直接改动主题源码**，而是利用 Hugo 的「项目覆盖主题」机制：在项目根目录放置与主题同路径的文件进行覆盖，或在 `data/`、`assets/`、`layouts/` 中新增内容。以下是相对 `themes/risotto/` 所做的全部修改与补丁，代码和本README都基于[Deepseek Harness](https://www.deepseek.com/harness)生成。

> 声明：仅主题定制借助了AI，`posts/`里的文章如无备注皆为人工写作。

### layouts/（覆盖与新增模板）

**覆盖主题原有模板：**

| 文件                           | 说明                                                                                                                                                                     |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `layouts/index.html`           | 首页改为按「月魂（技术）/ 月韵（随笔）」两个栏目展示最近文章（数量由 `params.homePagePosts` 控制），含标题、日期与摘要，超出部分显示「查看更多」。                       |
| `layouts/_default/list.html`   | 分类/标签/系列列表页：为栏目名追加文章计数（`（N）`）；文章条目显示标题 + 日期 + 摘要。                                                                                  |
| `layouts/_default/single.html` | 文章页：aside 元信息本地化（作者 / 发布日期 / 最后更新）；支持 `toc` / `default_toc` 控制目录显隐；页脚按需加载 KaTeX 数学与 giscus 评论。                               |
| `layouts/partials/header.html` | 侧栏添加圆形头像（经 `img-src.html` 走 CDN），站点名改用 `params.prompt`。                                                                                               |
| `layouts/partials/head.html`   | 用 Hugo Pipes 将 `assets/css/*` 打包为 `css/custom.css` 并加 SRI 指纹，替代主题的 `static/css/custom.css`；加载 `code-copy.js`；站点资源 URL 由 `absURL` 改为 `relURL`。 |
| `layouts/partials/footer.html` | 自定义版权（`copyrightStartYear`–`now.Year`），并加入「萌ICP备20250495号」。                                                                                             |
| `layouts/partials/lang.html`   | 关闭主题默认的 `echo $LANG` 语言切换显示。                                                                                                                               |

**新增模板（主题中没有）：**

| 文件                                              | 说明                                                                                                                              |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| `layouts/_default/_markup/render-image.html`      | Markdown 图片渲染钩子：图片包裹 `<figure>`，以 alt 文本生成 `<figcaption>` 图注；本地图片经 CDN 输出、远程 URL 原样透传。         |
| `layouts/_default/_markup/render-blockquote.html` | 引用块渲染钩子：把 `[!NOTE]` / `[!WARN]` / `[!TODO]` 等告示块（admonition）渲染为彩色 callout，颜色取自 `data/admonitions.yaml`。 |
| `layouts/partials/img-src.html`                   | 静态资源 URL 助手：生产环境走 jsDelivr CDN（`AllenWu233/lunarithm@main/static/`），`hugo server` 时走本地；http(s) 地址原样透传。 |
| `layouts/partials/math.html`                      | 按需加载 KaTeX（CSS/JS + auto-render），配置 `$` / `$$` / `\(\)` / `\[\]` 分隔符并微调字号。                                      |
| `layouts/partials/giscus.html`                    | giscus 评论系统（仓库 `AllenWu233/lunarithm-comments`）。                                                                         |
| `layouts/partials/friend-cards.html`              | 友链卡片网格局部模板，含头像、悬停浮层（展示 URL / 简介 / 站长留言）。                                                            |
| `layouts/shortcodes/friends.html`                 | `{{< friends >}}` 短代码，读取 `data/friends.yaml`。                                                                              |
| `layouts/shortcodes/lost-friends.html`            | `{{< lost-friends >}}` 短代码，读取 `data/lost_friends.yaml`。                                                                    |
| `layouts/shortcodes/organizations.html`           | `{{< organizations >}}` 短代码，读取 `data/organizations.yaml`。                                                                  |

### data/（新增数据文件）

| 文件                      | 说明                                                                          |
| ------------------------- | ----------------------------------------------------------------------------- |
| `data/admonitions.yaml`   | `[!KEYWORD]` 告示块到强调色的映射（fix / warn / note / info / todo 等）。     |
| `data/friends.yaml`       | 友链数据（author / title / url / description / avatar / favicon / comment）。 |
| `data/lost_friends.yaml`  | 「可能已迷失的伙伴」友链数据（结构同上）。                                    |
| `data/organizations.yaml` | 「加入的组织」数据（结构同上）。                                              |

### assets/（新增样式与脚本）

| 文件                          | 说明                                                                                                                                 |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| `assets/css/fonts.css`        | 站点 webfont：Fira Mono（拉丁）+ LXGW WenKai Mono GB Screen（中日韩）+ Nerd Font 图标，重定义 `--font-monospace`。                   |
| `assets/css/headings.css`     | 覆盖主题统一 `1rem` 的标题字号，为 `h1`–`h5` 设置逐级递减字号，并保留侧栏 `h1.page__logo` 的小字号；新增栏目计数样式 `.term-count`。 |
| `assets/css/friend-cards.css` | 友链卡片样式（网格布局、头像、悬停浮层、窄屏单列）。                                                                                 |
| `assets/css/images.css`       | 图片 `<figure>` / 图注样式。                                                                                                         |
| `assets/css/code-copy.css`    | 代码块复制按钮样式。                                                                                                                 |
| `assets/css/admonitions.css`  | 告示块样式。                                                                                                                         |
| `assets/js/code-copy.js`      | 给每个代码块添加带语言名的复制按钮（点击复制到剪贴板）。                                                                             |

> 说明：上述 CSS 在 `layouts/partials/head.html` 中经 Hugo Pipes 打包为单个 `css/custom.css`（带 SRI 指纹），替换了主题默认的 `static/css/custom.css`。

### static/fonts/（新增字体）

| 文件                   | 说明                                                                                                                                        |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `static/fonts/*.woff2` | 站点 webfont：Fira Mono Regular/Bold、按全站字符子集化的 LXGW WenKai Mono GB Screen、Nerd Font Symbols，由 `scripts/gen-webfonts.sh` 生成。 |

### scripts/（新增脚本）

| 文件                      | 说明                                                                                                                                                                                                    |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `scripts/gen-webfonts.sh` | 重新生成站点 webfont：从系统字体提取 Fira Mono 并转 woff2；扫描 `content/`、`data/`、`layouts/`、`hugo.toml` 收集非 ASCII 字符，据此对 LXGW WenKai Mono 做子集化（另保留 CJK 标点 / 假名 / 全角区块）。 |

### hugo.toml（配置）

- 主题固定为 `risotto`，配色 `tokyo-night-dark`。
- 自定义参数：`copyrightStartYear`、`prompt`（侧栏站点名）、`homePagePosts`（首页文章数）、`comments`、`math`。
- 自定义菜单：`月轨（series）/ 月影（categories）/ 月痕（tags）/ 月渡（links）/ 逍遥乡（about）`。
- 新增 `series` 分类法，构成 category / tag / series 三元组。
- 分页 `pagerSize = 3`。
- `hugo server` 下为字体 / 图片 / 头像设置缓存头。

## Todo

- [x] Render images via CDN
- [x] Math render
- [x] Avatar
- [x] Better prompt
- [x] Article titles on main page
- [x] Comment system powered by giscus
- [x] Show last edit date
- [x] Card style friend links
- [x] Different font size for `#` to `#####`
- [x] Image description text
- [x] Todo style blocks, such as `[!NOTE]`, `[!WARN]`
- [x] Show language name on code blocks
