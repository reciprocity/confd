.PHONY: build install clean test integration integration-docker dep release
VERSION=`egrep -o '[0-9]+\.[0-9a-z.\-]+' cmd/confd/version.go`
GIT_SHA=`git rev-parse --short HEAD || echo`

build:
	@echo "Building confd..."
	@mkdir -p bin
	@go build -ldflags "-X main.GitSHA=${GIT_SHA}" -o bin/confd ./cmd/confd

install:
	@echo "Installing confd..."
	@install -c bin/confd /usr/local/bin/confd

clean:
	@rm -f bin/*

test:
	@echo "Running tests..."
	@go test `go list ./... | grep -v vendor/`

integration:
	@echo "Running integration tests..."
	@for i in `find ./test/integration -name test.sh`; do \
		echo "Running $$i"; \
		bash $$i || exit 1; \
		bash test/integration/expect/check.sh || exit 1; \
		rm /tmp/confd-*; \
	done

integration-docker:
	@docker compose -p confd-integration -f test/docker-compose.yml up --build -d 2>/dev/null; \
	docker compose -p confd-integration -f test/docker-compose.yml logs -f test-runner; \
	exit_code=$$(docker inspect confd-integration-test-runner-1 --format='{{.State.ExitCode}}'); \
	docker compose -p confd-integration -f test/docker-compose.yml down 2>/dev/null; \
	exit $$exit_code

mod:
	@go mod tidy


snapshot:
	@goreleaser --clean --snapshot --skip=publish

release:
	@goreleaser --clean --skip=publish,validate
