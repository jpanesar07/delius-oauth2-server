package uk.gov.justice.digital.hmpps.oauth2server.repository;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.transaction.TestTransaction;
import org.springframework.transaction.annotation.Transactional;
import uk.gov.justice.digital.hmpps.oauth2server.model.Staff;
import uk.gov.justice.digital.hmpps.oauth2server.model.StaffIdentifier;
import uk.gov.justice.digital.hmpps.oauth2server.security.StaffIdentifierRepository;
import uk.gov.justice.digital.hmpps.oauth2server.security.StaffRepository;

import static org.assertj.core.api.Assertions.assertThat;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.MOCK)
@TestPropertySource(locations = "classpath:test-application-override.properties")
@Transactional
public class StaffIdentifierRepositoryTest {

    public static final long STAFF_ID = 3L;

    @Autowired
    private StaffRepository staffRepository;

    @Autowired
    private StaffIdentifierRepository repository;

    @Test
    public void givenATransientEntityItCanBePeristed() {

        Staff staff = staffRepository.findById(STAFF_ID).orElseThrow();
        assertThat(staff.getIdentifiers()).hasSize(0);

        StaffIdentifier newStaffId = staff.addIdentifier("WIBBLE", "WOBBLE");

        TestTransaction.flagForCommit();
        TestTransaction.end();

        assertThat(staff.getIdentifiers()).hasSize(1);

        TestTransaction.start();

        var retrievedEntity = staffRepository.findById(STAFF_ID).orElseThrow();

        assertThat(retrievedEntity.findIdentifier("WIBBLE")).isEqualTo(newStaffId);

    }

    @Test
    public void givenAnExistingStaffMemberTheyCanBeRetrieved() {

        var retrievedEntity = repository.findById_TypeAndId_IdentificationNumber("YJAF", "test@yjaf.gov.uk");

        var staff = retrievedEntity.getStaff();
        assertThat(staff).isNotNull();

        assertThat(staff.getFirstName()).isEqualTo("ITAG");
        assertThat(staff.getIdentifiers()).hasSize(1);
        assertThat(staff.findIdentifier("YJAF").getId().getIdentificationNumber()).isEqualTo("test@yjaf.gov.uk");
    }

}