# AGENTS.md

Guidance for AI agents working in this repository. Read this before making changes.

## Project

Personal blog "冰轮韵" (`lunarithm.space`) built with **Hugo** + the **risotto** theme (git submodule at `themes/risotto/`).

- Static site: build with `hugo`, dev with `hugo server` (localhost:1313).
- Deployed to GitHub Pages via `.github/workflows/deploy.yml` (runs `hugo`, pushes `public/` to `AllenWu233/AllenWu233.github.io`).
- Content is Chinese-first.

## Golden rule: override, don't fork

All customization lives in the project root (`layouts/`, `assets/`, `data/`, `static/`, `scripts/`, `hugo.toml`), overriding/extending the theme via Hugo's template lookup order. **Never edit files inside `themes/risotto/`** — it is a submodule.

## Hard constraints (do not violate)

1. **Do not apply `resources.Minify` to CSS.** Hugo's CSS minifier corrupts `unicode-range` values (`U+0000-00FF` → `U+??`, `U+3000-303F` → `U+30??`), which breaks font loading. Use `resources.Get` + `resources.Concat` + `resources.Fingerprint` only.

2. **Internal links use relative URLs** (`relURL`, `relLangURL`, `.RelPermalink`), never `absURL`/`BaseURL`/`.Permalink` for clickable links. Keep absolute URLs only where crawlers need them: RSS `<link>`, `og:url`, `og:image`, and the menu active-state comparison (`eq $currentPage.Permalink (.URL | absLangURL)`).

3. **Use `hugo.Data`, not `.Site.Data`** (deprecated).

## Conventions

### Code comments

- Comments are in **English**, concise, no step numbering. (User-facing replies are in Chinese, but committed code comments are English.)

### Assets (CSS/JS)

- Site CSS is split by feature in `assets/css/*.css`: `fonts`, `headings`, `friend-cards`, `images`, `code-copy`, `admonitions`.
- `layouts/partials/head.html` bundles them: `resources.Get` each file → `resources.Concat "css/custom.css"` → `resources.Fingerprint`.
- Add a new feature → add `assets/css/xxx.css` and register it in the `slice` in `head.html`.
- JS lives in `assets/js/` and is loaded the same way (fingerprinted).

### Fonts (self-hosted)

- `static/fonts/`: Fira Mono (Latin), LXGW WenKai Mono GB Screen (CJK), Nerd Font Symbols Mono (icons), all as `.woff2`.
- The CJK font is **subset to characters actually used on the site**. Regenerate via `scripts/gen-webfonts.sh` whenever new Chinese/kanji/kana characters are added to `content/`, `data/`, `layouts/`, or `hugo.toml`.
- Font faces declare `unicode-range` for on-demand loading; the stack is `--font-monospace` in `assets/css/fonts.css`.

### Images

- Markdown images go through `layouts/_default/_markup/render-image.html`: wrapped in `<figure>` with `<figcaption>` from the alt text.
- CDN routing is centralized in `layouts/partials/img-src.html`: production → jsDelivr (`https://cdn.jsdelivr.net/gh/AllenWu233/lunarithm@main/static/`), `hugo server` → local; remote `http(s)` URLs pass through unchanged.
- Local images in Markdown use basenames (`![](foo.jpg)`); the render hook prepends `images/`.

### Data-driven cards

Friend links / lost friends / organizations are data-driven and share one template:

- `data/friends.yaml` → `{{< friends >}}`
- `data/lost_friends.yaml` → `{{< lost-friends >}}`
- `data/organizations.yaml` → `{{< organizations >}}`
- shared markup: `layouts/partials/friend-cards.html`; field schema: `author` / `title` / `url` / `description` / `avatar` / `favicon` / `comment`.

### Admonitions / callouts

`[!KEYWORD]` blockquotes are rendered by `layouts/_default/_markup/render-blockquote.html`, colored via `data/admonitions.yaml` (keys are lowercase; base types `fix`/`warn`/`note`/`todo`/`hack`/`perf`/`test` plus aliases).

### Taxonomy counts

`layouts/_default/list.html` shows article counts (`（N）`) next to category/tag/series names, and renders post entries with title + date + description. The count is dynamic via `.Data.Plural`, and must use **both** `where` operators summed, because Hugo handles scalar vs slice front matter differently:

```go
{{ $key := printf "Params.%s" (.Data.Plural | default "categories") }}
{{ $n := len (where site.RegularPages $key "in" .Title) }}            // scalar: categories: "月魂"
{{ $m := len (where site.RegularPages $key "intersect" (slice .Title)) }} // slice: tags: [a, b]
{{ $count := add $n $m }}
```

### Front matter / taxonomy naming

- `categories` (月魂 = tech, 月韵 = essay/life), `series`, `tags`.
- Menu/section names: 月轨 (series), 月影 (categories), 月痕 (tags), 月渡 (links), 逍遥乡 (about).

## Gotchas

- `hugo server` does not cache static assets by default. `hugo.toml` `[server.headers]` sets `Cache-Control` for `/fonts/**`, `/images/**`, `/avatar.jpg` — keep this in place.
- Nerd Font icons are PUA codepoints; they render via the `NerdFontIcons` face in `--font-monospace`.

## Build / verify

```bash
hugo          # production build → public/
hugo server   # dev (localhost:1313)
hugo -D       # include drafts
```

- `public/` is gitignored (generated).
- After adding new Chinese text, run `scripts/gen-webfonts.sh` (requires system LXGW/Fira fonts + network; it fetches fontTools from a PyPI mirror).

## Commit style

Recent commits use concise prefixes (`Add:`, `Fix:`, `Refactor:`). Keep it consistent.
