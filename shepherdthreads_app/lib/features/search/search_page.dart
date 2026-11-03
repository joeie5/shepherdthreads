import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/data/product_repository.dart';
import '../../core/data/products_data.dart';
import '../../core/providers/store_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/site_container.dart';

/// Ported from react-source/src/pages/Search.tsx
class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchPage({super.key, this.initialQuery});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

const _trending = ['Saved Hoodie', 'Crowned T-Shirt', 'Crewneck', 'Cap', 'Grey', 'Gift for pastor'];
const _suggestedCategories = [
  ('Hoodies', '/shop?category=Hoodies'),
  ('Crewnecks', '/shop?category=Crewnecks'),
  ('Tees', '/shop?category=Tees'),
  ('Headwear', '/shop?category=Headwear'),
  ('The Psalm 23 Collection', '/shop?collection=psalm-23'),
];

class _SearchPageState extends ConsumerState<SearchPage> {
  late final _controller = TextEditingController(text: widget.initialQuery ?? '');
  late String _q = widget.initialQuery ?? '';
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _run(String value) {
    setState(() {
      _controller.text = value;
      _q = value.trim();
    });
    if (_q.isNotEmpty) ref.read(storeProvider.notifier).addRecentSearch(_q);
    context.go(_q.isNotEmpty ? '/search?q=${Uri.encodeComponent(_q)}' : '/search');
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppBreakpoints.isDesktop(MediaQuery.sizeOf(context).width);
    final hPad = isDesktop ? 32.0 : 20.0;
    final results = searchProductsSync(_q);
    final popular = mockProducts.where((p) => !p.soldOut).take(4).toList();
    final recentSearches = ref.watch(storeProvider.select((s) => s.recentSearches));
    final notifier = ref.read(storeProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.cream,
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.hairline))),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: isDesktop ? 64 : 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: AppColors.ink)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, size: 20, color: AppColors.ink),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                focusNode: _focusNode,
                                onSubmitted: _run,
                                style: AppTextStyles.serif(fontSize: isDesktop ? 32 : 24),
                                decoration: InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  filled: false,
                                  hintText: 'Search hoodies, verses, colors…',
                                  hintStyle: AppTextStyles.serif(fontSize: isDesktop ? 32 : 24, color: AppColors.stone),
                                ),
                              ),
                            ),
                            if (_controller.text.isNotEmpty)
                              IconButton(
                                onPressed: () => _run(''),
                                icon: const Icon(Icons.close, size: 20, color: AppColors.stone),
                              ),
                          ],
                        ),
                      ),
                      if (_q.isEmpty) ...[
                        const SizedBox(height: 32),
                        isDesktop
                            ? IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _RecentSearches(recent: recentSearches, onRun: _run, onClear: notifier.clearRecentSearches)),
                                    const SizedBox(width: 32),
                                    Expanded(child: _TrendingSearches(onRun: _run)),
                                  ],
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _RecentSearches(recent: recentSearches, onRun: _run, onClear: notifier.clearRecentSearches),
                                  const SizedBox(height: 32),
                                  _TrendingSearches(onRun: _run),
                                ],
                              ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad, vertical: isDesktop ? 64 : 48),
          child: SiteContainer(
            child: _q.isEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('POPULAR RIGHT NOW', style: AppTextStyles.sectionHeading().copyWith(fontSize: 24)),
                      const SizedBox(height: 32),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: popular.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isDesktop ? 4 : 2,
                          mainAxisSpacing: 40,
                          crossAxisSpacing: isDesktop ? 24 : 12,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, i) => ProductCard(product: popular[i]),
                      ),
                    ],
                  )
                : results.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone),
                              children: [
                                TextSpan(text: '${results.length} ${results.length == 1 ? 'result' : 'results'} for '),
                                TextSpan(text: '“$_q”', style: const TextStyle(color: AppColors.ink)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: results.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 3 : 2,
                              mainAxisSpacing: 40,
                              crossAxisSpacing: isDesktop ? 24 : 12,
                              childAspectRatio: 0.62,
                            ),
                            itemBuilder: (context, i) => ProductCard(product: results[i]),
                          ),
                        ],
                      )
                    : Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Column(
                            children: [
                              Text('No results for “$_q”', style: AppTextStyles.serif(fontSize: 28)),
                              const SizedBox(height: 12),
                              Text('Check the spelling, try a broader word, or start from one of these.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink65)),
                              const SizedBox(height: 32),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8,
                                runSpacing: 8,
                                children: _suggestedCategories
                                    .map((c) => InkWell(
                                          onTap: () => context.go(c.$2),
                                          child: Container(
                                            height: 40,
                                            padding: const EdgeInsets.symmetric(horizontal: 16),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                                            child: Text(c.$1, style: AppTextStyles.sans(fontSize: 13)),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class _RecentSearches extends StatelessWidget {
  final List<String> recent;
  final ValueChanged<String> onRun;
  final VoidCallback onClear;
  const _RecentSearches({required this.recent, required this.onRun, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.history, size: 16),
                const SizedBox(width: 8),
                Text('RECENT', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
              ],
            ),
            if (recent.isNotEmpty)
              InkWell(
                onTap: onClear,
                child: Text('Clear',
                    style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone)
                        .copyWith(decoration: TextDecoration.underline)),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Text('No recent searches.', style: AppTextStyles.sans(fontSize: 14, color: AppColors.stone))
        else
          for (final s in recent)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: InkWell(
                onTap: () => onRun(s),
                child: Text(s, style: AppTextStyles.sans(fontSize: 15, color: AppColors.ink75)),
              ),
            ),
      ],
    );
  }
}

class _TrendingSearches extends StatelessWidget {
  final ValueChanged<String> onRun;
  const _TrendingSearches({required this.onRun});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.trending_up, size: 16),
            const SizedBox(width: 8),
            Text('TRENDING', style: AppTextStyles.sans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 1.2)),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _trending
              .map((t) => InkWell(
                    onTap: () => onRun(t),
                    child: Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(color: AppColors.hairline)),
                      child: Text(t, style: AppTextStyles.sans(fontSize: 13)),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
