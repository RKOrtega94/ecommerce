package ec.com.ecommerce.modules.auth.application.dtos.request;

public record RequestRequest(String firstname, String lastname, String email, String password, String confirmPassword) {
}
