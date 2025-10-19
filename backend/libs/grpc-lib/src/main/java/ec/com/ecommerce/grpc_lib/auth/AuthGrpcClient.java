package ec.com.ecommerce.grpc_lib.auth;

import ec.com.ecommerce.grpc_lib.commons.GrpcClient;
import io.grpc.ManagedChannel;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import com.netflix.discovery.DiscoveryClient;

@Slf4j
public class AuthGrpcClient extends GrpcClient<AuthServiceGrpc.AuthServiceBlockingStub> {
    private static final String SERVICE_NAME = "SECURITY-SERVICE";

    @Autowired(required = false)
    public AuthGrpcClient(DiscoveryClient discoveryClient) {
        super(discoveryClient, SERVICE_NAME);
    }

    @Override
    protected AuthServiceGrpc.AuthServiceBlockingStub createStub(ManagedChannel channel) {
        return AuthServiceGrpc.newBlockingStub(channel);
    }

    /**
     * Authenticate user
     *
     * @param request the authentication request
     * @return the authentication response
     */
    public AuthenticateResponse authenticate(AuthenticateRequest request) {
        return getStub().authenticate(request);
    }
}
