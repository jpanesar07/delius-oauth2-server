package uk.gov.justice.digital.hmpps.oauth2server.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
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
import uk.gov.justice.digital.hmpps.oauth2server.security.JwtAuthenticationSuccessHandler;
import uk.gov.justice.digital.hmpps.oauth2server.security.JwtCookieAuthenticationFilter;
import uk.gov.justice.digital.hmpps.oauth2server.security.UserDetailsServiceImpl;
import uk.gov.justice.digital.hmpps.oauth2server.security.UserStateAuthenticationFailureHandler;

@Configuration
@Order(4)
public class AuthenticationManagerConfiguration extends WebSecurityConfigurerAdapter {

    private final UserDetailsService userDetailsService;
    private final LoggingAccessDeniedHandler accessDeniedHandler;
    private final RedirectingLogoutSuccessHandler logoutSuccessHandler;
    private final JwtAuthenticationSuccessHandler jwtAuthenticationSuccessHandler;
    private final JwtCookieAuthenticationFilter jwtCookieAuthenticationFilter;
    private final String jwtCookieName;
    private final CookieRequestCache cookieRequestCache;
    private final DaoAuthenticationProvider daoAuthenticationProvider;
    private final UserStateAuthenticationFailureHandler userStateAuthenticationFailureHandler;

    @Autowired
    public AuthenticationManagerConfiguration(final UserDetailsService userDetailsService,
                                              final LoggingAccessDeniedHandler accessDeniedHandler,
                                              final RedirectingLogoutSuccessHandler logoutSuccessHandler,
                                              final JwtAuthenticationSuccessHandler jwtAuthenticationSuccessHandler,
                                              final JwtCookieAuthenticationFilter jwtCookieAuthenticationFilter,
                                              @Value("${jwt.cookie.name}") final String jwtCookieName,
                                              final CookieRequestCache cookieRequestCache,
                                              final DaoAuthenticationProvider daoAuthenticationProvider,
                                              final UserStateAuthenticationFailureHandler userStateAuthenticationFailureHandler) {
        this.userDetailsService = userDetailsService;
        this.accessDeniedHandler = accessDeniedHandler;
        this.logoutSuccessHandler = logoutSuccessHandler;
        this.jwtAuthenticationSuccessHandler = jwtAuthenticationSuccessHandler;
        this.jwtCookieAuthenticationFilter = jwtCookieAuthenticationFilter;
        this.jwtCookieName = jwtCookieName;
        this.cookieRequestCache = cookieRequestCache;
        this.daoAuthenticationProvider = daoAuthenticationProvider;
        this.userStateAuthenticationFailureHandler = userStateAuthenticationFailureHandler;
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
                .antMatchers(HttpMethod.GET, "/login").permitAll()
                .antMatchers(HttpMethod.POST, "/login").permitAll()
                .antMatchers("/ui/**").access("isAuthenticated() and @authIpSecurity.check(request)")
                .anyRequest().authenticated()

            .and()
                .formLogin()
                .loginPage("/login")
                .successHandler(jwtAuthenticationSuccessHandler)
                .failureHandler(userStateAuthenticationFailureHandler)
                .permitAll()

            .and()
                .logout()
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies(jwtCookieName)
                .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                .logoutSuccessHandler(logoutSuccessHandler)
                .permitAll()

            .and()
                .exceptionHandling()
                .accessDeniedHandler(accessDeniedHandler)

            .and()
                .addFilterAfter(jwtCookieAuthenticationFilter, BasicAuthenticationFilter.class)

                .requestCache().requestCache(cookieRequestCache);
        // @formatter:on
    }

    @Override
    public void configure(final WebSecurity web) {
        web
                .ignoring()
                .antMatchers("/css/**", "/js/**", "/images/**", "/fonts/**", "/webjars/**", "/favicon.ico",
                        "/health", "/info", "/ping", "/error", "/terms", "/change-password", "/verify-email-confirm",
                        "/forgot-password", "/reset-password", "/set-password",
                        "/reset-password-confirm", "/reset-password-success", "/reset-password-select",
                        "/initial-password", "/initial-password-success",
                        "/h2-console/**", "/v2/api-docs", "/jwt-public-key",
                        "/swagger-ui.html", "/swagger-resources", "/swagger-resources/configuration/ui",
                        "/swagger-resources/configuration/security");
    }

    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(final AuthenticationManagerBuilder auth) {
        auth.authenticationProvider(daoAuthenticationProvider);
        auth.authenticationProvider(preAuthProvider());
    }


    @Bean
    public PreAuthenticatedAuthenticationProvider preAuthProvider() {
        final var preAuth = new PreAuthenticatedAuthenticationProvider();
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
        final var registration = new FilterRegistrationBean<>(filter);
        registration.setEnabled(false);
        return registration;
    }
}
