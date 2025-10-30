package ec.com.ecommerce.modules.country.adapter.persistence;

import ec.com.ecommerce.enums.Status;
import ec.com.ecommerce.modules.country.application.ports.out.CountryRepository;
import ec.com.ecommerce.modules.country.domain.entity.CountryEntity;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.stereotype.Repository;

import java.time.OffsetDateTime;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import static ec.com.ecommerce.modules.country.domain.specification.CountrySpecificationBuilder.countrySpecification;
import static ec.com.ecommerce.pagination.PaginationUtil.pageable;

@Repository
@RequiredArgsConstructor
public class CountryRepositoryAdapter implements CountryRepository {
    private final CountryJpaRepository jpa;

    @Override
    public void save(CountryEntity entity) {
        jpa.save(entity);
    }

    @Override
    public Optional<CountryEntity> findByCode(String code) {
        return jpa.findByCode(code);
    }

    @Override
    public Optional<CountryEntity> findById(UUID id) {
        return jpa.findById(id).filter(entity -> !entity.getStatus().equals(Status.DELETED));
    }

    @Override
    public Optional<CountryEntity> findByName(String name) {
        return jpa.findByName(name);
    }

    @Override
    public void delete(CountryEntity entity) {
        entity.setStatus(Status.DELETED);
        entity.setDeletedAt(OffsetDateTime.now());
        jpa.save(entity);
    }

    @Override
    public Page<CountryEntity> findAll(Map<String, Object> params) {
        return jpa.findAll(countrySpecification(params), pageable(params));
    }
}
