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
  // Product photos are large (up to 1400x1400) and this app renders many of
  // them at once (grids, carousels, color-swatch alternates). The default
  // 100MB image cache fills up fast, which on CanvasKit evicts textures that
  // are still on-screen and paints them solid black instead of re-fetching.
  PaintingBinding.instance.imageCache.maximumSize = 500;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 300 << 20;
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
