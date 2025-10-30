package ec.com.ecommerce.modules.country.domain.usecases;

import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import org.springframework.data.domain.Page;

import java.util.Map;

public interface RetrieveCountriesUseCase {
    Page<CountryResponse> execute(Map<String, Object> params);
}
