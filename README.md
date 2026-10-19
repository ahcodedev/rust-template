# rust-template

Rust Project Template

## Setup

### macOS

- Install Homebrew dependencies - `brew bundle`
  - May require updating path - `export PATH="$(brew --prefix rustup)/bin:$HOME/.cargo/bin:$PATH"`
    - Add it to `~/.zshrc` to make it permanent
- Install the Rust toolchain pinned in `rust-toolchain.toml` - `rustup toolchain install`
- Verify the setup - `just test`

### Dev Container

- Open the repo in VS Code and run **Dev Containers: Reopen in Container**
  - Rust, `just`, and the recommended extensions are installed automatically

## Project Commands

Commands are defined in the `justfile` and run with [just](https://github.com/casey/just).

- List available commands - `just` or `just help`
- Add rustup to PATH if missing and install the pinned toolchain - `just setup`
- Build the project - `just build`
  - Pass extra flags - `just build --release`
- Run tests - `just test`
  - Pass extra args - `just test greeting`
- Format all code - `just fmt`
- Check formatting and run clippy with warnings as errors - `just lint`
