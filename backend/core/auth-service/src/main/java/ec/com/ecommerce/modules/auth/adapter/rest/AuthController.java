package ec.com.ecommerce.modules.auth.infrastructure.rest;

import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * AuthController handles authentication-related endpoints.
 */
@RestController
@RequestMapping("/auth")
public class AuthController {

    @PostMapping(value = "/login", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE, MediaType.APPLICATION_FORM_URLENCODED_VALUE}, produces = MediaType.APPLICATION_JSON_VALUE)
    public String login(@ModelAttribute Map<String, Object> body) {
        return "login";
    }
}
