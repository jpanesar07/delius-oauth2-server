package uk.gov.justice.digital.hmpps.oauth2server.config;

import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.assertj.core.api.Assertions.assertThat;

public class PasswordConfigTest {
    private final PasswordEncoder passwordEncoder = new PasswordConfig().passwordEncoder();

    @Test
    public void encodePassword() {
        final var encoded = passwordEncoder.encode("some_password_123456");
        assertThat(encoded).hasSize(68).startsWith("{bcrypt}");
    }

    @Test
    public void testMatchesWithNoDefaultPasswordEncoding() {
        final var encodedPassword = new BCryptPasswordEncoder().encode("some_pass");
        assertThat(passwordEncoder.matches("some_pass", encodedPassword)).isTrue();
    }
}
