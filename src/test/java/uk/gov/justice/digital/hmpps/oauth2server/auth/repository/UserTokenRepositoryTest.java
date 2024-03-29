package uk.gov.justice.digital.hmpps.oauth2server.auth.repository;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.transaction.TestTransaction;
import org.springframework.transaction.annotation.Transactional;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.UserEmail;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.UserToken;
import uk.gov.justice.digital.hmpps.oauth2server.auth.model.UserToken.TokenType;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@ActiveProfiles("dev")
@Transactional
public class UserTokenRepositoryTest {
    @Autowired
    private UserTokenRepository repository;
    @Autowired
    private UserEmailRepository userEmailRepository;

    @Test
    public void givenATransientEntityItCanBePersisted() {

        final var userEmail = transientUserEmail();
        userEmailRepository.save(userEmail);

        final var entity = new UserToken(TokenType.RESET, userEmail);
        final var persistedEntity = repository.save(entity);

        TestTransaction.flagForCommit();
        TestTransaction.end();

        assertThat(persistedEntity.getToken()).isNotNull();

        TestTransaction.start();

        final var retrievedEntity = repository.findById(entity.getToken()).orElseThrow();

        // equals only compares the business key columns
        assertThat(retrievedEntity).isEqualTo(entity);

        assertThat(retrievedEntity.getToken()).isEqualTo(entity.getToken());
        assertThat(retrievedEntity.getTokenType()).isEqualTo(entity.getTokenType());
        assertThat(retrievedEntity.getTokenExpiry()).isEqualTo(entity.getTokenExpiry());
        assertThat(retrievedEntity.getUserEmail()).isEqualTo(userEmail);
    }

    @Test
    public void givenAnExistingUserTheyCanBeRetrieved() {
        final var retrievedEntity = repository.findById("reset").orElseThrow();
        assertThat(retrievedEntity.getTokenType()).isEqualTo(TokenType.RESET);
        assertThat(retrievedEntity.getTokenExpiry()).isEqualTo(LocalDateTime.of(2018, 12, 10, 8, 55, 45));
        assertThat(retrievedEntity.getUserEmail().getUsername()).isEqualTo("LOCKED_USER");
    }

    @Test
    public void testFindByTokenAndTokenType() {
        final var lockedUser = userEmailRepository.findById("LOCKED_USER").orElseThrow();
        final var retrievedEntity = repository.findByTokenTypeAndUserEmail(TokenType.RESET, lockedUser).orElseThrow();
        assertThat(retrievedEntity.getToken()).isEqualTo("reset");
        assertThat(retrievedEntity.getTokenType()).isEqualTo(TokenType.RESET);
    }

    private UserEmail transientUserEmail() {
        final var email = new UserEmail();
        email.setUsername("user");
        email.setEmail("a@b.com");
        return email;
    }
}
