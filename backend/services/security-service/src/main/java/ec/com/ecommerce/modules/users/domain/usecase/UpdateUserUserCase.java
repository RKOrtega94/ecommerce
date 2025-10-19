package ec.com.ecommerce.modules.users.application.ports.in;

import ec.com.ecommerce.modules.users.application.dtos.request.UpdateUserRequest;

import java.util.UUID;

/**
 * UpdateUserUserCase defines the contract for updating an existing user in the system.
 */
public interface UpdateUserUserCase {
    void execute(UUID id, UpdateUserRequest request);
}
