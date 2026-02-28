# Parseable on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy?template=TEMPLATE_ID)

Deploy [Parseable](https://parseable.com) on [Railway](https://railway.com) with one click. Parseable is an open source observability platform for logs, metrics, and traces — built for high ingestion, low latency queries, and efficient storage. This template runs Parseable in `s3-store` mode backed by a Railway Bucket for durable, S3-compatible object storage.

## What's Included

| Service | Description |
|---------|-------------|
| **Parseable** | Observability backend (`parseable/parseable:edge`) running in `s3-store` mode |
| **Storage** | Railway Bucket providing S3-compatible object storage for log data |

A persistent volume is attached at `/parseable/staging` for buffering data before it is flushed to the Railway Bucket.

## Environment Variables

These are configured automatically by the template. You only need to provide `P_USERNAME` during deploy.

| Variable | Value | Description |
|----------|-------|-------------|
| `PORT` | `8000` | Service port |
| `P_ADDR` | `0.0.0.0:${{PORT}}` | Listen address |
| `P_STAGING_DIR` | `/parseable/staging` | Local staging directory (volume-backed) |
| `P_USERNAME` | *(you set this)* | Admin username (required) |
| `P_PASSWORD` | *(auto-generated)* | 32-char admin password |
| `P_S3_URL` | `${{Storage.ENDPOINT}}` | Railway Bucket endpoint |
| `P_S3_BUCKET` | `${{Storage.BUCKET}}` | Railway Bucket name |
| `P_S3_ACCESS_KEY` | `${{Storage.ACCESS_KEY_ID}}` | Railway Bucket access key |
| `P_S3_SECRET_KEY` | `${{Storage.SECRET_ACCESS_KEY}}` | Railway Bucket secret key |
| `P_S3_REGION` | `${{Storage.REGION}}` | Railway Bucket region |
| `P_S3_PATH_STYLE` | `false` | Virtual-hosted-style URLs (Railway default) |
| `P_CHECK_UPDATE` | `false` | Disable update checks |
| `P_SEND_ANONYMOUS_USAGE_DATA` | `false` | Disable telemetry |

## Getting Started

### 1. Deploy

Click the **Deploy on Railway** button above. You'll be prompted to:
- Set `P_USERNAME` — your Parseable admin username

`P_PASSWORD` is auto-generated. Find it in your Railway service variables after deploy.

### 2. Access the Parseable Console

Once the deployment is healthy, open the public Railway URL for the Parseable service. Log in with:
- **Username**: the `P_USERNAME` you set
- **Password**: the `P_PASSWORD` value from your Railway service variables

### 3. Ingest Data

Create a log stream and send a test event:

```bash
# Replace with your Railway public URL, username, and password
PARSEABLE_URL="https://your-parseable-app.up.railway.app"
P_USERNAME="your-username"
P_PASSWORD="your-password"

# Create a log stream
curl -X PUT "${PARSEABLE_URL}/api/v1/logstream/teststream" \
  -u "${P_USERNAME}:${P_PASSWORD}"

# Send a log event
curl -X POST "${PARSEABLE_URL}/api/v1/logstream/teststream" \
  -u "${P_USERNAME}:${P_PASSWORD}" \
  -H "Content-Type: application/json" \
  -H "X-P-Stream: teststream" \
  -d '[{"message": "Hello from Railway!", "level": "info", "timestamp": "'"$(date -u +%Y-%m-%dT%H:%M:%SZ)"'"}]'
```

### 4. Query Data

```bash
curl -X POST "${PARSEABLE_URL}/api/v1/query" \
  -u "${P_USERNAME}:${P_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT * FROM teststream", "startTime": "2024-01-01T00:00:00Z", "endTime": "2030-01-01T00:00:00Z"}'
```

You can also explore and query data visually from the Parseable console.

## Architecture

```
┌──────────────────────────────────────────────────────┐
│                      Railway                         │
│                                                      │
│  ┌────────────────┐          ┌─────────────────────┐ │
│  │   Parseable     │───S3───▶│   Railway Bucket     │ │
│  │   (Docker)      │         │   (Object Storage)   │ │
│  │   Port 8000     │         │                      │ │
│  └───────┬────────┘          └──────────────────────┘ │
│          │                                            │
│     ┌────┴──────┐                                     │
│     │  Volume    │                                    │
│     │ /parseable │                                    │
│     │ /staging   │                                    │
│     └───────────┘                                     │
│                                                       │
└───────────────────────────────────────────────────────┘
```

Incoming data is staged to a local volume and periodically flushed to the Railway Bucket over the S3 API.

## Integrations

Parseable supports ingestion from:
- **OpenTelemetry** — send logs, metrics, and traces via OTLP
- **Fluent Bit / Fluentd** — forward logs using HTTP output plugin
- **Vector** — route observability data with the HTTP sink
- **Any HTTP client** — use the REST API directly

See the [Parseable integrations docs](https://www.parseable.com/docs/integrations) for setup guides.

## Links

- [Parseable Documentation](https://www.parseable.com/docs)
- [Parseable GitHub](https://github.com/parseablehq/parseable)
- [Railway Documentation](https://docs.railway.com)
- [Railway Buckets](https://docs.railway.com/reference/buckets)
