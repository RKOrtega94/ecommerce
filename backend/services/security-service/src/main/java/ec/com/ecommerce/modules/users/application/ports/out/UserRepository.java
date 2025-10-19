package ec.com.ecommerce.modules.users.application.ports.out;

import ec.com.ecommerce.modules.users.domain.entity.UserEntity;
import org.springframework.data.domain.Page;

import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * UserRepositoryPort defines the contract for user repository operations.
 * It includes methods for saving, finding by username or ID, and retrieving all users with pagination.
 */
public interface UserRepositoryPort {
    /**
     * Saves a UserEntity to the repository.
     *
     * @param entity the UserEntity to be saved
     */
    void save(UserEntity entity);

    /**
     * Finds a UserEntity by its username.
     *
     * @param username the username of the user to find
     * @return an Optional containing the found UserEntity, or empty if not found
     */
    Optional<UserEntity> findByUsername(String username);

    /**
     * Finds a UserEntity by its ID.
     *
     * @param id the UUID of the user to find
     * @return an Optional containing the found UserEntity, or empty if not found
     */
    Optional<UserEntity> findById(UUID id);

    /**
     * Finds all UserEntities with pagination and filtering based on provided parameters.
     *
     * @param params a map of parameters for filtering and pagination
     * @return a paginated list of UserEntities
     */
    Page<UserEntity> findAll(Map<String, Object> params);
}
