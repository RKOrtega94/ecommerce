package com.ecommerce.grpc.utils;

import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;

import javax.annotation.PreDestroy;

/**
 * Abstract gRPC client class to manage channel and stub creation.
 *
 * @param <T>
 */
public abstract class GrpcClient<T> {
    private final ManagedChannel channel;
    private final T stub;

    /**
     * Constructor to initialize gRPC client with the given host.
     *
     * @param clientHost the gRPC server host (e.g., "localhost:9090" or "https://localhost:9090")
     */
    protected GrpcClient(String clientHost) {
        if (clientHost.startsWith("http")) clientHost = clientHost.replaceFirst("https?://", "");
        String[] hostParts = clientHost.split(":");
        String host = hostParts[0];
        int port = hostParts.length > 1 ? Integer.parseInt(hostParts[1]) : 9090;
        this.channel = ManagedChannelBuilder.forAddress(host, port).usePlaintext().build();
        this.stub = buildStub(channel);
    }

    /**
     * Abstract method to build the gRPC stub using the provided channel.
     *
     * @param channel the ManagedChannel to be used for creating the stub
     * @return the gRPC stub of type T
     */
    protected abstract T buildStub(ManagedChannel channel);

    /**
     * Retrieves the gRPC stub.
     *
     * @return the gRPC stub of type T
     */
    public T getStub() {
        if (stub == null) {
            return buildStub(channel);
        }
        return stub;
    }

    /**
     * Shuts down the gRPC channel when the bean is destroyed.
     */
    @PreDestroy
    public void shutdown() {
        if (channel != null && !channel.isShutdown()) {
            channel.shutdown();
        }
    }
}
