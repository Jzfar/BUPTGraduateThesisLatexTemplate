#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
TMP_DIR="$(mktemp -d "$ROOT_DIR/.regular-build.XXXXXX")"
BACKUP_MAIN="$TMP_DIR/main.tex.backup"

cleanup() {
  if [[ -f "$BACKUP_MAIN" ]]; then
    cp "$BACKUP_MAIN" "$ROOT_DIR/main.tex"
  fi
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "==> 备份 main.tex"
cp "$ROOT_DIR/main.tex" "$BACKUP_MAIN"
mkdir -p "$TMP_DIR/cache/fontconfig" "$TMP_DIR/texmf-var"
export XDG_CACHE_HOME="$TMP_DIR/cache"
export TEXMFVAR="$TMP_DIR/texmf-var"

cd "$ROOT_DIR"

echo "==> 切换为常规版 documentclass（移除 blind 选项）"
perl -0pi -e 's/(\\documentclass\[[^\]]*?),blind(\]\{buptthesis\})/$1$2/' main.tex

FIRST_CLASS_LINE="$(grep -m1 '^\\documentclass' main.tex)"
if [[ "$FIRST_CLASS_LINE" == *blind* ]]; then
  echo "错误：常规版 main.tex 仍包含 blind 选项：$FIRST_CLASS_LINE" >&2
  exit 1
fi

echo "==> 编译常规版 PDF"
bash build.sh

if grep -nE '^!|LaTeX Error|Package .* Error|Undefined control sequence|Emergency stop|Fatal error|No pages of output' main.log; then
  echo "错误：LaTeX 日志中发现致命错误，未生成常规版压缩包。" >&2
  exit 2
fi

if [[ ! -s main.pdf ]]; then
  echo "错误：未生成 main.pdf。" >&2
  exit 3
fi

echo "==> 写出常规版.pdf"
cp "$ROOT_DIR/main.pdf" "$ROOT_DIR/常规版.pdf"

echo "==> 打包常规版.zip"
zip -j -q "$TMP_DIR/常规版.zip" "$ROOT_DIR/常规版.pdf"
cp "$TMP_DIR/常规版.zip" "$ROOT_DIR/常规版.zip"

echo "==> 校验 zip"
unzip -t "$ROOT_DIR/常规版.zip"

echo "==> 完成: $ROOT_DIR/常规版.pdf"
echo "==> 完成: $ROOT_DIR/常规版.zip"
