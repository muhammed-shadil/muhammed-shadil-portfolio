import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_portfolio/app.dart';
import 'package:my_portfolio/core/config/portfolio_config.dart';
import 'package:my_portfolio/core/utils/svg_path.dart';
import 'package:my_portfolio/data/portfolio_data.dart';
import 'package:my_portfolio/designs/design_1/sections/projects/project_detail_page.dart';
import 'package:my_portfolio/designs/design_registry.dart';

/// The widths the site is expected to work at.
const List<Size> _viewports = [
  Size(320, 720), // smallest phone
  Size(414, 896), // large phone
  Size(768, 1024), // tablet
  Size(1024, 800), // laptop
  Size(1440, 900), // desktop
  Size(1920, 1080), // large desktop
];

/// Renders [design] at [size] and returns any exception raised during layout.
Future<Object?> _render(
  WidgetTester tester,
  PortfolioDesign design,
  Size size,
) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;

  DesignController.current.value = design;
  await tester.pumpWidget(const PortfolioApp());
  await tester.pump(const Duration(milliseconds: 120));

  return tester.takeException();
}

void main() {
  // Every test leaves the switch where it found it, so ordering cannot leak.
  tearDown(() {
    DesignController.current.value = PortfolioConfig.initialDesign;
  });

  group('design switching', () {
    testWidgets('every design renders at every supported viewport', (
      tester,
    ) async {
      addTearDown(tester.view.reset);

      for (final design in PortfolioDesign.values) {
        for (final size in _viewports) {
          final error = await _render(tester, design, size);
          expect(
            error,
            isNull,
            reason:
                '${design.name} raised at ${size.width.toInt()}x'
                '${size.height.toInt()}',
          );
        }
      }
    });

    testWidgets('every design shows the developer name', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      for (final design in PortfolioDesign.values) {
        DesignController.current.value = design;
        await tester.pumpWidget(const PortfolioApp());
        await tester.pump(const Duration(milliseconds: 120));

        // Design 3 sets the name in caps, so match case-insensitively on the
        // surname rather than the exact formatted string.
        final found = find.byWidgetPredicate((widget) {
          if (widget is! Text) return false;
          final text = widget.data ?? widget.textSpan?.toPlainText() ?? '';
          return text.toLowerCase().contains('shadil');
        });

        expect(found, findsWidgets, reason: 'no name in ${design.name}');
      }
    });

    testWidgets('switching design rebuilds with the new theme', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      DesignController.current.value = PortfolioDesign.design1;
      await tester.pumpWidget(const PortfolioApp());
      await tester.pump(const Duration(milliseconds: 120));

      final dark = Theme.of(tester.element(find.byType(Scaffold).first));
      expect(dark.brightness, Brightness.dark);

      // Design 3 is the only light theme — a good proof that the theme really
      // follows the switch rather than being fixed at app level.
      DesignController.current.value = PortfolioDesign.design3;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 120));

      final light = Theme.of(tester.element(find.byType(Scaffold).first));
      expect(light.brightness, Brightness.light);
      expect(tester.takeException(), isNull);
    });
  });

  group('design registry', () {
    test('every design has metadata and a distinct label', () {
      final labels = <String>{};
      for (final design in PortfolioDesign.values) {
        final meta = designMetaOf(design);
        expect(meta.id, design);
        expect(meta.label, isNotEmpty);
        expect(meta.tagline, isNotEmpty);
        labels.add(meta.label);
      }
      expect(labels.length, PortfolioDesign.values.length);
    });
  });

  group('design 1 case study', () {
    testWidgets('opens and returns', (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      DesignController.current.value = PortfolioDesign.design1;
      await tester.pumpWidget(const PortfolioApp());
      await tester.pump(const Duration(milliseconds: 100));

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.push(ProjectDetailPage.route(PortfolioData.projects.first));
      // Not pumpAndSettle: a live project's status badge pulses indefinitely
      // by design, so the tree never reaches a quiescent state.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      final project = PortfolioData.projects.first;
      expect(find.text(project.name), findsWidgets);
      expect(find.text(project.detailBlocks.first.title), findsOneWidget);
      expect(tester.takeException(), isNull);

      navigator.pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(tester.takeException(), isNull);
    });
  });

  group('SvgPath', () {
    test('parses every bundled brand glyph into a non-empty path', () {
      const glyphs = {
        'github':
            'M12 .297c-6.63 0-12 5.373-12 12 0 5.303 3.438 9.8 8.205 '
            '11.385.6.113.82-.258.82-.577z',
        'arc': 'M10 10a5 5 0 1 0 0.0001 0z',
        'relative': 'm5 5 l10 0 l0 10 z',
      };

      for (final entry in glyphs.entries) {
        final path = SvgPath.parse(entry.value);
        expect(
          path.getBounds().isEmpty,
          isFalse,
          reason: '${entry.key} produced an empty path',
        );
      }
    });

    test('handles implicit repeated parameter sets', () {
      final path = SvgPath.parse('M0 0 L10 0 20 0');
      expect(path.getBounds().width, 20);
    });
  });

  group('portfolio data', () {
    test('every project has an id, tech list and at least one feature', () {
      for (final project in PortfolioData.projects) {
        expect(project.id, isNotEmpty);
        expect(project.tech, isNotEmpty);
        expect(project.features, isNotEmpty);
      }
    });

    test('project ids are unique so hero tags cannot collide', () {
      final ids = PortfolioData.projects.map((p) => p.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every declared link is a valid absolute URL', () {
      for (final project in PortfolioData.projects) {
        for (final link in project.links) {
          final uri = Uri.tryParse(link.url);
          expect(uri, isNotNull, reason: '${project.name}: ${link.url}');
          expect(uri!.hasScheme, isTrue, reason: project.name);
        }
      }
    });

    test('both resume links point at the same Drive file', () {
      expect(PortfolioData.resumeUrl, contains(PortfolioData.resumeFileId));
      expect(
        PortfolioData.resumeDownloadUrl,
        contains(PortfolioData.resumeFileId),
      );
    });
  });
}
