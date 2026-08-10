# =============================================================================
# Railway Template: Bichon
# https://github.com/rustmailer/bichon
# End-to-end encrypted email storage & management (IMAP/SMTP) with a Web UI.
# =============================================================================
# Notes:
#   • Bichon listens on port 15630 by default (BICHON_HTTP_PORT).
#     Railway's reverse proxy targets PORT, so PORT must equal BICHON_HTTP_PORT.
#   • Persistent data lives at /data (WORKDIR + upstream volume). Mount a
#     Railway volume at /data to survive restarts.
#   • BICHON_ENCRYPT_PASSWORD encrypts stored credentials (IMAP passwords,
#     OAuth tokens). Set it in the deploy form — never commit a real value.
#   • BICHON_PUBLIC_URL should be the Railway public domain so OAuth
#     redirects and docs links resolve correctly.
#   • Upstream image runs as root and has a healthcheck on /api/status.
# =============================================================================

FROM rustmailer/bichon:2.0.1

LABEL org.opencontainers.image.source="https://github.com/INAPP-Mobile/bichon"

# Upstream EXPOSEs 15630. Railway needs PORT env to match for proxying.
EXPOSE 15630

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -fs "http://127.0.0.1:${BICHON_HTTP_PORT:-15630}/api/status" >/dev/null 2>&1 || exit 1