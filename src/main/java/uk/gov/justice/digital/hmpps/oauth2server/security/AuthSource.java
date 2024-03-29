package uk.gov.justice.digital.hmpps.oauth2server.security;

import com.fasterxml.jackson.annotation.JsonValue;

import java.util.Optional;

public enum AuthSource {
    NOMIS, AUTH, NONE;

    @JsonValue
    public String getSource() {
        return name().toLowerCase();
    }

    public static AuthSource fromNullableString(final String source) {
        return Optional.ofNullable(source).map(s -> valueOf(source.toUpperCase())).orElse(NONE);
    }
}
