package ec.com.ecommerce.modules.country.domain.usecases;

import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;

import java.util.UUID;

/**
 * Use case for retrieving a country by its unique identifier.
 */
public interface RetrieveCountryByIdUseCase {
    /**
     * Executes the retrieval of a country by its ID.
     *
     * @param id the unique identifier of the country
     * @return the country response DTO
     */
    CountryResponse execute(UUID id);
}
