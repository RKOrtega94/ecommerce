package ec.com.ecommerce.modules.users.application.ports.in;

import ec.com.ecommerce.modules.users.application.dtos.request.CreateUserRequest;

/**
 * CreateUserUseCase defines the contract for creating a new user in the system.
 */
public interface CreateUserUseCase {
    /**
     * Executes the use case to create a new user.
     *
     * @param request the request object containing user creation details
     */
    void execute(CreateUserRequest request);
}
