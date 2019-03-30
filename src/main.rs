use actix_web::{http, server, App, Path, Responder};
use libc::{open, write, O_WRONLY};
use std::ffi::c_void;

const FIFO_NAME: *const i8 = "/tmp/i3debugger\0".as_ptr() as *const i8;
static mut FIFO: i32 = 0;

fn ping(msg: &str) {
    unsafe { write(FIFO, msg.as_bytes().as_ptr() as *const c_void, msg.len()) };
}

/// On success simply echo back the <id>
fn index(info: Path<String>) -> impl Responder {
    println!("Entering responder for '{}'", info);
    ping(&info);

    // ACK for our human users
    format!("ACK {}", info)
}

fn main() {
    // Lua promises to create a fifo for us 🤞
    unsafe { FIFO = open(FIFO_NAME, O_WRONLY) };

    server::new(|| App::new().route("/{id}/", http::Method::GET, index))
        .bind("127.0.0.1:1312")
        .expect("Failed to bind port")
        .run();
}
