package ec.com.ecommerce.modules.country.domain.usecases;

import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;

/**
 * CreateCountryUseCase
 * This interface defines the contract for creating a new country in the system.
 */
public interface CreateCountryUseCase {
    /**
     * Executes the use case to create a new country.
     *
     * @param request the request object containing the details of the country to be created
     */
    void execute(CreateCountryRequest request);
}
