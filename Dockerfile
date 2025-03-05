FROM quay.io/keycloak/keycloak:26.1.3 as builder

RUN /opt/keycloak/bin/kc.sh build \
    --db=postgres \
    --features=token-exchange,admin-fine-grained-authz,scripts

FROM quay.io/keycloak/keycloak:26.1.3
COPY --from=builder /opt/keycloak/lib/quarkus/ /opt/keycloak/lib/quarkus/

ENV KC_PROXY=edge
ENV KC_HOSTNAME_STRICT=false
ENV KC_HTTP_ENABLED=true
ENV KC_DB=postgres
ENV KC_DB_URL=${KC_DB_URL}
ENV KC_DB_USERNAME=${KC_DB_USERNAME}
ENV KC_DB_PASSWORD=${KC_DB_PASSWORD}
ENV KC_ADMIN=${KC_ADMIN}
ENV KC_ADMIN_PASSWORD=${KC_ADMIN_PASSWORD}
ENV KC_HOSTNAME=${KC_HOSTNAME}
ENV KC_LOG_LEVEL=WARN
ENV JAVA_OPTS="-XX:MaxRAMPercentage=70 -XX:+UseContainerSupport"

USER keycloak
CMD ["start", "--optimized"]