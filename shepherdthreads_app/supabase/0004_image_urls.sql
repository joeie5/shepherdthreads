-- Run after tool/upload_images_to_storage.sh has uploaded the files.
-- Points product_color_variants.images and testimonials.image at the
-- new public Storage URLs instead of the local `assets/images/...`
-- paths (those paths only ever resolved inside the Flutter app bundle —
-- meaningless to anything else querying this table directly).
--
-- The app's own bundled fallback data (lib/core/data/products_data.dart)
-- is untouched by this — it keeps shipping local assets for the
-- pre-first-paint/offline-fallback case; only the live Supabase rows
-- change.

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-hoodie-front-grey.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-hoodie-back-grey.png'
] where product_id = 'saved-hoodie' and name = 'Grey';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-hoodie-front-medium-blue.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-hoodie-back-medium-blue.png'
] where product_id = 'saved-hoodie' and name = 'Medium Blue';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/crowned-tee-front-black.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/crowned-tee-back-black.png'
] where product_id = 'crowned-tee' and name = 'Black';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/crowned-tee-front-light-apricot.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/crowned-tee-back-light-apricot.png'
] where product_id = 'crowned-tee' and name = 'Light Apricot';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-joggers-front-medium-blue.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-joggers-back-medium-blue.png'
] where product_id = 'saved-joggers' and name = 'Medium Blue';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-joggers-front-grey.webp',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-joggers-back-grey.webp'
] where product_id = 'saved-joggers' and name = 'Grey';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/identity-polo-front-black.webp',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/identity-polo-back-black.webp'
] where product_id = 'identity-polo' and name = 'Black';

update product_color_variants set images = array[
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/identity-shorts-front-black.png',
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/identity-shorts-back-black.png'
] where product_id = 'identity-shorts' and name = 'Black';

update testimonials set image =
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-hoodie-front-medium-blue.png'
  where name = 'Alexis M.';

update testimonials set image =
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/crowned-tee-front-black.png'
  where name = 'Josiah R.';

update testimonials set image =
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/saved-joggers-front-medium-blue.png'
  where name = 'Grace K.';

update testimonials set image =
  'https://skbebcjztkxmywznpwsx.supabase.co/storage/v1/object/public/product-images/identity-polo-front-black.webp'
  where name = 'Daniel P.';
