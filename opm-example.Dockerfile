# Builds a container to serve a sqlite file database/index.db on the build file system via grpc
# Uses quay.io/operator-framework/upstream-opm-builder instead
# of quay.io/operator-framework/upstream-registry-builder as in index.Dockerfile
FROM quay.io/operator-framework/upstream-opm-builder AS builder

FROM scratch
LABEL operators.operatorframework.io.index.database.v1=./index.db
COPY database ./
COPY --from=builder /bin/opm /opm
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe
EXPOSE 50051
ENTRYPOINT ["/opm"]
CMD ["registry", "serve", "--database", "index.db"]
