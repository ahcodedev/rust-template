# List available recipes
[private]
default:
    @just --list

# Homebrew's rustup is keg-only, so neither rustup nor its cargo/rustc proxies
# are on PATH. Prepend its bin directory for all recipes when Homebrew is available,
# plus Cargo's bin directory, where `just install-tools` puts the Rust tools.
rustup_prefix := `brew --prefix rustup 2>/dev/null || true`
cargo_bin := env("CARGO_HOME", home_directory() / ".cargo") / "bin"
export PATH := cargo_bin + ":" + if rustup_prefix != "" { rustup_prefix / "bin" + ":" + env("PATH") } else { env("PATH") }

# Rust tools installed by `just install-tools` as prebuilt binaries with cargo-binstall; bump versions here
binstall_version := "1.26.2"
cargo_tools := "cargo-deny@0.20.2 cargo-nextest@0.9.151 cargo-shear@1.14.0 cargo-llvm-cov@0.9.1 typos-cli@1.52.0"

# Install Homebrew dependencies and the Rust tools that `just lint` and `just test-template` need
setup:
    brew bundle install
    just install-tools

# Install the pinned Rust tools (`cargo_tools`), installing cargo-binstall from source first if it's missing
install-tools:
    command -v cargo-binstall >/dev/null || cargo install --locked cargo-binstall@{{binstall_version}}
    cargo binstall --no-confirm {{cargo_tools}}

# Bump `binstall_version` and the `cargo_tools` versions in this justfile to their latest releases, then install them
update-cargo-tools:
    #!/usr/bin/env bash
    set -euo pipefail
    latest() {
        local version
        version="$(cargo info --registry crates-io "$1" 2>/dev/null | sed -n 's/^version: \([^ ]*\).*/\1/p' | head -1)"
        [[ -n "$version" ]] || { echo "could not find the latest version of $1" >&2; exit 1; }
        echo "$version"
    }
    binstall="$(latest cargo-binstall)"
    tools=""
    for tool in {{cargo_tools}}; do
        name="${tool%@*}"
        tools+="${tools:+ }$name@$(latest "$name")"
    done
    # perl rather than sed -i, which takes different arguments on macOS and Linux; the versions are
    # passed through the environment so perl doesn't treat the `@` in `name@version` as an array
    BINSTALL="$binstall" TOOLS="$tools" perl -pi -e 's/^binstall_version := ".*"/binstall_version := "$ENV{BINSTALL}"/; s/^cargo_tools := ".*"/cargo_tools := "$ENV{TOOLS}"/' "{{justfile()}}"
    echo "binstall_version := \"$binstall\""
    echo "cargo_tools := \"$tools\""
    just install-tools

# Format TOML files
fmt:
    tombi format

# Check spelling with typos and TOML formatting with tombi, check GitHub Actions workflows with actionlint and audit them for security issues with zizmor
lint:
    typos
    tombi format --check
    actionlint .github/workflows/*.yml
    zizmor .

# Render the template into a temp directory, then lint, test, check coverage and check dependencies of the generated project
test-template:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/test-template.XXXXXX")"
    trap 'rm -rf "$tmp"' EXIT
    # -r HEAD renders the current checkout, including uncommitted changes
    copier copy --defaults -r HEAD \
        -d project_name=test-project \
        -d copyright_year={{ datetime("%Y") }} \
        "{{ justfile_directory() }}" "$tmp/test-project"
    cd "$tmp/test-project"
    just lint
    just test
    just coverage
    just deny

# Scan the Git history for committed secrets (pass extra flags, e.g. `just gitleaks --log-opts=-5`)
gitleaks *args:
    gitleaks git --redact {{args}}
