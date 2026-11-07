//! Library crate for the project.
//!
//! Application logic lives here rather than in `main.rs`, so it can be covered by unit tests,
//! the integration tests in `tests/`, and doc tests.

/// Returns the greeting printed by the binary.
#[must_use]
pub fn greeting() -> String {
    String::from("Hello, world!")
}
