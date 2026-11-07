# Local macOS setup for working on this template. Install with: brew bundle

# Project template tool (see copier.yml)
brew "copier"
brew "just"

# Rust toolchain manager; `just setup` uses it to install cargo-binstall and the Rust tools
# (see `cargo_tools` in the justfile), and `just test-template` builds the generated project
brew "rustup"

# TOML formatter (run by `just lint`)
brew "tombi"

# GitHub Actions linters
brew "actionlint"
brew "zizmor"

# Git hook manager (see prek.toml); run `prek install` once to enable hooks
brew "prek"

# Secret scanner (prek hook and `just gitleaks`)
brew "gitleaks"
