use rust_template::greeting;

#[test]
fn greeting_says_hello() {
    assert_eq!(greeting(), "Hello, world!");
}
