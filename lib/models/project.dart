import 'package:flutter/material.dart';

/// Where a project can be opened. Drives which pills a card renders.
enum LinkKind { playStore, appStore, github, website }

extension LinkKindLabel on LinkKind {
  String get label => switch (this) {
    LinkKind.playStore => 'Google Play',
    LinkKind.appStore => 'App Store',
    LinkKind.github => 'Source',
    LinkKind.website => 'Live site',
  };

  IconData get icon => switch (this) {
    LinkKind.playStore => Icons.play_arrow_rounded,
    LinkKind.appStore => Icons.apple_rounded,
    LinkKind.github => Icons.code_rounded,
    LinkKind.website => Icons.open_in_new_rounded,
  };
}

/// Publication state — a card shows a badge for anything that is not a plain
/// public release, so an internal project never renders a dead store link.
enum ProjectStatus { live, companyInternal, openSource, inProgress }

extension ProjectStatusLabel on ProjectStatus {
  String get label => switch (this) {
    ProjectStatus.live => 'Live on Play Store',
    ProjectStatus.companyInternal => 'Company project',
    ProjectStatus.openSource => 'Open source',
    ProjectStatus.inProgress => 'In progress',
  };
}

@immutable
class ProjectLink {
  const ProjectLink({required this.kind, required this.url});

  final LinkKind kind;
  final String url;
}

/// A single labelled block in the project detail view (Problem, Solution,
/// Challenges, …). Kept generic so sections can be added per project without
/// touching the detail UI.
@immutable
class DetailBlock {
  const DetailBlock({
    required this.title,
    required this.body,
    this.icon = Icons.chevron_right_rounded,
  });

  final String title;
  final String body;
  final IconData icon;
}

@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.tagline,
    required this.summary,
    required this.accent,
    required this.tech,
    required this.features,
    required this.status,
    this.category = 'Mobile app',
    this.iconUrl,
    this.monogram,
    this.links = const [],
    this.detailBlocks = const [],
    this.architecture = const [],
    this.results = const [],
    this.role,
    this.year,
    this.featured = false,
  });

  /// Stable slug — used as the hero tag between card and detail view.
  final String id;
  final String name;
  final String tagline;

  /// Two-to-three line blurb shown on the card.
  final String summary;

  /// The project's own brand colour. Tints the card, halo and detail header.
  final Color accent;

  final List<String> tech;
  final List<String> features;
  final ProjectStatus status;
  final String category;

  /// Play Store launcher icon. Null for projects with no public listing —
  /// the card falls back to a [monogram] tile.
  final String? iconUrl;

  /// One or two letters drawn in a gradient tile when there is no icon.
  final String? monogram;

  final List<ProjectLink> links;
  final List<DetailBlock> detailBlocks;

  /// Bullet lines describing the technical shape of the app.
  final List<String> architecture;

  /// Outcome bullets shown at the bottom of the detail view.
  final List<String> results;

  final String? role;
  final String? year;

  /// Featured projects get a wider card in the bento grid.
  final bool featured;

  String get initials =>
      monogram ?? name.characters.take(2).toString().toUpperCase();

  ProjectLink? linkOf(LinkKind kind) {
    for (final link in links) {
      if (link.kind == kind) return link;
    }
    return null;
  }

  /// The link a card's primary pill should open, in order of usefulness.
  ProjectLink? get primaryLink {
    for (final kind in const [
      LinkKind.playStore,
      LinkKind.github,
      LinkKind.website,
      LinkKind.appStore,
    ]) {
      final link = linkOf(kind);
      if (link != null) return link;
    }
    return null;
  }
}
