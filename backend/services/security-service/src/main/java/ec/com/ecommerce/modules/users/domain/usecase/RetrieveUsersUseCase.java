package ec.com.ecommerce.modules.users.application.ports.in;

import java.util.Map;
import java.util.Objects;

/**
 * RetrieveUsersUseCase defines the contract for retrieving users from the system.
 */
public interface RetrieveUsersUseCase {
    void execute(Map<String, Objects> params);
}
