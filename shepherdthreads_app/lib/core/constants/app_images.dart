/// Placeholder image URLs standing in for the React source's
/// `data/images.ts`, whose referenced files (Magic Patterns-hosted) were not
/// included in the exported project. Swap these for real product photography
/// before launch — see MIGRATION_NOTES.md.
///
/// Each key uses deterministic picsum.photos seeds so the same logical image
/// always resolves to the same placeholder across the app.
class AppImages {
  AppImages._();

  static String _seed(String key, {int w = 1200, int h = 1500}) =>
      'https://picsum.photos/seed/$key/$w/$h';

  static final hero = _seed('st-hero', w: 1600, h: 2000);
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
  static final identityPolo = _seed('st-identity-polo');
  static final identityShorts = _seed('st-identity-shorts');

  // Real brand assets (from assets/images/, registered in pubspec.yaml).
  // Paths are matched against this prefix by AppImage to decide whether to
  // render via Image.asset or CachedNetworkImage — see shared/widgets/app_image.dart.
  static const logo = 'assets/images/logo.png';
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
}
