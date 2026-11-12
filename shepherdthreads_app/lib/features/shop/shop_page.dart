import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/products_data.dart';
import '../../core/models/product.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';
import '../../shared/widgets/product_card.dart';
import '../../shared/widgets/site_container.dart';
import 'filter_panel.dart';
import 'pagination_widget.dart';
import 'shop_filters.dart';
import 'sort_select.dart';

/// Ported from react-source/src/pages/Shop.tsx
class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final params = GoRouterState.of(context).uri.queryParameters;
    final categoryLabel = params['category'];
    final initialCategory = categoryLabel != null
        ? ProductCategoryLabel.fromLabel(categoryLabel)
        : null;
    final collectionSlug = params['collection'];
    final collection = collectionSlug == null
        ? null
        : CollectionId.values.firstWhere(
            (c) => c.slug == collectionSlug,
            orElse: () => CollectionId.essentials,
          );

    final args = ShopFiltersArgs(
      initialCategory: initialCategory,
      collection: collection,
    );
    final state = ref.watch(shopFiltersProvider(args));
    final notifier = ref.read(shopFiltersProvider(args).notifier);
    final shopResults = computeShopResults(state, collection);

    final activeCollection = collection == null
        ? null
        : productCollections.firstWhere((c) => c.id == collection);

    final isDesktop = AppBreakpoints.isDesktop(
      MediaQuery.sizeOf(context).width,
    );
    final isLargeDesktop = AppBreakpoints.isLargeDesktop(
      MediaQuery.sizeOf(context).width,
    );
    final hPad = isDesktop ? 32.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.cream,
          padding: EdgeInsets.symmetric(vertical: isDesktop ? 64 : 48),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    _CrumbLink(label: 'Home', onTap: () => context.go('/')),
                    Text(
                      ' / ',
                      style: AppTextStyles.sans(
                        fontSize: 12,
                        color: AppColors.stone,
                      ),
                    ),
                    activeCollection != null
                        ? _CrumbLink(
                            label: 'Collections',
                            onTap: () => context.go('/collections'),
                          )
                        : Text(
                            'Shop',
                            style: AppTextStyles.sans(
                              fontSize: 12,
                              color: AppColors.stone,
                            ),
                          ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  (activeCollection?.name ?? 'Shop All').toUpperCase(),
                  style: AppTextStyles.sectionHeading().copyWith(
                    fontSize: isDesktop ? 52 : 36,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Text(
                    activeCollection?.description ?? 'Heavyweight essentials, made to be worn for years. Every piece carries a quiet reminder.',
                    style: AppTextStyles.sans(
                      fontSize: 15,
                      color: AppColors.ink65,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 32, 0, isDesktop ? 80 : 56),
          child: SiteContainer(
            padding: EdgeInsets.symmetric(horizontal: hPad),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.hairline),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (!isLargeDesktop) ...[
                        SizedBox(
                          height: 40,
                          child: OutlinedButton.icon(
                            onPressed: () => _openFilterSheet(
                              context,
                              state,
                              notifier,
                              shopResults,
                            ),
                            icon: const Icon(Icons.tune, size: 16),
                            label: Text(
                              state.filters.activeCount > 0
                                  ? 'Filter (${state.filters.activeCount})'
                                  : 'Filter',
                              style: AppTextStyles.sans(fontSize: 13),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.hairline),
                              foregroundColor: AppColors.ink,
                              shape: const RoundedRectangleBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Text(
                        '${shopResults.results.length} ${shopResults.results.length == 1 ? 'product' : 'products'}',
                        style: AppTextStyles.sans(
                          fontSize: 13,
                          color: AppColors.stone,
                        ),
                      ),
                      const Spacer(),
                      SortSelect(
                        value: state.sort,
                        onChanged: notifier.setSort,
                      ),
                    ],
                  ),
                ),
                if (state.filters.activeCount > 0) ...[
                  const SizedBox(height: 20),
                  _ActiveChips(filters: state.filters, notifier: notifier),
                ],
                const SizedBox(height: 32),
                isLargeDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 240,
                            child: FilterPanel(
                              filters: state.filters,
                              onToggleCategory: notifier.toggleCategory,
                              onToggleSize: notifier.toggleSize,
                              onToggleColor: notifier.toggleColor,
                              onTogglePrice: notifier.togglePrice,
                            ),
                          ),
                          const SizedBox(width: 48),
                          Expanded(
                            child: _ResultsSection(
                              results: shopResults,
                              isDesktop: isDesktop,
                              state: state,
                              notifier: notifier,
                            ),
                          ),
                        ],
                      )
                    : _ResultsSection(
                        results: shopResults,
                        isDesktop: isDesktop,
                        state: state,
                        notifier: notifier,
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Uses Flutter's own modal-sheet overlay (anchored to the root Navigator)
  // rather than embedding the drawer inline in ShopPage's own widget tree.
  // The inline AppDrawer approach hid itself purely via a slide+opacity
  // transform, which only reads as "off-screen" inside a screen-fixed
  // Overlay; here it sat inside this page's own (unbounded-height,
  // scrollable) Stack, so "hidden" just meant translated to a lower
  // position still reachable by scrolling — exactly the stray "FILTER"
  // block that showed up below the product grid.
  void _openFilterSheet(
    BuildContext context,
    ShopFiltersState state,
    ShopFiltersNotifier notifier,
    ShopResults shopResults,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.88,
      ),
      builder: (sheetContext) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.hairline)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FILTER',
                    style: AppTextStyles.serif(
                      fontSize: 20,
                      letterSpacing: 1.6,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: FilterPanel(
                  filters: state.filters,
                  onToggleCategory: notifier.toggleCategory,
                  onToggleSize: notifier.toggleSize,
                  onToggleColor: notifier.toggleColor,
                  onTogglePrice: notifier.togglePrice,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: 'Clear',
                      variant: AppButtonVariant.outline,
                      onPressed: notifier.clearAll,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      label: 'Show ${shopResults.results.length}',
                      onPressed: () => Navigator.of(sheetContext).pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ResultsSection extends StatelessWidget {
  final ShopResults results;
  final bool isDesktop;
  final ShopFiltersState state;
  final ShopFiltersNotifier notifier;
  const _ResultsSection({
    required this.results,
    required this.isDesktop,
    required this.state,
    required this.notifier,
  });

  @override
  Widget build(BuildContext context) {
    if (results.paged.isEmpty) {
      return Container(
        color: AppColors.cream,
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        child: Column(
          children: [
            Text(
              'Nothing matches just yet',
              style: AppTextStyles.serif(fontSize: 26),
            ),
            const SizedBox(height: 8),
            Text(
              'Try removing a filter or two — or browse everything we make.',
              textAlign: TextAlign.center,
              style: AppTextStyles.sans(fontSize: 14, color: AppColors.ink65),
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Clear filters',
              variant: AppButtonVariant.outline,
              onPressed: notifier.clearAll,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.paged.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 3 : 2,
            mainAxisSpacing: 40,
            crossAxisSpacing: isDesktop ? 24 : 12,
            // Narrower 2-column cells need relatively more height for the
            // name/price/swatches block below the image than wider desktop
            // cells do — 0.62 made that block taller than its cell, pushing
            // the color swatches outside the grid tile's hit-testable
            // bounds (taps on them silently did nothing on mobile).
            childAspectRatio: isDesktop ? 0.62 : 0.56,
          ),
          itemBuilder: (context, i) => ProductCard(
            key: ValueKey(results.paged[i].id),
            product: results.paged[i],
          ),
        ),
        PaginationWidget(
          page: state.page,
          pageCount: results.pageCount,
          onChanged: notifier.setPage,
        ),
      ],
    );
  }
}

class _ActiveChips extends StatelessWidget {
  final ShopFilters filters;
  final ShopFiltersNotifier notifier;
  const _ActiveChips({required this.filters, required this.notifier});

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      for (final c in filters.categories)
        _Chip(label: c.label, onRemove: () => notifier.toggleCategory(c)),
      for (final s in filters.sizes)
        _Chip(label: s, onRemove: () => notifier.toggleSize(s)),
      for (final c in filters.colors)
        _Chip(label: c, onRemove: () => notifier.toggleColor(c)),
      for (final p in filters.prices)
        _Chip(label: p.label, onRemove: () => notifier.togglePrice(p)),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ...chips,
        InkWell(
          onTap: notifier.clearAll,
          child: Text(
            'Clear all',
            style: AppTextStyles.sans(
              fontSize: 12,
              color: AppColors.stone,
            ).copyWith(decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _Chip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRemove,
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: AppColors.cream,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.sans(fontSize: 12)),
            const SizedBox(width: 6),
            const Icon(Icons.close, size: 12, color: AppColors.ink),
          ],
        ),
      ),
    );
  }
}

class _CrumbLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _CrumbLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: AppTextStyles.sans(fontSize: 12, color: AppColors.stone),
      ),
    );
  }
}
