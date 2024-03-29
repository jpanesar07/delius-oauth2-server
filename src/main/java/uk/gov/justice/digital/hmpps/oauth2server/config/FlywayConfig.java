package uk.gov.justice.digital.hmpps.oauth2server.config;

import org.flywaydb.core.Flyway;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.flyway.FlywayDataSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.context.annotation.Profile;

import javax.sql.DataSource;
import java.util.List;

@Configuration
public class FlywayConfig {

    @Bean(name = "authFlyway", initMethod = "migrate")
    @FlywayDataSource
    public Flyway authFlyway(@Qualifier("authDataSource") final DataSource authDataSource,
                             @Value("${auth.flyway.locations}") final List<String> flywayLocations) {
        final var flyway = Flyway.configure()
                .dataSource(authDataSource)
                .locations(flywayLocations.toArray(new String[0]))
                .load();
        flyway.migrate();
        return flyway;
    }

    @Bean(name = "nomisFlyway", initMethod = "migrate")
    @FlywayDataSource
    @Primary
    @Profile("nomis-seed")
    public Flyway nomisFlyway(@Qualifier("dataSource") final DataSource dataSource,
                              @Value("${nomis.flyway.locations}") final List<String> flywayLocations) {
        final var flyway = Flyway.configure()
                .dataSource(dataSource)
                .locations(flywayLocations.toArray(new String[0]))
                .installedBy("nomis-seed")
                .load();
        flyway.migrate();
        return flyway;
    }
}
