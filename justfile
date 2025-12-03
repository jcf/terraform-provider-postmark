_default:
    @just fmt
    @just build
    @just lint
    @just test

# ------------------------------------------------------------------------------
# Development

# Format project files
[group('dev')]
fmt:
    treefmt

# Build the provider
[group('dev')]
build:
    go build ./...

# Run lints
[group('dev')]
lint:
    golangci-lint run ./...

# Run unit tests
[group('dev')]
test:
    go test ./...

# Run acceptance tests (requires POSTMARK_ACCOUNT_TOKEN)
[group('dev')]
testacc:
    TF_ACC=1 go test ./... -v -timeout 120m

# Install provider locally for testing
[group('dev')]
install:
    go build -gcflags="all=-N -l" -o terraform-provider-postmark
    mkdir -p ~/.terraform.d/plugins/jcf/terraform/postmark/1.0/darwin_arm64
    mv terraform-provider-postmark ~/.terraform.d/plugins/jcf/terraform/postmark/1.0/darwin_arm64/

# Clean build artifacts
[group('dev')]
clean:
    rm -rf dist/
    rm -f terraform-provider-postmark

# ------------------------------------------------------------------------------
# Release

# Create a new release (requires GPG_PRIVATE_KEY and PASSPHRASE env vars)
[group('release')]
tag version:
    #!/usr/bin/env zsh
    set -e
    if [[ ! "{{ version }}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo >&2 "Error: Version must be in format v0.0.0"
        exit 1
    fi
    git tag -a {{ version }} -m "Release {{ version }}"
    echo >&2 "✅ Tagged {{ version }}. Push with: git push origin {{ version }}"

# Release via goreleaser
[group('release')]
release:
    #!/usr/bin/env zsh
    set -e
    export GITHUB_TOKEN="$(gh auth token)"
    goreleaser release --clean

# Test goreleaser configuration without publishing
[group('release')]
release-test:
    goreleaser release --snapshot --clean

# Generate documentation
[group('release')]
docs:
    go generate ./...
