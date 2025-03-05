FROM quay.io/keycloak/keycloak:latest as builder

RUN /opt/keycloak/bin/kc.sh build \
    --http-enabled=true \
    --proxy=edge

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

ENV KC_PROXY=edge
ENV KC_HTTP_ENABLED=true
ENV KC_DB=postgres

ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=${KC_BOOTSTRAP_ADMIN_PASSWORD}
ENV KC_BOOTSTRAP_ADMIN_USERNAME=${KC_BOOTSTRAP_ADMIN_USERNAME}
ENV KC_DB_USERNAME=${KC_DB_USERNAME}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD}
ENV KC_DB_URL=${KC_DB_URL}

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start"]