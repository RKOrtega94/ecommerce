package ec.com.ecommerce.modules.country.application.service;

import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import org.springframework.data.domain.Page;

import java.util.Map;
import java.util.UUID;

public interface CountryService {
    void save(CreateCountryRequest request);

    void update(UUID id, UpdateCountryRequest request);

    Page<CountryResponse> retrieve(Map<String, Object> params);

    CountryResponse findById(UUID id);

    void delete(UUID id);
}
