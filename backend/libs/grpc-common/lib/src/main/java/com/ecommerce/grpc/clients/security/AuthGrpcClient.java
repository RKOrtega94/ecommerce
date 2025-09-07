package com.ecommerce.grpc.clients.security;

import com.ecommerce.grpc.security.auth.proto.AuthServiceGrpc;
import com.ecommerce.grpc.security.auth.proto.RegisterRequest;
import com.ecommerce.grpc.security.auth.proto.RegisterResponse;
import com.ecommerce.grpc.utils.GrpcClient;
import io.grpc.ManagedChannel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Slf4j
@Service
public class AuthGrpcClient extends GrpcClient<AuthServiceGrpc.AuthServiceBlockingStub> {
    protected AuthGrpcClient(@Value("${ecommerce.grpc.client.security-server.address:localhost:9090}") String clientHost) {
        super(clientHost);
    }

    /**
     * @param channel the ManagedChannel to be used for creating the stub
     * @return the gRPC stub of type AuthServiceFutureStub
     */
    @Override
    protected AuthServiceGrpc.AuthServiceBlockingStub buildStub(ManagedChannel channel) {
        return AuthServiceGrpc.newBlockingStub(channel);
    }

    /**
     * Calls the register method on the gRPC AuthService.
     *
     * @param request the RegisterRequest containing user registration details
     * @return a CompletableFuture of RegisterResponse
     */
    public RegisterResponse register(RegisterRequest request) {
        return getStub().register(request);
    }
}
