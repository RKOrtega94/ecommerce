package ec.com.ecommerce.modules.country.adapter.rest;

import ec.com.ecommerce.models.ApiResponse;
import ec.com.ecommerce.models.PaginationResponse;
import ec.com.ecommerce.models.SuccessEmptyResponse;
import ec.com.ecommerce.models.SuccessResponse;
import ec.com.ecommerce.modules.country.application.dtos.request.CreateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.request.UpdateCountryRequest;
import ec.com.ecommerce.modules.country.application.dtos.response.CountryResponse;
import ec.com.ecommerce.modules.country.application.service.CountryService;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.UUID;

import static org.springframework.http.MediaType.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/v1/countries")
@Tag(name = "Countries", description = "Endpoints for managing countries")
public class CountryController {
    private final CountryService service;

    @PostMapping(consumes = {MULTIPART_FORM_DATA_VALUE, APPLICATION_FORM_URLENCODED_VALUE}, produces = APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse> createForm(@ModelAttribute @Valid CreateCountryRequest request) {
        service.save(request);
        SuccessEmptyResponse response = SuccessEmptyResponse.created("Country created successfully");
        return ResponseEntity.status(response.status()).body(response);
    }

    @PostMapping(consumes = APPLICATION_JSON_VALUE, produces = APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse> createJson(@RequestBody @Valid CreateCountryRequest request) {
        service.save(request);
        SuccessEmptyResponse response = SuccessEmptyResponse.created("Country created successfully");
        return ResponseEntity.status(response.status()).body(response);
    }

    @PutMapping(value = "/{id}", consumes = {MULTIPART_FORM_DATA_VALUE, APPLICATION_FORM_URLENCODED_VALUE}, produces = APPLICATION_JSON_VALUE)
    public ResponseEntity<ApiResponse> updateForm(@PathVariable("id") UUID id, @ModelAttribute @Valid UpdateCountryRequest request) {
        service.update(id, request);
        SuccessEmptyResponse response = SuccessEmptyResponse.ok("Country updated successfully");
        return ResponseEntity.ok(response);
    }

    @GetMapping
    public ResponseEntity<ApiResponse> retrieve(@RequestParam Map<String, Object> params) {
        var countries = service.retrieve(params);
        PaginationResponse<CountryResponse> response = PaginationResponse.from(countries, "Countries retrieved successfully");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> findById(@PathVariable("id") UUID id) {
        var country = service.findById(id);
        SuccessResponse<CountryResponse> response = SuccessResponse.ok(country, "Country retrieved successfully");
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable("id") UUID id) {
        service.delete(id);
        return ResponseEntity.noContent().build();
    }
}
