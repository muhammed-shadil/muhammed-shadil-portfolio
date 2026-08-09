import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';

/// The scrollable sections that appear in the navigation bar.
enum AppSection { home, about, skills, projects, experience, contact }

extension AppSectionLabel on AppSection {
  String get label => switch (this) {
    AppSection.home => 'Home',
    AppSection.about => 'About',
    AppSection.skills => 'Skills',
    AppSection.projects => 'Projects',
    AppSection.experience => 'Experience',
    AppSection.contact => 'Contact',
  };
}

/// Owns the page [ScrollController], the anchor key for every section, and
/// which section is currently in view.
///
/// Exposed to the widget tree through [SectionScope].
class SectionController extends ChangeNotifier {
  SectionController() {
    scrollController.addListener(_onScroll);
  }

  final ScrollController scrollController = ScrollController();

  /// Live scroll offset, published separately so scroll-linked widgets can
  /// listen without rebuilding on active-section changes.
  final ValueNotifier<double> offset = ValueNotifier<double>(0);

  final Map<AppSection, GlobalKey> keys = {
    for (final section in AppSection.values) section: GlobalKey(),
  };

  AppSection _active = AppSection.home;
  AppSection get active => _active;

  bool _isScrolled = false;

  /// True once the page has moved far enough that the nav should compact and
  /// pick up its background.
  bool get isScrolled => _isScrolled;

  GlobalKey keyOf(AppSection section) => keys[section]!;

  /// How far down the page the visitor is, 0–1.
  ///
  /// Safe to call at any point in the first frame: a controller can have
  /// clients whose position has not yet been given content dimensions, and
  /// reading `maxScrollExtent` in that window throws.
  double get scrollProgress {
    if (!scrollController.hasClients) return 0;
    final position = scrollController.position;
    if (!position.hasContentDimensions) return 0;
    final max = position.maxScrollExtent;
    if (max <= 0) return 0;
    return (position.pixels / max).clamp(0.0, 1.0);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.offset;
    offset.value = position;

    final scrolled = position > 24;
    var changed = false;

    if (scrolled != _isScrolled) {
      _isScrolled = scrolled;
      changed = true;
    }

    final next = _resolveActive();
    if (next != _active) {
      _active = next;
      changed = true;
    }

    if (changed) notifyListeners();
  }

  /// The active section is the last one whose top edge has passed just below
  /// the navigation bar.
  AppSection _resolveActive() {
    const triggerLine = AppSizes.navHeight + 40;
    var result = AppSection.home;

    for (final section in AppSection.values) {
      final context = keys[section]!.currentContext;
      if (context == null) continue;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= triggerLine) {
        result = section;
      }
    }
    return result;
  }

  /// Smoothly scrolls a section to just under the navigation bar.
  Future<void> scrollTo(AppSection section, {bool reduceMotion = false}) async {
    final context = keys[section]!.currentContext;
    if (context == null || !scrollController.hasClients) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final target =
        (scrollController.offset +
                box.localToGlobal(Offset.zero).dy -
                AppSizes.navHeight -
                8)
            .clamp(0.0, scrollController.position.maxScrollExtent);

    if (reduceMotion) {
      scrollController.jumpTo(target);
      return;
    }

    await scrollController.animateTo(
      target,
      duration: AppDurations.scrollTo,
      curve: AppCurves.emphasized,
    );
  }

  Future<void> scrollToTop({bool reduceMotion = false}) async {
    if (!scrollController.hasClients) return;
    if (reduceMotion) {
      scrollController.jumpTo(0);
      return;
    }
    await scrollController.animateTo(
      0,
      duration: AppDurations.scrollTo,
      curve: AppCurves.emphasized,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    offset.dispose();
    super.dispose();
  }
}

/// Makes the [SectionController] available to the whole page.
class SectionScope extends InheritedNotifier<SectionController> {
  const SectionScope({
    super.key,
    required SectionController controller,
    required super.child,
  }) : super(notifier: controller);

  static SectionController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SectionScope>();
    assert(scope != null, 'No SectionScope found in the widget tree.');
    return scope!.notifier!;
  }

  /// Reads the controller without subscribing to its changes — used by
  /// callbacks that only need to call `scrollTo`.
  static SectionController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<SectionScope>();
    assert(scope != null, 'No SectionScope found in the widget tree.');
    return scope!.notifier!;
  }
}
