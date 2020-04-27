# Old Style - see opm-example.Dockerfile
# Example of a multi-stage build pulling the compiled binaries from the
# result of upstream-opm-builder.Dockerfile and placing them into a
# clean and trim registry server container.
FROM quay.io/operator-framework/upstream-registry-builder as builder

COPY manifests manifests
RUN /bin/initializer -o ./bundles.db

FROM scratch
COPY --from=builder /build/bundles.db /bundles.db
COPY --from=builder /bin/registry-server /registry-server
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
EXPOSE 50051
ENTRYPOINT ["/registry-server"]
CMD ["--database", "bundles.db"]
