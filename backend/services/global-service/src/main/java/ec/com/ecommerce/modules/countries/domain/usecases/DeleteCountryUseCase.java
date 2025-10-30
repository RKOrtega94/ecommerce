package ec.com.ecommerce.modules.country.domain.usecases;

import java.util.UUID;

/**
 * Use case for deleting a country by its unique identifier.
 */
public interface DeleteCountryUseCase {
    /**
     * Executes the deletion of a country by its ID.
     *
     * @param id the unique identifier of the country to be deleted
     */
    void execute(UUID id);
}
