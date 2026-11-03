-- Creates a public storage bucket for product/catalog imagery and opens
-- public read access to it. Run this once in the SQL Editor before the
-- upload script runs (uploads need the bucket to already exist).
--
-- Public read is intentional and safe: these are product photos meant to
-- be shown on the storefront to anyone, same trust level as the
-- `products` table's own public-read policy in schema.sql. Writes stay
-- restricted to the service_role (no insert/update/delete policy for
-- anon/authenticated below), so the bucket can't be tampered with from
-- the client.

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

create policy "public read product images"
  on storage.objects for select
  using (bucket_id = 'product-images');
