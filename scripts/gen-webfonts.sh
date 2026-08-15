#!/usr/bin/env bash
# Regenerate site webfonts:
#   - Fira Mono (Regular/Bold) -> woff2
#   - LXGW WenKai Mono GB Screen -> subset to characters used in content/ -> woff2
# Requires: network (downloads fonttools wheel), woff2_compress, system fonts.
set -euo pipefail

cd "$(dirname "$0")/.."

FONT_DIR="static/fonts"
LXGW_SRC="/usr/share/fonts/TTF/LXGWWenKaiMonoGBScreen.ttf"
FIRAMONO_REG="/usr/share/fonts/TTF/FiraMono-Regular.ttf"
FIRAMONO_BOLD="/usr/share/fonts/TTF/FiraMono-Bold.ttf"

mkdir -p "$FONT_DIR"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Fetch fonttools (pure-python wheel) for subsetting
URL="$(curl -s https://pypi.org/pypi/fonttools/json | python3 -c "import json,sys;d=json.load(sys.stdin);print([u['url'] for u in d['urls'] if u['filename'].endswith('py3-none-any.whl')][0])")"
curl -sL -o "$TMP/ft.whl" "$URL"
unzip -q "$TMP/ft.whl" -d "$TMP/ft"

# Collect chars used in content: non-ASCII, excluding Nerd Font PUA icons
python3 - "$TMP/used.txt" <<'PY'
import glob, sys
chars = set()
for f in glob.glob('content/**/*.md', recursive=True):
    for ch in open(f, encoding='utf-8').read():
        cp = ord(ch)
        if cp < 0x80:
            continue            # ASCII -> Fira Mono
        if 0xE000 <= cp <= 0xF8FF or 0xF0000 <= cp <= 0xFFFFD:
            continue            # Nerd Font icons
        chars.add(ch)
with open(sys.argv[1], 'w', encoding='utf-8') as f:
    f.write(''.join(sorted(chars)))
print(f'{len(chars)} unique chars collected')
PY

# Subset LXGW to used chars + CJK punctuation/kana/fullwidth blocks
PYTHONPATH="$TMP/ft" python3 -m fontTools.subset "$LXGW_SRC" \
    --text-file="$TMP/used.txt" \
    --unicodes='U+2000-206F,U+3000-303F,U+3040-30FF,U+FF00-FFEF' \
    --output-file="$TMP/lxgw.ttf" \
    --no-hinting

woff2_compress "$TMP/lxgw.ttf" >/dev/null
cp "$TMP/lxgw.woff2" "$FONT_DIR/lxgw-wenkai-mono-gb-screen.woff2"

# Fira Mono weights
for src in "$FIRAMONO_REG" "$FIRAMONO_BOLD"; do
    cp "$src" "$TMP/$(basename "$src")"
    woff2_compress "$TMP/$(basename "$src")" >/dev/null
    cp "$TMP/$(basename "$src" .ttf).woff2" "$FONT_DIR"
done

echo "--- $FONT_DIR ---"
ls -la "$FONT_DIR"
