package ec.com.ecommerce.modules.country.domain.usecases;

import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;

import java.util.UUID;

/**
 * Use case for updating a country's information.
 */
public interface UpdateCountryUseCase {
    /**
     * Executes the update of a country's information.
     *
     * @param request the update country request DTO
     */
    void execute(UUID id, UpdateCountryRequest request);
}
