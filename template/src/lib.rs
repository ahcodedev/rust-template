//! Library crate: application logic lives here so it can be tested.

/// Returns the greeting printed by the binary.
#[must_use]
pub fn greeting() -> String {
    String::from("Hello, world!")
}
