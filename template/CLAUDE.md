# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Commands

Run project tasks through `just` (see `justfile`) rather than calling `cargo` directly. On macOS, Homebrew's `rustup` is keg-only, so `cargo` may not be on the shell PATH; the `justfile` adds it for every recipe.

- `just setup` - install Homebrew dependencies and the pinned toolchain
- `just build` - build (pass extra flags, e.g. `just build --release`)
- `just test` - run tests (pass a filter, e.g. `just test greeting`)
- `just fmt` - format all code
- `just lint` - check formatting and run clippy with warnings as errors

Run `just fmt` and `just lint` after making changes; CI runs `just lint` and `just test` and fails on any warning.

## Layout

- `src/lib.rs` - library crate; put application logic here so it can be tested
- `src/main.rs` - thin binary entry point that calls into the library
- `tests/` - integration tests against the library's public API

## Toolchain

- The Rust version is pinned in `rust-toolchain.toml`; don't change it unless asked
- Edition 2024; minimum supported Rust version is set by `rust-version` in `Cargo.toml`

## Template

This project was generated from a Copier template. `.copier-answers.yml` is managed by Copier; don't edit it by hand. Template updates are pulled in with `copier update`.
