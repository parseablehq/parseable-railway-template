FROM parseable/parseable:edge

ENV P_ADDR=0.0.0.0:8080
ENV P_STAGING_DIR=/data/staging

EXPOSE 8080

# Railway injects these env vars via the dashboard template config:
#
# From Railway Bucket (variable references):
#   P_S3_URL        -> Bucket ENDPOINT
#   P_S3_ACCESS_KEY -> Bucket ACCESS_KEY_ID
#   P_S3_SECRET_KEY -> Bucket SECRET_ACCESS_KEY
#   P_S3_BUCKET     -> Bucket BUCKET
#   P_S3_REGION     -> Bucket REGION
#
# User-configured:
#   P_USERNAME      -> admin username
#   P_PASSWORD      -> admin password (auto-generated)
#   PORT            -> 8080 (aligns Railway routing/healthcheck with Parseable's listen port)
