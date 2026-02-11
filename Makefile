.PHONY: help serve build clean install check push cv

# 默认目标
help:
	@echo "Academic-Pages 可用命令:"
	@echo ""
	@echo "  make serve    - 启动本地开发服务器 (http://localhost:4000)"
	@echo "  make build    - 构建网站到 _site 目录"
	@echo "  make clean    - 清理生成的文件"
	@echo "  make install  - 安装/更新依赖"
	@echo "  make check    - 检查环境配置"
	@echo "  make cv       - 更新 CV：保留最新版本，删除旧版本，更新导航链接"
	@echo "  make push     - 强制提交并推送更改到远程仓库"
	@echo ""

# 启动开发服务器
serve:
	@echo "🚀 启动 Jekyll 开发服务器..."
	@echo "📱 访问地址: http://localhost:4000"
	@echo "💡 按 Ctrl+C 停止服务器"
	@echo ""
	bundle exec jekyll serve -l -H localhost

# 构建网站
build:
	@echo "🔨 构建网站..."
	bundle exec jekyll build
	@echo "✅ 构建完成: _site/"

# 清理生成的文件
clean:
	@echo "🧹 清理生成的文件..."
	rm -rf _site .jekyll-cache .jekyll-metadata
	@echo "✅ 清理完成"

# 安装依赖
install:
	@echo "📦 安装依赖..."
	bundle install
	@echo "✅ 依赖安装完成"

# 检查环境
check:
	@echo "🔍 检查环境配置..."
	@echo ""
	@echo "Ruby 版本:"
	@ruby --version
	@echo ""
	@echo "Bundler 版本:"
	@bundle --version
	@echo ""
	@echo "Jekyll 版本:"
	@bundle exec jekyll --version
	@echo ""
	@echo "✅ 环境检查完成"

push:
	git add .
	git commit --amend --no-edit
	git push -f

# 更新 CV：保留最新版本，删除旧版本，更新导航链接
cv:
	@FILES=$$(ls files/taocheng-cv-*.pdf 2>/dev/null | sort); \
	if [ -z "$$FILES" ]; then \
		echo "❌ 未找到 taocheng-cv-*.pdf 文件"; \
		exit 1; \
	fi; \
	LATEST=$$(echo "$$FILES" | tail -n 1); \
	FILENAME=$$(basename "$$LATEST"); \
	echo "📄 最新 CV: $$FILENAME"; \
	for f in $$FILES; do \
		if [ "$$f" != "$$LATEST" ]; then \
			echo "🗑️  删除: $$(basename $$f)"; \
			rm "$$f"; \
		fi; \
	done; \
	sed -i '' "s|url: /files/taocheng-cv-.*\.pdf|url: /files/$$FILENAME|g" _data/navigation.yml; \
	echo "✅ 导航已更新: /files/$$FILENAME"