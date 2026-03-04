# Deploy and Host Parseable with Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy?template=TEMPLATE_ID)

[Parseable](https://parseable.com) is an open source telemetry data lake. Deploy it on [Railway](https://railway.com) in one click with S3-compatible object storage powered by Railway Buckets.

## About Hosting Parseable

Parseable ingests logs, metrics, and traces via a simple REST API and stores them efficiently on S3-compatible object storage. With Parseable on Railway, you get a fully managed deployment with persistent storage, automatic health checks, and zero infrastructure setup. The platform supports standard ingestion protocols including OpenTelemetry, Fluent Bit, and direct HTTP, making it a drop-in backend for any observability pipeline.

## Common Use Cases

- **Centralized log management** — aggregate logs from microservices, serverless functions, and edge workers into a single queryable store
- **OpenTelemetry backend** — receive logs, metrics, and traces via OTLP from any instrumented application
- **Security and audit logging** — store immutable event logs with SQL-based querying for compliance and forensics
- **Development and staging observability** — spin up a lightweight log backend for pre-production environments
- **Fluent Bit / Fluentd destination** — replace heavyweight log backends with a simple HTTP sink

## Dependencies for Parseable Hosting

- A Railway account (free tier available)
- Railway Bucket for S3-compatible object storage (provisioned automatically by the template)

### Deployment Dependencies

- [Parseable Docker Image](https://hub.docker.com/r/parseable/parseable) — `parseable/parseable:edge`
- [Railway Buckets](https://docs.railway.com/reference/buckets) — S3-compatible storage provisioned within Railway
- [Parseable Documentation](https://www.parseable.com/docs) — configuration reference and API docs

### Why Deploy Parseable on Railway?

Railway provides one-click deployment with built-in S3-compatible storage via Buckets, persistent volumes, automatic health checks, and public HTTPS URLs. This eliminates the need to provision separate object storage (like AWS S3 or MinIO), configure networking between services, or manage TLS certificates. Railway's template system connects Parseable to a Bucket automatically, so storage credentials are injected at deploy time with zero manual configuration.

### Implementation Details

Once deployed, your Parseable instance is accessible via the Railway-assigned public URL. Use these curl commands to verify the deployment:

**Create a log stream:**

```bash
curl -X PUT "https://your-parseable-app.up.railway.app/api/v1/logstream/teststream" \
  -u "admin:your-password"
```

**Send a log event:**

```bash
curl -X POST "https://your-parseable-app.up.railway.app/api/v1/logstream/teststream" \
  -u "admin:your-password" \
  -H "Content-Type: application/json" \
  -H "X-P-Stream: teststream" \
  -d '[{"message": "Hello from Railway!", "level": "info"}]'
```

**Query logs:**

```bash
curl -X POST "https://your-parseable-app.up.railway.app/api/v1/query" \
  -u "admin:your-password" \
  -H "Content-Type: application/json" \
  -d '{"query": "SELECT * FROM teststream", "startTime": "2024-01-01T00:00:00Z", "endTime": "2030-01-01T00:00:00Z"}'
```

Replace `your-parseable-app.up.railway.app` with your actual Railway URL, and `admin:your-password` with the credentials you configured during deployment. The password is auto-generated and available in your Railway service variables.

## Further Reading

- [Parseable Cloud](https://app.parseable.com) — fully managed Parseable, no infrastructure to maintain
- [Parseable Documentation](https://www.parseable.com/docs) — configuration, API reference, and guides
- [Parseable GitHub](https://github.com/parseablehq/parseable) — source code and issue tracker
- [Parseable Docker Hub](https://hub.docker.com/r/parseable/parseable) — container images
- [Railway Documentation](https://docs.railway.com) — platform docs
- [Railway Buckets](https://docs.railway.com/reference/buckets) — S3-compatible storage on Railway
- [Deploy Parseable on Railway](/docs/self-hosted/installation/standalone/railway) — step-by-step guide in Parseable developer docs
