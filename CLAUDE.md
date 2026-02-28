# CLAUDE.md - 项目配置

## 权限说明

已在 `.claude/settings.local.json` 中配置了持久化权限，包括 xelatex、bibtex、ls、字体查询等命令，下次会话自动生效，无需再次确认。

## 编译流程

每次修改 `.tex`、`.bib` 或图片等资源文件后，必须自行完成编译，无需等待用户指示。使用项目根目录的 `build.sh` 脚本：

- **完整编译**（涉及参考文献变更）：`./build.sh`
- **快速编译**（仅修改正文内容）：`./build.sh quick`

## resource 目录

`/Users/zyj/repository/BUPTGraduateThesisLatexTemplate/resource/` 目录中的文件均为软连接，指向外部资源。不要在此目录中复制或创建新文件。

软连接详情记录在 `/Users/zyj/repository/BUPTGraduateThesisLatexTemplate/resource/README.md`，主要包括：

- `figures` -> 论文图片资源
- `tables` -> 论文表格资源
- `data` -> 论文数据资源
- `system_demo` -> 系统演示截图
- `design` -> 设计文档（markdown 源稿）

引用图片时直接使用 `resource/figures/` 下的路径（已在 `\graphicspath` 中配置）。
