package ec.com.ecommerce.modules.country.application.dtos.response;

import ec.com.ecommerce.enums.Status;

import java.util.UUID;

/**
 * CountryResponse
 *
 * @param id             country id
 * @param name           country name
 * @param code           country code
 * @param phoneCode      country phone code
 * @param currency       country currency
 * @param currencySymbol country currency symbol
 * @param status         country status
 */
public record CountryResponse(UUID id, String name, String code, String phoneCode, String currency,
                              String currencySymbol, Status status) {
}
