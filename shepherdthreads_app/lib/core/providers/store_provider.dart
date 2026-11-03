import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/product_repository.dart';
import '../data/supabase_product_repository.dart';
import '../models/commerce.dart';

/// Ported from react-source/src/contexts/StoreContext.tsx as a Riverpod
/// Notifier. Holds cart, wishlist, promo, recent searches and sign-in state —
/// the single source of truth the Header, CartDrawer, Shop, ProductDetail,
/// Cart, Checkout and Account pages all read from in the React app.

const _promos = [
  Promo(code: 'SHEPHERD10', percentOff: 10, label: '10% off your order'),
  Promo(code: 'WELCOME15', percentOff: 15, label: '15% off your first order'),
];

class StoreState {
  final List<CartItem> cart;
  final bool isCartOpen;
  final String? lastAddedKey;
  final List<String> wishlist;
  final Promo? promo;
  final List<String> recentSearches;
  final bool isSignedIn;

  const StoreState({
    this.cart = const [],
    this.isCartOpen = false,
    this.lastAddedKey,
    this.wishlist = const [],
    this.promo,
    this.recentSearches = const [],
    this.isSignedIn = true,
  });

  int get cartCount => cart.fold(0, (n, i) => n + i.qty);

  double get subtotal =>
      cart.fold(0.0, (sum, i) => sum + (getProductSync(i.productId)?.price ?? 0) * i.qty);

  StoreState copyWith({
    List<CartItem>? cart,
    bool? isCartOpen,
    String? lastAddedKey,
    bool clearLastAddedKey = false,
    List<String>? wishlist,
    Promo? promo,
    bool clearPromo = false,
    List<String>? recentSearches,
    bool? isSignedIn,
  }) {
    return StoreState(
      cart: cart ?? this.cart,
      isCartOpen: isCartOpen ?? this.isCartOpen,
      lastAddedKey: clearLastAddedKey ? null : (lastAddedKey ?? this.lastAddedKey),
      wishlist: wishlist ?? this.wishlist,
      promo: clearPromo ? null : (promo ?? this.promo),
      recentSearches: recentSearches ?? this.recentSearches,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

class StoreNotifier extends Notifier<StoreState> {
  @override
  StoreState build() {
    return StoreState(
      cart: [
        CartItem(
          key: makeCartKey('saved-hoodie', 'Grey', 'M'),
          productId: 'saved-hoodie',
          color: 'Grey',
          size: 'M',
          qty: 1,
        ),
        CartItem(
          key: makeCartKey('crowned-tee', 'Black', 'L'),
          productId: 'crowned-tee',
          color: 'Black',
          size: 'L',
          qty: 1,
        ),
      ],
      wishlist: const [
        'saved-joggers',
        'identity-polo',
        'identity-shorts',
      ],
      recentSearches: const ['hoodie', 'joggers', 'polo'],
    );
  }

  void addToCart(String productId, String color, String size, {int qty = 1}) {
    final key = makeCartKey(productId, color, size);
    final existing = state.cart.where((i) => i.key == key).toList();
    List<CartItem> nextCart;
    if (existing.isNotEmpty) {
      nextCart = state.cart
          .map((i) => i.key == key
              ? i.copyWith(qty: (i.qty + qty).clamp(0, 10))
              : i)
          .toList();
    } else {
      nextCart = [
        CartItem(key: key, productId: productId, color: color, size: size, qty: qty),
        ...state.cart,
      ];
    }
    state = state.copyWith(cart: nextCart, lastAddedKey: key, isCartOpen: true);
  }

  void updateQty(String key, int qty) {
    final clamped = qty.clamp(1, 10);
    state = state.copyWith(
      cart: state.cart.map((i) => i.key == key ? i.copyWith(qty: clamped) : i).toList(),
    );
  }

  void removeItem(String key) {
    state = state.copyWith(cart: state.cart.where((i) => i.key != key).toList());
  }

  void clearCart() => state = state.copyWith(cart: []);

  void openCart() => state = state.copyWith(isCartOpen: true, clearLastAddedKey: true);

  void closeCart() => state = state.copyWith(isCartOpen: false);

  void toggleWishlist(String productId) {
    final inList = state.wishlist.contains(productId);
    state = state.copyWith(
      wishlist: inList
          ? state.wishlist.where((id) => id != productId).toList()
          : [...state.wishlist, productId],
    );
  }

  bool isWishlisted(String productId) => state.wishlist.contains(productId);

  bool applyPromo(String code) {
    final normalized = code.trim().toUpperCase();
    final match = _promos.where((p) => p.code == normalized);
    if (match.isNotEmpty) {
      state = state.copyWith(promo: match.first);
      return true;
    }
    return false;
  }

  void removePromo() => state = state.copyWith(clearPromo: true);

  void addRecentSearch(String q) {
    final v = q.trim().toLowerCase();
    if (v.isEmpty) return;
    final next = [v, ...state.recentSearches.where((s) => s != v)].take(5).toList();
    state = state.copyWith(recentSearches: next);
  }

  void clearRecentSearches() => state = state.copyWith(recentSearches: []);

  void setSignedIn(bool v) => state = state.copyWith(isSignedIn: v);
}

final storeProvider = NotifierProvider<StoreNotifier, StoreState>(StoreNotifier.new);

final productRepositoryProvider =
    Provider<ProductRepository>((ref) => SupabaseProductRepository(Supabase.instance.client));
