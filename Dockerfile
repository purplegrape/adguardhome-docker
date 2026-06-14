FROM alpine:3.23
LABEL \
	org.opencontainers.image.title="AdGuard Home" \
	org.opencontainers.image.description="Network-wide ads & trackers blocking DNS server" \
	org.opencontainers.image.documentation="https://github.com/AdguardTeam/AdGuardHome/wiki/" \
	org.opencontainers.image.licenses="GPL-3.0"

RUN apk update && \
	apk add --no-cache ca-certificates libcap tzdata && \
	rm -rf /var/cache/apk/*

COPY --from=docker.io/adguard/adguardhome --chmod=755 /opt/adguardhome/AdGuardHome /usr/local/bin/AdGuardHome

# RUN setcap 'cap_net_bind_service=+eip' /usr/local/bin/AdGuardHome

VOLUME [ "/data" ]
WORKDIR /data/adguardhome
CMD [ "AdGuardHome","--no-check-update" ]

# 53     : TCP, UDP : DNS
# 67     :      UDP : DHCP (server)
# 68     :      UDP : DHCP (client)
# 80     : TCP      : HTTP (main)
# 443    : TCP, UDP : HTTPS, DNS-over-HTTPS (incl. HTTP/3), DNSCrypt (main)
# 853    : TCP, UDP : DNS-over-TLS, DNS-over-QUIC
# 3000   : TCP, UDP : HTTP(S) (alt, incl. HTTP/3)
# 5443   : TCP, UDP : DNSCrypt (alt)
# 6060   : TCP      : HTTP (pprof)

EXPOSE 53/tcp 53/udp \
	67/udp \
	68/udp \
	80/tcp \
	443/tcp 443/udp \
	853/tcp 853/udp \
	3000/tcp 3000/udp \
	5443/tcp 5443/udp \
	6060/tcp
