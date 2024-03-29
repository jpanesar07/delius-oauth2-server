package uk.gov.justice.digital.hmpps.oauth2server.security;

import org.junit.Test;
import org.springframework.mock.web.MockHttpServletRequest;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

public class AuthIpSecurityTest {

    private AuthIpSecurity testClass;

    @Test
    public void testStandardV4IP() {

        final var request = new MockHttpServletRequest();
        request.setRemoteAddr("127.0.0.1");

        testClass = new AuthIpSecurity(Set.of("0.0.0.0/0"));

        final var check = testClass.check(request);

        assertThat(check).isTrue();
    }

    @Test
    public void testRemoteAddressWithPort() {

        final var request = new MockHttpServletRequest();
        request.setRemoteAddr("82.34.12.11:13321");

        testClass = new AuthIpSecurity(Set.of("0.0.0.0/0"));

        final var check = testClass.check(request);

        assertThat(check).isTrue();
    }

    @Test
    public void testRemoteAddressWithPortNoInWhitelist() {

        final var request = new MockHttpServletRequest();
        request.setRemoteAddr("82.34.12.11:13321");

        testClass = new AuthIpSecurity(Set.of("82.34.12.10/32", "82.34.12.12/32"));

        final var check = testClass.check(request);

        assertThat(check).isFalse();
    }

    @Test
    public void testIpV6Address() {

        final var request = new MockHttpServletRequest();
        request.setRemoteAddr("0:0:0:0:0:0:0:1");

        testClass = new AuthIpSecurity(Set.of("0:0:0:0:0:0:0:1", "127.0.0.1/32"));

        final var check = testClass.check(request);

        assertThat(check).isTrue();
    }
}
