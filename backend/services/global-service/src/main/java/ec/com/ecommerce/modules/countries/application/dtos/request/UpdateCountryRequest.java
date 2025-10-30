package ec.com.ecommerce.modules.country.application.dtos.request;

import ec.com.ecommerce.enums.Status;

/**
 * CreateCountryRequest
 *
 * @param name           country name
 * @param code           country code
 * @param phoneCode      country phone code
 * @param currency       country currency
 * @param currencySymbol country currency symbol
 */
public record UpdateCountryRequest(String name, String code, String phoneCode, String currency, String currencySymbol,
                                   Status status) {
}

