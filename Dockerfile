# -------------------------------------------------------------------------------
# Cargo Build Stage
# -------------------------------------------------------------------------------

FROM rust:latest as cargo-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/rust-docker-sm-fast

COPY Cargo.toml Cargo.toml

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, then fubar\")}" > src/main.rs

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

RUN rm -f target/x86_64-unknown-linux-musl/release/deps/rust-docker-sm-fast*

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

# -------------------------------------------------------------------------------
# Final Build Stage
# -------------------------------------------------------------------------------

FROM alpine:latest

RUN addgroup -g 1000 rustapp

RUN adduser -D -s /bin/sh -u 1000 -G rustapp rustapp

WORKDIR /home/rustapp/bin/

COPY --from=cargo-build /usr/src/rust-docker-sm-fast/target/x86_64-unknown-linux-musl/release/rust-docker-sm-fast /usr/local/bin/rust-docker-sm-fast

RUN chown rustapp:rustapp /home/rustapp

USER rustapp

CMD ["rust-docker-sm-fast"]
