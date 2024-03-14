FROM ghcr.io/gleam-lang/gleam:v1.0.0-erlang-alpine AS builder
WORKDIR /app
COPY . .
RUN gleam test
RUN gleam export erlang-shipment

FROM docker.io/erlang:26.2.3.0-alpine AS release
COPY --from=builder /app/build/erlang-shipment/ /opt/deploy/
CMD ["/opt/deploy/entrypoint.sh", "run"]