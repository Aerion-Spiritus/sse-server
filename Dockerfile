FROM rust:1.82-alpine AS builder

ENV CARGO_REGISTRIES_CRATES_IO_PROTOCOL=sparse

WORKDIR /sse-server
RUN apk add --no-cache musl-dev
RUN mkdir src && touch -d 1980-01-01 src/lib.rs
COPY Cargo.lock .
COPY Cargo.toml .
RUN cargo build --release --locked
RUN rm -r src

COPY src src
RUN cargo build --release --locked


FROM alpine
COPY --from=builder /sse-server/target/release/sse-server /sse-server
ADD Rocket.toml .

ENTRYPOINT /sse-server
EXPOSE 8000
