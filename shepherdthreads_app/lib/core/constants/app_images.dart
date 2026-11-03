/// Placeholder image URLs standing in for the React source's
/// `data/images.ts`, whose referenced files (Magic Patterns-hosted) were not
/// included in the exported project. Swap these for real product photography
/// before launch — see MIGRATION_NOTES.md.
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

  static final hoodieBlack = _seed('st-hoodie-black');
  static final hoodieBone = _seed('st-hoodie-bone');
  static final hoodieModel = _seed('st-hoodie-model');
  static final teeCream = _seed('st-tee-cream');
  static final teeCreamModel = _seed('st-tee-cream-model');
  static final teeBlack = _seed('st-tee-black');
  static final teeStone = _seed('st-tee-stone');
  static final capBlack = _seed('st-cap-black');
  static final capModel = _seed('st-cap-model');
  static final crewStone = _seed('st-crew-stone');
  static final crewModel = _seed('st-crew-model');
  static final crewCream = _seed('st-crew-cream');
  static final longsleeveBlack = _seed('st-longsleeve-black');
  static final beanieStone = _seed('st-beanie-stone');
  static final tote = _seed('st-tote');
  static final sweatpantsBlack = _seed('st-sweatpants-black');
  static final zipBlack = _seed('st-zip-black');
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
  static const savedJoggersFrontMediumBlue = 'assets/images/saved-joggers-front-medium-blue.png';
  static const savedJoggersBackMediumBlue = 'assets/images/saved-joggers-back-medium-blue.png';
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
