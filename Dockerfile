FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_DB=postgres
ENV KC_PROXY=edge
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT=false
ENV KC_PROXY_HEADERS=xforwarded
ENV KC_HTTP_PORT=8080
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true
ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=${KC_BOOTSTRAP_ADMIN_PASSWORD}
ENV KC_BOOTSTRAP_ADMIN_USERNAME=${KC_BOOTSTRAP_ADMIN_USERNAME}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD}
ENV KC_DB_USERNAME=${KC_DB_USERNAME}
ENV KC_DB_URL=${KC_DB_URL}

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

USER keycloak
EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--cache=local", "--hostname-strict=false", "--proxy-headers=xforwarded", "--hostname=${KC_HOSTNAME}", "--http-port=8080", "--db-username=${KC_DB_USERNAME}", "--db-password=${KC_DB_PASSWORD}", "--db-url=${KC_DB_URL}", "--bootstrap-admin-password=${KC_BOOTSTRAP_ADMIN_PASSWORD}", "--bootstrap-admin-username=${KC_BOOTSTRAP_ADMIN_USERNAME}", "--http-enabled=true"]