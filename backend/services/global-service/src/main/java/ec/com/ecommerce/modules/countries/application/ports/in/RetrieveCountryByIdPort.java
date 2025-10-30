package ec.com.ecommerce.modules.country.application.ports.in;

import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import ec.com.ecommerce.modules.country.application.mapper.CountryMapper;
import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.usecases.RetrieveCountryByIdUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RetrieveCountryByIdPort implements RetrieveCountryByIdUseCase {
    private final CountryMapper mapper;
    private final CountryRepository repository;

    @Override
    public CountryResponse execute(UUID id) {
        return repository.findById(id).map(mapper::toResponse).orElseThrow(() -> new IllegalArgumentException("Country not found with id: " + id));
    }
}
