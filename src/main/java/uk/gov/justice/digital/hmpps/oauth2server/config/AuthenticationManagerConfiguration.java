package uk.gov.justice.digital.hmpps.oauth2server.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationProvider;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import uk.gov.justice.digital.hmpps.oauth2server.resource.LoggingAccessDeniedHandler;
import uk.gov.justice.digital.hmpps.oauth2server.resource.RedirectingLogoutSuccessHandler;
import uk.gov.justice.digital.hmpps.oauth2server.security.ApiAuthenticationProvider;
import uk.gov.justice.digital.hmpps.oauth2server.security.JwtAuthenticationSuccessHandler;
import uk.gov.justice.digital.hmpps.oauth2server.security.JwtCookieAuthenticationFilter;
import uk.gov.justice.digital.hmpps.oauth2server.security.UserDetailsServiceImpl;

@Configuration
@Order(4)
public class AuthenticationManagerConfiguration extends WebSecurityConfigurerAdapter {

    private final UserDetailsService userDetailsService;
    private final LoggingAccessDeniedHandler accessDeniedHandler;
    private final RedirectingLogoutSuccessHandler logoutSuccessHandler;
    private final JwtAuthenticationSuccessHandler jwtAuthenticationSuccessHandler;
    private final JwtCookieAuthenticationFilter jwtCookieAuthenticationFilter;
    private final String jwtCookieName;

    @java.beans.ConstructorProperties({"userDetailsService", "accessDeniedHandler", "logoutSuccessHandler", "jwtAuthenticationSuccessHandler", "jwtCookieAuthenticationFilter"})
    @Autowired
    public AuthenticationManagerConfiguration(final UserDetailsService userDetailsService,
                                              final LoggingAccessDeniedHandler accessDeniedHandler,
                                              final RedirectingLogoutSuccessHandler logoutSuccessHandler,
                                              final JwtAuthenticationSuccessHandler jwtAuthenticationSuccessHandler,
                                              final JwtCookieAuthenticationFilter jwtCookieAuthenticationFilter,
                                              @Value("${jwt.cookie.name}") final String jwtCookieName) {
        this.userDetailsService = userDetailsService;
        this.accessDeniedHandler = accessDeniedHandler;
        this.logoutSuccessHandler = logoutSuccessHandler;
        this.jwtAuthenticationSuccessHandler = jwtAuthenticationSuccessHandler;
        this.jwtCookieAuthenticationFilter = jwtCookieAuthenticationFilter;
        this.jwtCookieName = jwtCookieName;
    }

    @Override
    protected void configure(final HttpSecurity http) throws Exception {
        // @formatter:off
        http
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)

            // Can't have CSRF protection as requires session
            .and().csrf().disable()

            .authorizeRequests()
                .anyRequest().authenticated()

            .and()
                .formLogin()
                .loginPage("/login")
                .successHandler(jwtAuthenticationSuccessHandler)
                .permitAll()

            .and()
                .logout()
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies(jwtCookieName)
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessHandler(logoutSuccessHandler)
                .logoutSuccessUrl("/login?logout")
                .permitAll()

            .and()
                .exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler)

            .and()
                .addFilterAfter(jwtCookieAuthenticationFilter, BasicAuthenticationFilter.class);
        // @formatter:on
    }

    @Override
    public void configure(final WebSecurity web) {
        web
                .ignoring()
                .antMatchers("/css/**", "/img/**", "/font/**", "/webjars/**", "/favicon.ico",
                        "/health", "/info", "/error",
                        "/h2-console/**", "/v2/api-docs",
                        "/swagger-ui.html", "/swagger-resources", "/swagger-resources/configuration/ui",
                        "/swagger-resources/configuration/security");
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) {
        auth.authenticationProvider(authenticationProvider());
        auth.authenticationProvider(preAuthProvider());
    }


    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new ApiAuthenticationProvider();
        provider.setUserDetailsService(userDetailsService);
        return provider;
    }

    @Bean
    public PreAuthenticatedAuthenticationProvider preAuthProvider() {
        PreAuthenticatedAuthenticationProvider preAuth = new PreAuthenticatedAuthenticationProvider();
        preAuth.setPreAuthenticatedUserDetailsService((UserDetailsServiceImpl) userDetailsService);
        return preAuth;
    }

    @Bean
    public HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }

    @Bean
    public FilterRegistrationBean registration(final JwtCookieAuthenticationFilter filter) {
        // have to explicitly disable the filter otherwise it will be registered with spring as a global filter
        final FilterRegistrationBean registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }
}
