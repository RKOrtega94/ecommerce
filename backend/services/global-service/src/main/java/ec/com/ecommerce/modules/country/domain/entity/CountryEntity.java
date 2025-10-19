package ec.com.ecommerce.modules.country.domain;

import ec.com.ecommerce.entities.BaseEntity;
import ec.com.ecommerce.enums.Status;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "countries")
public class CountryEntity extends BaseEntity {
    private String name;
    private String code;
    @Column(name = "phone_code")
    private String phoneCode;
    private String currency;
    @Column(name = "currency_symbol")
    private String currencySymbol;
    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(name = "currency_code")
    private Status status = Status.ACTIVE;
}
