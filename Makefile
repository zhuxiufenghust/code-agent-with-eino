BINARY      ?= code-agent-with-eino
CMD_DIR     ?= ./cmd
BUILD_DIR   ?= bin
DIST_DIR    ?= dist

VERSION    ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
COMMIT     ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo unknown)
BUILD_TIME ?= $(shell date -u +%Y-%m-%dT%H:%M:%SZ)

LDFLAGS := -s -w \
	-X main.Version=$(VERSION) \
	-X main.Commit=$(COMMIT) \
	-X main.BuildTime=$(BUILD_TIME)

GO      ?= go
GOOS    ?= $(shell $(GO) env GOOS)
GOARCH  ?= $(shell $(GO) env GOARCH)

.PHONY: help all build install run test cover bench fmt vet lint tidy deps clean cross-compile

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "  build          编译到 $(BUILD_DIR)/$(BINARY)"
	@echo "  install        安装到 GOBIN"
	@echo "  run            直接运行"
	@echo "  test           运行单元测试"
	@echo "  cover          运行测试并生成覆盖率报告 coverage.html"
	@echo "  bench          运行基准测试"
	@echo "  fmt            格式化代码"
	@echo "  vet            静态检查"
	@echo "  lint           golangci-lint 检查（需自行安装）"
	@echo "  tidy           整理 go.mod / go.sum"
	@echo "  deps           下载依赖"
	@echo "  cross-compile  交叉编译 linux/darwin x amd64/arm64 到 $(DIST_DIR)"
	@echo "  clean          清理构建产物"

all: build

build:
	@mkdir -p $(BUILD_DIR)
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) $(GO) build -trimpath \
		-ldflags "$(LDFLAGS)" -o $(BUILD_DIR)/$(BINARY) $(CMD_DIR)

install:
	$(GO) install -trimpath -ldflags "$(LDFLAGS)" $(CMD_DIR)

run:
	$(GO) run $(CMD_DIR)

test:
	$(GO) test -race -cover ./...

cover:
	$(GO) test -race -coverprofile=coverage.out -covermode=atomic ./...
	$(GO) tool cover -html=coverage.out -o coverage.html
	@$(GO) tool cover -func=coverage.out | tail -n 1

bench:
	$(GO) test -run=^$$ -bench=. -benchmem ./...

fmt:
	$(GO) fmt ./...

vet:
	$(GO) vet ./...

lint:
	@command -v golangci-lint >/dev/null 2>&1 || { echo "golangci-lint not found, see https://golangci-lint.run/usage/install/"; exit 1; }
	golangci-lint run ./...

tidy:
	$(GO) mod tidy

deps:
	$(GO) mod download

cross-compile:
	@mkdir -p $(DIST_DIR)
	@for os in linux darwin; do \
		for arch in amd64 arm64; do \
			out=$(DIST_DIR)/$(BINARY)-$${os}-$${arch}; \
			echo "building $${out}"; \
			CGO_ENABLED=0 GOOS=$${os} GOARCH=$${arch} $(GO) build -trimpath \
				-ldflags "$(LDFLAGS)" -o $${out} $(CMD_DIR) || exit 1; \
		done \
	done

clean:
	rm -rf $(BUILD_DIR) $(DIST_DIR) coverage.out coverage.html
