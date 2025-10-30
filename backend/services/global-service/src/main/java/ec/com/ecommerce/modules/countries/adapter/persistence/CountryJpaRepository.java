package ec.com.ecommerce.modules.country.adapter.persistence;

import ec.com.ecommerce.modules.country.domain.entity.CountryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * JPA repository interface for CountryEntity.
 * Extends JpaRepository, PagingAndSortingRepository, and JpaSpecificationExecutor
 * to provide CRUD operations, pagination, sorting, and specification execution capabilities.
 */
@Repository
public interface CountryJpaRepository extends JpaRepository<CountryEntity, UUID>, PagingAndSortingRepository<CountryEntity, UUID>, JpaSpecificationExecutor<CountryEntity> {
    /**
     * Finds a CountryEntity by its code.
     *
     * @param code the country code
     * @return an Optional containing the found CountryEntity, or empty if not found
     */
    Optional<CountryEntity> findByCode(String code);

    /**
     * Finds a CountryEntity by its name.
     *
     * @param name the country name
     * @return an Optional containing the found CountryEntity, or empty if not found
     */
    Optional<CountryEntity> findByName(String name);
}
