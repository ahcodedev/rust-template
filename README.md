# Rust Template

[![Template](https://github.com/ahcodedev/rust-template/actions/workflows/template.yml/badge.svg?branch=main)](https://github.com/ahcodedev/rust-template/actions/workflows/template.yml)
[![gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue)](https://github.com/gitleaks/gitleaks)
[![Copier](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/copier-org/copier/master/img/badge/badge-grayscale-inverted-border-orange.json)](https://github.com/copier-org/copier)
[![just](https://img.shields.io/badge/built%20with-just-blue)](https://github.com/casey/just)
[![prek](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/j178/prek/master/docs/assets/badge-v0.json)](https://github.com/j178/prek)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-blue?logo=dependabot)](https://docs.github.com/code-security/dependabot)
[![zizmor](https://img.shields.io/badge/%F0%9F%8C%88-zizmor-white?labelColor=white)](https://zizmor.sh/)

Rust project template for [Copier](https://copier.readthedocs.io/).

## Usage

- Create a new project - `copier copy gh:ahcodedev/rust-template path/to/new-project`
- Pull in template updates from inside a generated project - `just update-template` (runs `copier update`)

## Development

- Install `just` - `brew install just`
- Install Copier, rustup, tombi, actionlint, zizmor, prek and gitleaks with Homebrew, then cargo-binstall and the pinned Rust tools (cargo-deny, cargo-nextest, cargo-shear, cargo-llvm-cov, typos) with cargo - `just setup`
  - Change tool versions in `cargo_tools` at the top of the `justfile`; reinstall with `just install-tools`
  - Bump them all to the latest releases and install them - `just update-cargo-tools`
- Enable the Git hooks in `prek.toml` - `prek install`
  - Before each commit they run `just lint` and scan the staged changes for secrets with gitleaks

Commands are defined in the `justfile` and run with [just](https://github.com/casey/just).

- List available commands - `just`
- Format TOML files with tombi - `just fmt`
- Check spelling with typos, TOML formatting with tombi, and GitHub Actions workflows with actionlint and zizmor - `just lint`
- Render the template into a temp directory, then lint, test, check coverage and check dependencies of the generated project - `just test-template`
- Scan the Git history for committed secrets - `just gitleaks`

CI runs `just lint` and `just test-template`, scans the Git history for secrets with gitleaks, and audits the workflows with [zizmor-action](https://github.com/zizmorcore/zizmor-action).

- zizmor-action reports findings as code scanning alerts in the repository's Security tab rather than failing CI
  - Code scanning needs a public repo, or GitHub Advanced Security on a private one

## Dependency Updates

- Dependabot (`.github/dependabot.yml`) opens weekly PRs for GitHub Actions in this repo's workflows and in `template/`
  - Updates wait 7 days after a release before a PR is opened
- Patch and minor updates are auto-merged once CI passes (`.github/workflows/dependabot-auto-merge.yml`); major updates wait for review
  - Auto-merge needs "Allow auto-merge" turned on in the repository settings and a branch protection rule or ruleset on `main` that requires the CI checks
  - On GitHub Free, branch protection and auto-merge are only available for public repos
- Dependabot doesn't update the actionlint version in the workflows and dev container, the gitleaks version and image in the dev container, or anything in `.jinja` files

## Layout

- `copier.yml` - template questions and settings
- `template/` - files rendered into new projects; files ending in `.jinja` are templated
- `prek.toml` - Git hooks for this repo
- `.github/pull_request_template.md` - checklist filled into new PR descriptions
