package ec.com.ecommerce.modules.country.application.service;

import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import ec.com.ecommerce.modules.country.domain.usecases.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CountryServiceImpl implements CountryService {
    private final CreateCountryUseCase createCountry;
    private final UpdateCountryUseCase updateCountry;
    private final RetrieveCountriesUseCase retrieveCountries;
    private final RetrieveCountryByIdUseCase retrieveCountryById;
    private final DeleteCountryUseCase deleteCountry;

    @Override
    public void save(CreateCountryRequest request) {
        createCountry.execute(request);
    }

    @Override
    public void update(UUID id, UpdateCountryRequest request) {
        updateCountry.execute(id, request);
    }

    @Override
    public Page<CountryResponse> retrieve(Map<String, Object> params) {
        return retrieveCountries.execute(params);
    }

    @Override
    public CountryResponse findById(UUID id) {
        return retrieveCountryById.execute(id);
    }

    @Override
    public void delete(UUID id) {
        deleteCountry.execute(id);
    }
}
