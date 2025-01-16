FROM rust:slim AS builder
ARG APP_NAME=Rusty

WORKDIR /app

COPY . .

RUN --mount=type=bind,source=src,target=src \
    --mount=type=bind,source=Cargo.toml,target=Cargo.toml \
    --mount=type=bind,source=Cargo.lock,target=Cargo.lock \
    --mount=type=cache,target=/app/target/ \
    --mount=type=cache,target=/usr/local/cargo/git/db \
    --mount=type=cache,target=/usr/local/cargo/registry/ \
    cargo install --path .

RUN cargo build --locked --release

RUN cp -f "./target/release/${APP_NAME}" "./binary"

FROM alpine:3.21.2

RUN apk add --no-cache libc6-compat

RUN apk add --no-cache libgcc

COPY --from=builder /app/binary .

ENTRYPOINT [ "./binary" ]