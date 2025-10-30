package ec.com.ecommerce.modules.country.application.dtos.request;

/**
 * CreateCountryRequest
 *
 * @param name           country name
 * @param code           country code
 * @param phoneCode      country phone code
 * @param currency       country currency
 * @param currencySymbol country currency symbol
 */
public record CreateCountryRequest(String name, String code, String phoneCode, String currency, String currencySymbol) {
}

