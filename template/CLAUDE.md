# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Commands

Run project tasks through `just` (see `justfile`) rather than calling `cargo` directly. On macOS, Homebrew's `rustup` is keg-only, so `cargo` may not be on the shell PATH, and neither may the tools in `~/.cargo/bin`; the `justfile` adds both for every recipe.

- `just setup` - install Homebrew dependencies, the pinned toolchain, the Rust tools (via `just install-tools`) and the prek Git hooks (`prek.toml`), which run `just lint` before each commit
- `just install-tools` - install the Rust tools pinned in `cargo_tools` at the top of the `justfile` with cargo-binstall; bump versions there
- `just update-cargo-tools` - bump `binstall_version` and `cargo_tools` in the `justfile` to the latest releases, then install them
- `just build` - build (pass extra flags, e.g. `just build --release`)
- `just test` - run tests with cargo-nextest, then doc tests with `cargo test --doc` (pass a filter, e.g. `just test greeting`)
- `just coverage` - run tests with coverage; fails below `coverage_threshold`% line coverage (set at the top of the `justfile`; `src/main.rs` excluded)
- `just fmt` - format all Rust and TOML code (rustfmt and tombi)
- `just lint` - check spelling with typos and Rust and TOML formatting, run clippy and rustdoc with warnings as errors (catches broken doc links), check for unused dependencies with cargo-shear, and check GitHub Actions workflows with actionlint and zizmor
- `just msrv` - check the project builds with its minimum supported Rust version (`rust-version` in `Cargo.toml`)
- `just deny` - check dependencies for security advisories, licenses, banned crates and sources (`deny.toml`)
- `just gitleaks` - scan the Git history for committed secrets

Run `just fmt` and `just lint` after making changes; CI runs `just lint`, `just test`, `just coverage`, `just deny` and `just msrv` and fails on any warning, scans the Git history for secrets with gitleaks, and audits the workflows with zizmor-action, which reports findings as code scanning alerts.

## Git hooks

prek (`prek.toml`) runs `just lint` and a gitleaks scan of the staged changes before each commit.

- Don't bypass the hooks with `--no-verify`; fix the reported problem instead
- If gitleaks flags a secret, remove it from the change rather than adding an allowlist entry, unless asked

## Layout

- `src/lib.rs` - library crate; put application logic here so it can be tested
- `src/main.rs` - thin binary entry point that calls into the library
- `tests/` - integration tests against the library's public API; add tests for new code so `just coverage` stays above the threshold, and don't lower `coverage_threshold` unless asked
- `bacon.toml` - optional bacon config; re-runs nextest on save
- `deny.toml` - cargo-deny rules; when adding a dependency with a new license, ask before adding it to `allow`
- `.github/workflows/rust.yml` - CI; actions are pinned to commit hashes with a version comment, keep that style
- `.github/workflows/dependabot-auto-merge.yml` - auto-merges Dependabot patch and minor updates once CI passes
- `.github/dependabot.yml` - weekly Dependabot updates for Cargo and GitHub Actions, with a 7-day cooldown
- `.github/pull_request_template.md` - PR description checklist; follow it when writing PR descriptions

## Toolchain

- The Rust version is pinned in `rust-toolchain.toml`; don't change it unless asked
- Edition 2024; minimum supported Rust version is set by `rust-version` in `Cargo.toml` and checked by `just msrv`; don't use features newer than it
- Lint levels are set in the `[lints]` table in `Cargo.toml`: `unsafe_code` is forbidden, public items and every crate root (including `main.rs` and each file in `tests/`) need doc comments, and clippy's pedantic lints are on. Fix lint warnings rather than adding `#[allow]` or changing `[lints]`, unless asked

## Template

This project was generated from a Copier template. `.copier-answers.yml` is managed by Copier; don't edit it by hand. Template updates are pulled in with `just update-template` (runs `copier update`; needs a clean Git working tree).
