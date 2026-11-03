import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config/supabase_config.dart';
import 'core/data/product_repository.dart';
import 'core/data/supabase_product_repository.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: SupabaseConfig.url, anonKey: SupabaseConfig.anonKey);
  // Replaces the bundled mock catalog with live data before first frame —
  // see loadLiveCatalog's doc comment in product_repository.dart for why
  // this works without touching any widget call site.
  await loadLiveCatalog(SupabaseProductRepository(Supabase.instance.client));
  runApp(const ProviderScope(child: ShepherdsThreadApp()));
}

class ShepherdsThreadApp extends StatelessWidget {
  const ShepherdsThreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shepherds Thread',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
