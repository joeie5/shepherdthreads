/// All product/catalog imagery is real photography from assets/images/ (see
/// MIGRATION_NOTES.md "Demo content removed"). The handful of `_seed(...)`
/// placeholders below back only editorial/content imagery that has no real
/// photography yet — Journal post covers and the Our Story page — never a
/// product.
///
/// Uses placehold.co rather than picsum.photos: picsum's final (post-redirect)
/// image response omits `Access-Control-Allow-Origin`, which Flutter Web's
/// CanvasKit/Skwasm renderer requires to decode cross-origin images — without
/// it the image silently fails to paint. placehold.co sends `ACAO: *`.
class AppImages {
  AppImages._();

  static String _seed(String key, {int w = 1200, int h = 1500}) {
    final label = Uri.encodeComponent(
      key.replaceFirst('st-', '').replaceAll('-', ' '),
    );
    return 'https://placehold.co/${w}x$h/F7F5F0/8C8C88.png?font=roboto&text=$label';
  }

  static final lookbookField = _seed('st-lookbook-field', w: 1600, h: 2000);
  static final lookbookDetail = _seed('st-lookbook-detail');
  static final lookbookSteps = _seed('st-lookbook-steps');
  static final workshop = _seed('st-workshop', w: 1600, h: 900);
  static final journalBible = _seed('st-journal-bible');
  static final community = _seed('st-community');
  static final founder = _seed('st-founder');

  // Real brand assets (from assets/images/, registered in pubspec.yaml).
  // Paths are matched against this prefix by AppImage to decide whether to
  // render via Image.asset or CachedNetworkImage — see shared/widgets/app_image.dart.
  static const logo = 'assets/images/logo.png';

  /// Horizontal lockup (mark + "Shepherds Thread" + tagline side by side,
  /// 1774×887) — fits a compact navbar far better than [logo]'s tall stacked
  /// lockup. Used for the header/footer/mobile-menu brand mark.
  static const logoLandscape = 'assets/images/logo-landscape.png';
  static const savedHoodieFrontGrey = 'assets/images/saved-hoodie-front-grey.png';
  static const savedHoodieBackGrey = 'assets/images/saved-hoodie-back-grey.png';
  static const savedHoodieFrontMediumBlue = 'assets/images/saved-hoodie-front-medium-blue.png';
  static const savedHoodieBackMediumBlue = 'assets/images/saved-hoodie-back-medium-blue.png';
  static const crownedTeeFrontBlack = 'assets/images/crowned-tee-front-black.png';
  static const crownedTeeBackBlack = 'assets/images/crowned-tee-back-black.png';
  static const crownedTeeFrontLightApricot = 'assets/images/crowned-tee-front-light-apricot.png';
  static const crownedTeeBackLightApricot = 'assets/images/crowned-tee-back-light-apricot.png';
  static const savedJoggersFrontMediumBlue = 'assets/images/saved-joggers-front-medium-blue.png';
  static const savedJoggersBackMediumBlue = 'assets/images/saved-joggers-back-medium-blue.png';
  static const savedJoggersFrontGrey = 'assets/images/saved-joggers-front-grey.webp';
  static const savedJoggersBackGrey = 'assets/images/saved-joggers-back-grey.webp';
  static const identityPoloFrontBlack = 'assets/images/identity-polo-front-black.webp';
  static const identityPoloBackBlack = 'assets/images/identity-polo-back-black.webp';
  static const identityShortsFrontBlack = 'assets/images/identity-shorts-front-black.png';
  static const identityShortsBackBlack = 'assets/images/identity-shorts-back-black.png';

  /// Lifestyle shot of the model wearing the Saved Hoodie + Saved Joggers set
  /// in black — used for the Home hero.
  static const modelSavedSetBlack = 'assets/images/model-saved-set-black.jpg';

  /// hero now points at the real lifestyle shot (was a placeholder).
  static const hero = modelSavedSetBlack;
}
