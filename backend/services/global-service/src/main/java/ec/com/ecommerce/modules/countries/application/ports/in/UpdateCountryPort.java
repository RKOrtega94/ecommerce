package ec.com.ecommerce.modules.country.application.ports.in;

import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;
import ec.com.ecommerce.modules.country.application.mapper.CountryMapper;
import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.usecases.UpdateCountryUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UpdateCountryPort implements UpdateCountryUseCase {
    private final CountryMapper mapper;
    private final CountryRepository repository;

    @Override
    public void execute(UUID id, UpdateCountryRequest request) {
        repository.findById(id).ifPresentOrElse(countryEntity -> {
            mapper.update(countryEntity, request);
            repository.save(countryEntity);
        }, () -> {
            throw new IllegalArgumentException("Country not found with id: " + id);
        });
    }
}
