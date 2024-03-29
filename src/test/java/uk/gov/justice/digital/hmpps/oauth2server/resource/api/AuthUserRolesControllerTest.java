package uk.gov.justice.digital.hmpps.oauth2server.resource.api;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.Authority;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.UserEmail;
import uk.gov.justice.digital.hmpps.oauth2server.maintain.AuthUserRoleService;
import uk.gov.justice.digital.hmpps.oauth2server.maintain.AuthUserRoleService.AuthUserRoleException;
import uk.gov.justice.digital.hmpps.oauth2server.maintain.AuthUserRoleService.AuthUserRoleExistsException;
import uk.gov.justice.digital.hmpps.oauth2server.model.AuthUserRole;
import uk.gov.justice.digital.hmpps.oauth2server.model.ErrorDetail;
import uk.gov.justice.digital.hmpps.oauth2server.security.UserService;

import java.security.Principal;
import java.util.Map;
import java.util.Optional;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@RunWith(MockitoJUnitRunner.class)
public class AuthUserRolesControllerTest {
    private static final Map<String, String> ALLOWED_AUTH_USER_ROLES = Map.of("ROLE_LICENCE_VARY", "Licence Variation", "ROLE_LICENCE_RO", "Licence Responsible Officer", "ROLE_GLOBAL_SEARCH", "Global Search");

    private final Principal principal = new UsernamePasswordAuthenticationToken("bob", "pass");

    @Mock
    private UserService userService;
    @Mock
    private AuthUserRoleService authUserRoleService;

    private AuthUserRolesController authUserRolesController;

    @Before
    public void setUp() {
        authUserRolesController = new AuthUserRolesController(userService, authUserRoleService);
    }

    @Test
    public void roles_userNotFound() {
        final var responseEntity = authUserRolesController.roles("bob");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("Not Found", "Account for username bob not found", "username"));
    }

    @Test
    public void roles_success() {
        when(authUserRoleService.getAllRoles()).thenReturn(ALLOWED_AUTH_USER_ROLES);
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        final var responseEntity = authUserRolesController.roles("joe");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        //noinspection unchecked
        assertThat(((Set) responseEntity.getBody())).containsOnly(new AuthUserRole("FRED", "FRED"), new AuthUserRole("Global Search", "GLOBAL_SEARCH"));
    }

    @Test
    public void addRole_userNotFound() {
        final var responseEntity = authUserRolesController.addRole("bob", "role", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("Not Found", "Account for username bob not found", "username"));
    }

    @Test
    public void addRole_success() throws AuthUserRoleException {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        final var responseEntity = authUserRolesController.addRole("someuser", "role", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(204);
        verify(authUserRoleService).addRole("USER", "role", "bob");
    }

    @Test
    public void addRole_conflict() throws AuthUserRoleException {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        doThrow(new AuthUserRoleExistsException()).when(authUserRoleService).addRole(anyString(), anyString(), anyString());

        final var responseEntity = authUserRolesController.addRole("someuser", "joe", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(409);
    }

    @Test
    public void addRole_validation() throws AuthUserRoleException {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));

        doThrow(new AuthUserRoleException("role", "error")).when(authUserRoleService).addRole(anyString(), anyString(), anyString());
        final var responseEntity = authUserRolesController.addRole("someuser", "harry", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(400);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("role.error", "role failed validation", "role"));
    }

    @Test
    public void removeRole_userNotFound() {
        final var responseEntity = authUserRolesController.removeRole("bob", "role", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("Not Found", "Account for username bob not found", "username"));
    }

    @Test
    public void removeRole_success() throws AuthUserRoleException {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        final var responseEntity = authUserRolesController.removeRole("someuser", "joe", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(204);
        verify(authUserRoleService).removeRole("USER", "joe", "bob");
    }

    @Test
    public void removeRole_roleMissing() throws AuthUserRoleException {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        doThrow(new AuthUserRoleException("role", "error")).when(authUserRoleService).removeRole(anyString(), anyString(), anyString());

        final var responseEntity = authUserRolesController.removeRole("someuser", "harry", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(400);
    }

    private UserEmail getAuthUser() {
        final var user = new UserEmail("USER", "email", true, false);
        user.setAuthorities(Set.of(new Authority("GLOBAL_SEARCH"), new Authority("FRED")));
        return user;
    }
}
