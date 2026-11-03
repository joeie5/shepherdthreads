import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/data/account_data.dart' as account_data;
import '../../core/providers/store_provider.dart';

/// Ported from react-source/src/hooks/useCheckout.ts

const checkoutSteps = ['Shipping', 'Delivery', 'Payment', 'Review'];

enum CheckoutMode { guest, member }

enum PayMethod { saved, card, paypal, applepay }

class CheckoutData {
  final String email;
  final bool newsletter;
  final String firstName;
  final String lastName;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zip;
  final String phone;
  final String delivery;
  final PayMethod payMethod;
  final String cardNumber;
  final String cardName;
  final String expiry;
  final String cvc;
  final bool billingSame;

  const CheckoutData({
    this.email = '',
    this.newsletter = true,
    this.firstName = '',
    this.lastName = '',
    this.address1 = '',
    this.address2 = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.phone = '',
    this.delivery = 'standard',
    this.payMethod = PayMethod.card,
    this.cardNumber = '',
    this.cardName = '',
    this.expiry = '',
    this.cvc = '',
    this.billingSame = true,
  });

  static CheckoutData member() {
    final a = account_data.addresses[0];
    return CheckoutData(
      email: account_data.user.email,
      firstName: account_data.user.firstName,
      lastName: account_data.user.lastName,
      address1: a.line1,
      address2: a.line2 ?? '',
      city: a.city,
      state: a.state,
      zip: a.zip,
      phone: a.phone,
      payMethod: PayMethod.saved,
    );
  }

  CheckoutData copyWith({
    String? email,
    bool? newsletter,
    String? firstName,
    String? lastName,
    String? address1,
    String? address2,
    String? city,
    String? state,
    String? zip,
    String? phone,
    String? delivery,
    PayMethod? payMethod,
    String? cardNumber,
    String? cardName,
    String? expiry,
    String? cvc,
    bool? billingSame,
  }) {
    return CheckoutData(
      email: email ?? this.email,
      newsletter: newsletter ?? this.newsletter,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      phone: phone ?? this.phone,
      delivery: delivery ?? this.delivery,
      payMethod: payMethod ?? this.payMethod,
      cardNumber: cardNumber ?? this.cardNumber,
      cardName: cardName ?? this.cardName,
      expiry: expiry ?? this.expiry,
      cvc: cvc ?? this.cvc,
      billingSame: billingSame ?? this.billingSame,
    );
  }
}

class CheckoutErrors {
  final Map<String, String> _errors;
  const CheckoutErrors([this._errors = const {}]);
  String? operator [](String key) => _errors[key];
  bool get isEmpty => _errors.isEmpty;
}

class CheckoutState {
  final int step;
  final CheckoutMode mode;
  final CheckoutData data;
  final CheckoutErrors errors;

  const CheckoutState({
    required this.step,
    required this.mode,
    required this.data,
    this.errors = const CheckoutErrors(),
  });

  CheckoutState copyWith({int? step, CheckoutMode? mode, CheckoutData? data, CheckoutErrors? errors}) {
    return CheckoutState(
      step: step ?? this.step,
      mode: mode ?? this.mode,
      data: data ?? this.data,
      errors: errors ?? this.errors,
    );
  }
}

final _emailRe = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

class CheckoutNotifier extends Notifier<CheckoutState> {
  @override
  CheckoutState build() {
    final signedIn = ref.watch(storeProvider.select((s) => s.isSignedIn));
    final mode = signedIn ? CheckoutMode.member : CheckoutMode.guest;
    return CheckoutState(
      step: 0,
      mode: mode,
      data: mode == CheckoutMode.member ? CheckoutData.member() : const CheckoutData(),
    );
  }

  void set(CheckoutData Function(CheckoutData) updater) {
    state = state.copyWith(data: updater(state.data), errors: const CheckoutErrors());
  }

  void setMode(CheckoutMode mode) {
    final data = mode == CheckoutMode.member
        ? CheckoutData.member()
        : CheckoutData(delivery: state.data.delivery);
    state = state.copyWith(mode: mode, data: data, errors: const CheckoutErrors());
  }

  void applyAddress(String id) {
    final a = account_data.addresses.where((x) => x.id == id);
    if (a.isEmpty) return;
    final addr = a.first;
    state = state.copyWith(
      data: state.data.copyWith(
        address1: addr.line1,
        address2: addr.line2 ?? '',
        city: addr.city,
        state: addr.state,
        zip: addr.zip,
        phone: addr.phone,
      ),
    );
  }

  Map<String, String> _validate(int s) {
    final e = <String, String>{};
    final d = state.data;
    if (s == 0) {
      if (!_emailRe.hasMatch(d.email)) e['email'] = 'Enter a valid email address';
      for (final k in ['firstName', 'lastName', 'address1', 'city', 'state']) {
        final v = switch (k) {
          'firstName' => d.firstName,
          'lastName' => d.lastName,
          'address1' => d.address1,
          'city' => d.city,
          'state' => d.state,
          _ => '',
        };
        if (v.trim().isEmpty) e[k] = 'Required';
      }
      if (!RegExp(r'^\d{5}$').hasMatch(d.zip.trim())) e['zip'] = 'Enter a 5-digit ZIP';
      if (d.phone.replaceAll(RegExp(r'\D'), '').length < 10) e['phone'] = 'Enter a valid phone number';
    }
    if (s == 2 && d.payMethod == PayMethod.card) {
      if (d.cardNumber.replaceAll(' ', '').length != 16) e['cardNumber'] = 'Enter a 16-digit card number';
      if (d.cardName.trim().isEmpty) e['cardName'] = 'Required';
      if (!RegExp(r'^(0[1-9]|1[0-2])/\d{2}$').hasMatch(d.expiry)) e['expiry'] = 'Use MM/YY';
      if (!RegExp(r'^\d{3,4}$').hasMatch(d.cvc)) e['cvc'] = '3–4 digits';
    }
    return e;
  }

  bool next() {
    final e = _validate(state.step);
    state = state.copyWith(errors: CheckoutErrors(e));
    if (e.isNotEmpty) return false;
    state = state.copyWith(step: (state.step + 1).clamp(0, checkoutSteps.length - 1));
    return true;
  }

  void back() => state = state.copyWith(step: (state.step - 1).clamp(0, checkoutSteps.length - 1));

  void goTo(int i) {
    if (i < state.step) state = state.copyWith(step: i);
  }
}

final checkoutProvider = NotifierProvider<CheckoutNotifier, CheckoutState>(CheckoutNotifier.new);
