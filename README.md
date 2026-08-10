# Deploy and Host

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.com/deploy/AZnqAZ)

![Bichon OG Image](https://raw.githubusercontent.com/INAPP-Mobile/railway-bichon/main/og-image.svg)

Bichon is an end-to-end encrypted email storage and management server with a modern Web UI. Connect any number of IMAP email accounts and have all mail archived, searchable, and exportable — with credentials encrypted at rest by your own key. Deploy it on Railway in minutes.

## About Hosting

Bichon runs as a single Docker container on port `15630`. Railway provides compute, TLS at the edge, and a public URL. All persistent data lives at `/data` — mount a Railway Volume there so your archived mail survives restarts. No external database or S3 bucket required.

## Why Deploy

- **End-to-end encrypted** — stored credentials (IMAP passwords, OAuth tokens) are encrypted with your own `BICHON_ENCRYPT_PASSWORD` key
- **Zero external dependencies** — single container, embedded storage. No Postgres, no Redis, no S3
- **Universal email archiving** — connect Gmail, Outlook, or any IMAP account and keep an independent copy of all mail
- **Import & export** — EML directory import, PST import, and batch export to take your data anywhere
- **Multi-account** — manage all your email accounts from one dashboard
- **Role-based access control** — system, user, token, and data permissions with custom roles
- **Small footprint** — ~59MB image

## Common Use Cases

- **Email archiving & compliance** — keep a searchable, encrypted copy of business mail independent of the provider
- **Mail migration** — bulk-import EML/PST archives and browse them from the Web UI
- **Privacy-focused mail management** — self-hosted search and management with no third-party access

## Dependencies for Bichon

### Deployment Dependencies

Bichon is a standalone service that requires **no external dependencies** on Railway. It uses embedded storage inside its single container. Add a Railway Volume at `/data` for persistent mail archives.

---

# Bichon — End-to-End Encrypted Email Storage

> A self-hosted email archiving and management server. Connect any IMAP account and keep all mail encrypted, searchable, and exportable — your credentials protected by your own passphrase.

## Features

- **Encrypted at rest** — credentials encrypted with your own passphrase (`BICHON_ENCRYPT_PASSWORD`)
- **IMAP aggregation** — connect multiple accounts; one dashboard for all mail
- **Web UI** — modern, searchable interface (Vue frontend served by the Rust backend)
- **No external DB** — single container with embedded storage
- **Import** — bulk-load EML directories and PST files
- **Export** — batch-export messages to EML
- **SMTP ingest** — receive and archive emails directly via SMTP
- **RBAC** — fine-grained permissions with custom roles
- **OAuth-ready** — configurable OAuth providers for login

## Architecture

```
┌──────────────────────┐      ┌──────────────────┐
│   Bichon Server      │◄────►│   Email accounts │
│   (on Railway)       │ IMAP │  (any provider)  │
│   Port 15630         │      │                  │
│   /data (volume)     │      │                  │
└──────────────────────┘      └──────────────────┘
```

Bichon runs entirely inside a single container on Railway. The Rust server serves the Vue Web UI and talks IMAP/SMTP to your email providers directly — nothing else is needed.

## Environment Variables

| Variable | Default | Required | Description |
|----------|---------|----------|-------------|
| `PORT` | `15630` | ✅ | Internal listen port (must match BICHON_HTTP_PORT) |
| `BICHON_ROOT_DIR` | `/data` | ✅ | Absolute path for all persistent data |
| `BICHON_ENCRYPT_PASSWORD` | — | ✅ | Passphrase used to encrypt stored credentials (IMAP passwords, OAuth tokens) |
| `BICHON_PUBLIC_URL` | — | ❌ | Public URL for OAuth redirects and docs links |
| `BICHON_HTTP_PORT` | `15630` | ❌ | HTTP server port (leave default) |
| `BICHON_BASE_URL` | `/` | ❌ | Base path for WebUI behind a reverse proxy |
| `BICHON_LOG_LEVEL` | `info` | ❌ | Log level: `trace`, `debug`, `info`, `warn`, `error` |
| `BICHON_JSON_LOGS` | `false` | ❌ | JSON-formatted logs for log aggregators |

## Volumes

| Mount | Description |
|-------|-------------|
| `/data` | Persistent storage for mail archives, config, and encrypted credentials |

Add a Railway Volume at `/data` to persist your mail archive across restarts.

## Default Admin Credentials

> ⚠️ **SECURITY WARNING** — Bichon creates a default administrator on first boot with **publicly known credentials** (hardcoded in the open-source code):

| Field | Value |
|-------|-------|
| Username | `admin` |
| Password | `admin@bichon` |

**Change this password immediately after your first login** (Web UI → Users → admin → change password). Leaving it as-is means anyone who knows the default can take over your deployment and read your archived mail.

## How to Use

1. Click the **Deploy on Railway** button above
2. Set a strong `BICHON_ENCRYPT_PASSWORD` in the deploy form — this key encrypts your stored credentials. **Keep it safe; changing it later locks out stored accounts**
3. Add a Railway Volume at `/data` for persistence
4. Once deployed, open your Railway URL and log in with `admin` / `admin@bichon`, then **change the password immediately**
5. Connect an email account (OAuth or IMAP password) and start archiving