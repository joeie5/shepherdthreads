#!/usr/bin/env bash
# One-off migration: uploads assets/images/*.{png,jpg,webp} (everything
# except the two logo files, which stay bundled — they're brand chrome,
# not catalog content) to the `product-images` Supabase Storage bucket,
# then prints the SQL to update product_color_variants/testimonials to
# point at the new public URLs.
#
# Prereqs: supabase/0003_storage.sql already run (creates the bucket).
#
# Usage:
#   SUPABASE_SERVICE_ROLE_KEY=eyJ... ./tool/upload_images_to_storage.sh
#
# The key is read from the environment only — never pass it as a CLI arg
# (would land in shell history) and never hardcode it here.

set -euo pipefail

PROJECT_URL="https://skbebcjztkxmywznpwsx.supabase.co"
BUCKET="product-images"
IMAGES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/assets/images"

if [[ -z "${SUPABASE_SERVICE_ROLE_KEY:-}" ]]; then
  echo "Error: set SUPABASE_SERVICE_ROLE_KEY in the environment first." >&2
  exit 1
fi

echo "-- SQL to update image paths to Storage URLs — review/apply separately." > /tmp/storage_url_updates.sql

for filepath in "$IMAGES_DIR"/*; do
  filename="$(basename "$filepath")"
  case "$filename" in
    logo.png|logo-landscape.png) continue ;;
  esac

  case "$filename" in
    *.png) content_type="image/png" ;;
    *.webp) content_type="image/webp" ;;
    *.jpg|*.jpeg) content_type="image/jpeg" ;;
    *) echo "Skipping unknown type: $filename"; continue ;;
  esac

  echo "Uploading $filename..."
  status=$(curl -s -o /tmp/upload_resp.json -w "%{http_code}" \
    -X POST "$PROJECT_URL/storage/v1/object/$BUCKET/$filename" \
    -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
    -H "Content-Type: $content_type" \
    -H "x-upsert: true" \
    --data-binary "@$filepath")

  if [[ "$status" != "200" ]]; then
    echo "  FAILED ($status): $(cat /tmp/upload_resp.json)" >&2
  else
    echo "  OK -> $PROJECT_URL/storage/v1/object/public/$BUCKET/$filename"
  fi
done

echo
echo "Done. Public URL pattern:"
echo "  $PROJECT_URL/storage/v1/object/public/$BUCKET/<filename>"
