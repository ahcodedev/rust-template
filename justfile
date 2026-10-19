# List available recipes
help:
    @just --list

# Add rustup to PATH if missing, then install the pinned toolchain
setup:
    #!/usr/bin/env bash
    set -euo pipefail
    # Homebrew links rustup but not the cargo/rustc proxies, so check for cargo
    if ! command -v cargo >/dev/null; then
        if ! command -v brew >/dev/null; then
            echo "rustup not found. Install it with 'brew bundle' or from https://rustup.rs" >&2
            exit 1
        fi
        rustup_bin="$(brew --prefix rustup)/bin"
        if [ ! -x "$rustup_bin/rustup" ]; then
            echo "rustup not installed. Run 'brew bundle' first." >&2
            exit 1
        fi
        case "$(basename "${SHELL:-zsh}")" in
            bash) rc="$HOME/.bash_profile" ;;
            *) rc="$HOME/.zshrc" ;;
        esac
        if ! grep -qs 'brew --prefix rustup' "$rc"; then
            echo 'export PATH="$(brew --prefix rustup)/bin:$HOME/.cargo/bin:$PATH"' >> "$rc"
            echo "Added rustup to PATH in $rc. Restart your terminal or run: source $rc"
        fi
        export PATH="$rustup_bin:$HOME/.cargo/bin:$PATH"
    fi
    rustup toolchain install
    rustc --version
    cargo --version

# Build the project (pass extra flags, e.g. `just build --release`)
build *args:
    cargo build {{args}}

# Run tests (pass extra args, e.g. `just test greeting`)
test *args:
    cargo test {{args}}

# Format all code
fmt:
    cargo fmt --all

# Check formatting and run clippy with warnings as errors
lint:
    cargo fmt --all --check
    cargo clippy --all-targets --all-features -- -D warnings
