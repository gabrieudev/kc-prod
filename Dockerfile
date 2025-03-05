FROM quay.io/keycloak/keycloak:latest as builder

ENV KC_DB=postgres
ENV KC_PROXY=edge
ENV KC_HTTP_ENABLED=true
ENV KC_HOSTNAME_STRICT_HTTPS=true
ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_DB_URL=${KC_DB_URL}
ENV KC_DB_USERNAME=${KC_DB_USERNAME}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD}
ENV KC_HTTP_PORT=${KC_HTTP_PORT:-8080}
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=${KC_BOOTSTRAP_ADMIN_PASSWORD}
ENV KC_BOOTSTRAP_ADMIN_USERNAME=${KC_BOOTSTRAP_ADMIN_USERNAME}

RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

USER keycloak
EXPOSE ${KC_HTTP_PORT:-8080}

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start", "--optimized"]