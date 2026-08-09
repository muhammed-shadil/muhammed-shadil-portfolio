import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_portfolio/app.dart';
import 'package:my_portfolio/core/utils/svg_path.dart';
import 'package:my_portfolio/data/portfolio_data.dart';
import 'package:my_portfolio/sections/projects/project_detail_page.dart';

void main() {
  testWidgets('renders the hero with the developer name', (tester) async {
    // A desktop-ish viewport so the two-column hero layout is exercised.
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining(PortfolioData.name), findsWidgets);
  });

  testWidgets('renders at a 320px viewport without overflowing', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 720);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Any RenderFlex overflow raises during layout, which fails the pump.
    expect(tester.takeException(), isNull);
  });

  testWidgets('opens a project case study and returns from it', (tester) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 100));

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(ProjectDetailPage.route(PortfolioData.projects.first));
    // Not pumpAndSettle: a live project's status badge pulses indefinitely by
    // design, so the tree never reaches a quiescent state.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    final project = PortfolioData.projects.first;
    expect(find.text(project.name), findsWidgets);
    // Narrative blocks, architecture and results all have to lay out.
    expect(find.text(project.detailBlocks.first.title), findsOneWidget);
    expect(tester.takeException(), isNull);

    navigator.pop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('case study lays out on a narrow viewport', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Genex has no store links and falls back to a monogram tile — the
    // branchiest path through the detail layout.
    final project = PortfolioData.projects.firstWhere((p) => p.links.isEmpty);
    tester
        .state<NavigatorState>(find.byType(Navigator))
        .push(ProjectDetailPage.route(project));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(tester.takeException(), isNull);
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
      // A single "L" followed by two coordinate pairs is two line segments.
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
  });
}
