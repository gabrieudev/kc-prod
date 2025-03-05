FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_DB=postgres
ENV KC_PROXY=edge
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT=false
ENV KC_PROXY_HEADERS=forwarded
ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_HTTP_PORT=${KC_HTTP_PORT}
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=${KEYCLOAK_ADMIN_PASSWORD}
ENV KC_BOOTSTRAP_ADMIN_USERNAME=${KEYCLOAK_ADMIN_USERNAME}
ENV KC_DB_PASSWORD=${KEYCLOAK_DB_PASSWORD}
ENV KC_DB_USERNAME=${KEYCLOAK_DB_USERNAME}
ENV KC_DB_URL=${KEYCLOAK_DB_URL}

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

USER keycloak
EXPOSE ${KC_HTTP_PORT}

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized", "--cache=local", "--proxy=${KC_PROXY}", "--hostname-strict=${KC_HOSTNAME_STRICT}", "--proxy-headers=${KC_PROXY_HEADERS}", "--hostname=${KC_HOSTNAME}", "--http-port=${KC_HTTP_PORT}", "--db=${KC_DB}", "--db-username=${KC_DB_USERNAME}", "--db-password=${KC_DB_PASSWORD}", "--db-url=${KC_DB_URL}", "--bootstrap-admin-password=${KC_BOOTSTRAP_ADMIN_PASSWORD}", "--bootstrap-admin-username=${KC_BOOTSTRAP_ADMIN_USERNAME}", "--http-enabled=${KC_HTTP_ENABLED}"]