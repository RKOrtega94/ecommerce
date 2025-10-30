package ec.com.ecommerce.modules.country.application.ports.in;

import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;
import ec.com.ecommerce.modules.country.application.mapper.CountryMapper;
import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.usecases.CreateCountryUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CreateCountryPort implements CreateCountryUseCase {
    private final CountryMapper mapper;
    private final CountryRepository repository;

    @Override
    public void execute(CreateCountryRequest request) {
        repository.save(mapper.toEntity(request));
    }
}
