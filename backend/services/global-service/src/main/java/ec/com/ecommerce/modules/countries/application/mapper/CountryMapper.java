package ec.com.ecommerce.modules.country.application.mapper;

import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import ec.com.ecommerce.modules.country.domain.entity.CountryEntity;
import org.mapstruct.Mapper;
import org.mapstruct.MappingTarget;
import org.mapstruct.ReportingPolicy;

import static org.mapstruct.MappingConstants.ComponentModel.SPRING;

/**
 * CountryMapper
 */
@Mapper(componentModel = SPRING, unmappedTargetPolicy = ReportingPolicy.IGNORE, unmappedSourcePolicy = ReportingPolicy.IGNORE)
public interface CountryMapper {
    /**
     * toEntity
     *
     * @param request CreateCountryRequest
     * @return CountryEntity
     */
    CountryEntity toEntity(CreateCountryRequest request);

    /**
     * update
     *
     * @param entity  the entity to be updated
     * @param request the request with the new values
     */
    void update(@MappingTarget CountryEntity entity, UpdateCountryRequest request);

    /**
     * toResponse
     *
     * @param entity CountryEntity
     * @return CountryResponse
     */
    CountryResponse toResponse(CountryEntity entity);
}
