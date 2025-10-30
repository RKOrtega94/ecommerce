package ec.com.ecommerce.modules.country.domain.specification;

import ec.com.ecommerce.modules.country.domain.entity.CountryEntity;
import ec.com.ecommerce.specification.SpecificationBuilder;
import org.springframework.data.jpa.domain.Specification;

import java.util.Map;

/**
 * Utility class for building country specifications.
 */
public class CountrySpecificationBuilder {
    private CountrySpecificationBuilder() {
        throw new IllegalStateException("Utility class");
    }

    private static final String NAME = "name";
    private static final String CODE = "code";
    private static final String STATUS = "status";

    public static Specification<CountryEntity> countrySpecification(Map<String, Object> params) {
        SpecificationBuilder<CountryEntity> spec = SpecificationBuilder.builder();
        if (params.containsKey(NAME)) spec.like(NAME, params.get(NAME).toString());
        if (params.containsKey(CODE)) spec.equals(CODE, params.get(CODE).toString());
        if (params.containsKey(STATUS)) spec.equals(STATUS, params.get(STATUS).toString());
        else spec.notEquals(STATUS, "DELETED");
        return spec.build();
    }
}
