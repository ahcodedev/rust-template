# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Commands

Run project tasks through `just` (see `justfile`) rather than calling `cargo` directly. On macOS, Homebrew's `rustup` is keg-only, so `cargo` may not be on the shell PATH; the `justfile` adds it for every recipe.

- `just setup` - install Homebrew dependencies, the pinned toolchain and the prek Git hooks (`prek.toml`), which run `just lint` before each commit
- `just build` - build (pass extra flags, e.g. `just build --release`)
- `just test` - run tests (pass a filter, e.g. `just test greeting`)
- `just fmt` - format all code
- `just lint` - check formatting, run clippy with warnings as errors, and check GitHub Actions workflows with actionlint and zizmor
- `just gitleaks` - scan the Git history for committed secrets

Run `just fmt` and `just lint` after making changes; CI runs `just lint` and `just test` and fails on any warning, and scans the Git history for secrets with gitleaks.

## Git hooks

prek (`prek.toml`) runs `just lint` and a gitleaks scan of the staged changes before each commit.

- Don't bypass the hooks with `--no-verify`; fix the reported problem instead
- If gitleaks flags a secret, remove it from the change rather than adding an allowlist entry, unless asked

## Layout

- `src/lib.rs` - library crate; put application logic here so it can be tested
- `src/main.rs` - thin binary entry point that calls into the library
- `tests/` - integration tests against the library's public API
- `.github/workflows/rust.yml` - CI; actions are pinned to commit hashes with a version comment, keep that style
- `.github/workflows/dependabot-auto-merge.yml` - auto-merges Dependabot patch and minor updates once CI passes
- `.github/dependabot.yml` - weekly Dependabot updates for Cargo and GitHub Actions, with a 7-day cooldown
- `.github/pull_request_template.md` - PR description checklist; follow it when writing PR descriptions

## Toolchain

- The Rust version is pinned in `rust-toolchain.toml`; don't change it unless asked
- Edition 2024; minimum supported Rust version is set by `rust-version` in `Cargo.toml`

## Template

This project was generated from a Copier template. `.copier-answers.yml` is managed by Copier; don't edit it by hand. Template updates are pulled in with `copier update`.
