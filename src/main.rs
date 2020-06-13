use std::process::Command;

fn main() {
    let mut user = String::from_utf8(Command::new("whoami").output().unwrap().stdout).unwrap();
    user.pop();
    println!("I've once more been updated, and now I run as the user {}!", user)
}