#!/bin/bash
# 一键编译脚本
# 用法: ./build.sh [quick]
#   无参数: 完整编译（含参考文献）
#   quick:  快速编译（仅正文，不处理参考文献）

cd "$(dirname "$0")"

if [ "$1" = "quick" ]; then
    echo "==> 快速编译..."
    xelatex -interaction=nonstopmode main.tex
else
    echo "==> 第1次 xelatex（生成引用信息）..."
    xelatex -interaction=nonstopmode main.tex
    echo "==> bibtex（处理参考文献）..."
    bibtex main
    echo "==> 第2次 xelatex（插入参考文献）..."
    xelatex -interaction=nonstopmode main.tex
    echo "==> 第3次 xelatex（稳定页码和交叉引用）..."
    xelatex -interaction=nonstopmode main.tex
fi

echo "==> 编译完成: main.pdf"
