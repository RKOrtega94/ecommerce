package ec.com.ecommerce.modules.country.application.ports.in;

import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.usecases.DeleteCountryUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class DeleteCountryPort implements DeleteCountryUseCase {
    private final CountryRepository repository;

    @Override
    public void execute(UUID id) {
        repository.findById(id).ifPresentOrElse(repository::delete, () -> {
            throw new IllegalArgumentException("Country not found with id: " + id);
        });
    }
}
