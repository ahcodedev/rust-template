# List available recipes
[private]
default:
    @just --list

# Render the template into a temp directory, then lint and test the generated project
test-template:
    #!/usr/bin/env bash
    set -euo pipefail
    tmp="$(mktemp -d "${TMPDIR:-/tmp}/test-template.XXXXXX")"
    trap 'rm -rf "$tmp"' EXIT
    # -r HEAD renders the current checkout, including uncommitted changes
    copier copy --defaults -r HEAD \
        -d project_name=test-project \
        -d author_name=Test \
        -d copyright_year={{ datetime("%Y") }} \
        "{{ justfile_directory() }}" "$tmp/test-project"
    cd "$tmp/test-project"
    just lint
    just test
