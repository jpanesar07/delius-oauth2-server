package uk.gov.justice.digital.hmpps.oauth2server.resource;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.mockito.junit.MockitoJUnitRunner;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.Person;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.UserEmail;
import uk.gov.justice.digital.hmpps.oauth2server.maintain.CreateUserService;
import uk.gov.justice.digital.hmpps.oauth2server.maintain.CreateUserService.CreateUserException;
import uk.gov.justice.digital.hmpps.oauth2server.model.ErrorDetail;
import uk.gov.justice.digital.hmpps.oauth2server.resource.AuthUserController.AuthUser;
import uk.gov.justice.digital.hmpps.oauth2server.resource.AuthUserController.CreateUser;
import uk.gov.justice.digital.hmpps.oauth2server.security.NomisUserService;
import uk.gov.justice.digital.hmpps.oauth2server.security.UserDetailsImpl;
import uk.gov.justice.digital.hmpps.oauth2server.verify.VerifyEmailService.VerifyEmailException;
import uk.gov.service.notify.NotificationClientException;

import javax.persistence.EntityNotFoundException;
import javax.servlet.http.HttpServletRequest;
import java.security.Principal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.anySet;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@RunWith(MockitoJUnitRunner.class)
public class AuthUserControllerTest {
    @Mock
    private NomisUserService userService;
    @Mock
    private CreateUserService createUserService;
    @Mock
    private HttpServletRequest request;

    private AuthUserController authUserController;

    private final Principal principal = new UsernamePasswordAuthenticationToken("bob", "pass");

    @Before
    public void setUp() {
        authUserController = new AuthUserController(userService, createUserService, true);
    }

    @Test
    public void user_userNotFound() {
        final var responseEntity = authUserController.user("bob");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("Not Found", "Account for username bob not found", "username"));
    }

    @Test
    public void user_success() {
        when(userService.getAuthUserByUsername(anyString())).thenReturn(Optional.of(getAuthUser()));
        final var responseEntity = authUserController.user("joe");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        assertThat(responseEntity.getBody()).isEqualTo(new AuthUser("principal", "email", "Joe", "Bloggs", false, true));
    }

    @Test
    public void search() {
        when(userService.findAuthUsersByEmail(anyString())).thenReturn(List.of(getAuthUser()));
        final var responseEntity = authUserController.searchForUser("joe");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        assertThat(responseEntity.getBody()).isEqualTo(List.of(new AuthUser("principal", "email", "Joe", "Bloggs", false, true)));
    }

    @Test
    public void search_noResults() {
        when(userService.findAuthUsersByEmail(anyString())).thenReturn(Collections.emptyList());
        final var responseEntity = authUserController.searchForUser("joe");
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(204);
        assertThat(responseEntity.getBody()).isNull();
    }

    @Test
    public void createUser_AlreadyExists() throws NotificationClientException {
        when(userService.findUser(anyString())).thenReturn(Optional.of(new UserDetailsImpl("name", "bob", Collections.emptySet(), null)));
        final var responseEntity = authUserController.createUser("user", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(409);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("username.exists", "Username user already exists", "username"));
    }

    @Test
    public void createUser_BlankDoesntCallUserService() throws NotificationClientException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        final var responseEntity = authUserController.createUser("  ", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        verify(userService, never()).findUser(anyString());
    }

    @Test
    public void createUser_Success() throws NotificationClientException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        final var responseEntity = authUserController.createUser("newusername", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        assertThat(responseEntity.getBody()).isNull();
    }

    @Test
    public void createUser_trim() throws NotificationClientException, CreateUserException, VerifyEmailException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        authUserController.createUser("   newusername   ", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        verify(userService).findUser("newusername");
        verify(createUserService).createUser("newusername", "email", "first", "last", Collections.emptySet(), "http://some.url/auth/initial-password?token=", "bob");
    }

    @Test
    public void createUser_CreateUserError() throws NotificationClientException, CreateUserException, VerifyEmailException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        when(createUserService.createUser(anyString(), anyString(), anyString(), anyString(), anySet(), anyString(), anyString())).thenThrow(new CreateUserException("username", "errorcode"));
        final var responseEntity = authUserController.createUser("newusername", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(400);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("username.errorcode", "username failed validation", "username"));
    }

    @Test
    public void createUser_VerifyUserError() throws NotificationClientException, CreateUserException, VerifyEmailException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        when(createUserService.createUser(anyString(), anyString(), anyString(), anyString(), anySet(), anyString(), anyString())).thenThrow(new VerifyEmailException("reason"));
        final var responseEntity = authUserController.createUser("newusername", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(400);
        assertThat(responseEntity.getBody()).isEqualTo(new ErrorDetail("email.reason", "Email address failed validation", "email"));
    }

    @Test
    public void createUser_InitialPasswordUrl() throws NotificationClientException, CreateUserException, VerifyEmailException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));
        final var roles = Collections.<String>emptySet();

        authUserController.createUser("newusername", new CreateUser("email", "first", "last", roles), request, principal);

        verify(createUserService).createUser("newusername", "email", "first", "last", roles, "http://some.url/auth/initial-password?token=", "bob");
    }

    @Test
    public void createUser_NoAdditionalRoles() throws NotificationClientException, CreateUserException, VerifyEmailException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/auth/api/authuser/newusername"));

        authUserController.createUser("newusername", new CreateUser("email", "first", "last", null), request, principal);

        verify(createUserService).createUser("newusername", "email", "first", "last", Collections.emptySet(), "http://some.url/auth/initial-password?token=", "bob");
    }

    @Test
    public void createUser() throws NotificationClientException {
        when(request.getRequestURL()).thenReturn(new StringBuffer("http://some.url/api/authuser/newusername"));
        final var responseEntity = authUserController.createUser("newusername", new CreateUser("email", "first", "last", Collections.emptySet()), request, principal);

        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(200);
        assertThat(responseEntity.getBody()).isNull();
    }

    @Test
    public void enableUser() {
        final var responseEntity = authUserController.enableUser("user", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(204);
        verify(userService).enableUser("user", "bob");
    }

    @Test
    public void enableUser_notFound() {
        doThrow(new EntityNotFoundException("message")).when(userService).enableUser(anyString(), anyString());
        final var responseEntity = authUserController.enableUser("user", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
    }

    @Test
    public void disableUser() {
        final var responseEntity = authUserController.disableUser("user", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(204);
        verify(userService).disableUser("user", "bob");
    }

    @Test
    public void disableUser_notFound() {
        doThrow(new EntityNotFoundException("message")).when(userService).disableUser(anyString(), anyString());
        final var responseEntity = authUserController.disableUser("user", principal);
        assertThat(responseEntity.getStatusCodeValue()).isEqualTo(404);
    }

    private UserEmail getAuthUser() {
        final var user = new UserEmail("principal", "email", true, false);
        user.setPerson(new Person());
        user.getPerson().setFirstName("Joe");
        user.getPerson().setLastName("Bloggs");
        user.setEnabled(true);
        return user;
    }
}