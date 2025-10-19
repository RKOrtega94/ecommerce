package ec.com.ecommerce.grpc_lib.commons;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.netflix.appinfo.InstanceInfo;
import com.netflix.discovery.DiscoveryClient;
import io.grpc.ManagedChannel;
import io.grpc.ManagedChannelBuilder;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.util.List;

/**
 * Abstract base class for gRPC clients.
 *
 * @param <T>
 */
@Slf4j
public abstract class GrpcClient<T> {
    protected final DiscoveryClient discoveryClient;
    protected final String serviceName;
    protected ManagedChannel channel;
    protected T stub;
    private Integer cachedPort = null;

    @Value("${spring.config.import}")
    private String configImport;
    @Value("${spring.profiles.active:default}")
    private String profile;

    protected GrpcClient(DiscoveryClient discoveryClient, String serviceName) {
        this.discoveryClient = discoveryClient;
        this.serviceName = serviceName;
        initializeChanel();
    }

    protected abstract T createStub(ManagedChannel channel);

    public T getStub() {
        if (stub == null) stub = createStub(channel);
        return stub;
    }

    private void initializeChanel() {
        try {
            InstanceInfo instance = getServiceInstance();
            int port = getPort(serviceName);
            channel = ManagedChannelBuilder.forAddress(instance.getIPAddr(), port).usePlaintext().build();
        } catch (Exception ex) {
            log.error("Error initializing gRPC channel for service {}: {}", serviceName, ex.getMessage());
            throw new RuntimeException("Failed to initialize gRPC channel", ex);
        }
    }

    private InstanceInfo getServiceInstance() {
        List<InstanceInfo> instances = discoveryClient.getInstancesById(serviceName);
        if (instances == null || instances.isEmpty()) {
            throw new RuntimeException("No instances available for service: " + serviceName);
        }
        return instances.getFirst();
    }

    /**
     * Shuts down the gRPC channel when the bean is destroyed.
     *
     * @param serviceName the name of the service
     * @return the gRPC server port
     */
    private int getPort(String serviceName) {
        if (cachedPort != null) return cachedPort;
        try {
            int grpcPort = 9090;
            String configServer = configImport.replace("optional:configserver:", "");
            URI uri = URI.create(String.format("%s/%s/%s", configServer, serviceName.toLowerCase(), profile));
            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder().uri(uri).GET().build();
            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response.body());
            JsonNode propertySources = root.path("propertySources");
            for (JsonNode source : propertySources) {
                JsonNode props = source.path("source");
                if (props.has("spring.grpc.server.port")) {
                    grpcPort = props.get("spring.grpc.server.port").asInt();
                    break;
                }
            }
            cachedPort = grpcPort;
            return cachedPort;
        } catch (IOException e) {
            log.error("IO Exception while fetching port from config server: {}", e.getMessage());
            throw new RuntimeException(e);
        } catch (InterruptedException e) {
            log.error("Interrupted Exception while fetching port from config server: {}", e.getMessage());
            throw new RuntimeException(e);
        }
    }
}
