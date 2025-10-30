package ec.com.ecommerce.modules.country.application.ports.in;

import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import ec.com.ecommerce.modules.country.application.mapper.CountryMapper;
import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.usecases.RetrieveCountriesUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class RetrieveCountriesPort implements RetrieveCountriesUseCase {
    private final CountryMapper mapper;
    private final CountryRepository repository;

    @Override
    public Page<CountryResponse> execute(Map<String, Object> params) {
        return repository.findAll(params).map(mapper::toResponse);
    }
}
