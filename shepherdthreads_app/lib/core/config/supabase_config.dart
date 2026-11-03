/// Supabase project connection details.
///
/// The anon/publishable key is safe to ship in client code by design — it
/// is the public key, scoped entirely by Row Level Security (see
/// supabase/schema.sql). Never put the service_role/secret key here.
class SupabaseConfig {
  SupabaseConfig._();

  static const url = 'https://skbebcjztkxmywznpwsx.supabase.co';
  static const anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNrYmViY2p6dGt4bXl3em5wd3N4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTM2NjM3NzcsImV4cCI6MjEwOTIzOTc3N30.vsH1bW0Qoxgfkf5ILQcu6yZFinVrzAbM1taFxXlG9vY';
}
