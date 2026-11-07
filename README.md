# rust-template

Rust project template for [Copier](https://copier.readthedocs.io/).

## Usage

- Create a new project - `copier copy gh:<owner>/rust-template path/to/new-project`
- Pull in template updates from inside a generated project - `copier update`

## Layout

- `copier.yml` - template questions and settings
- `template/` - files rendered into new projects; files ending in `.jinja` are templated
