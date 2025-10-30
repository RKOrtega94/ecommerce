package ec.com.ecommerce.modules.states.domain;

import ec.com.ecommerce.entities.BaseEntity;
import ec.com.ecommerce.modules.countries.domain.entity.CountryEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "states")
public class StateEntity extends BaseEntity {
    @Column(name = "name", nullable = false, length = 100)
    private String name;
    
    private CountryEntity country;
}
