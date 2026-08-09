import 'package:flutter/material.dart';

/// One skill pill.
@immutable
class Skill {
  const Skill(this.name, {this.icon, this.level});

  final String name;
  final IconData? icon;

  /// 0–1 proficiency. Optional; drives the thin bar under a pill when present.
  final double? level;
}

@immutable
class SkillCategory {
  const SkillCategory({
    required this.title,
    required this.blurb,
    required this.icon,
    required this.accent,
    required this.skills,
  });

  final String title;
  final String blurb;
  final IconData icon;
  final Color accent;
  final List<Skill> skills;
}

@immutable
class ExperienceItem {
  const ExperienceItem({
    required this.role,
    required this.company,
    required this.location,
    required this.period,
    required this.summary,
    required this.highlights,
    required this.tech,
    this.current = false,
  });

  final String role;
  final String company;
  final String location;
  final String period;
  final String summary;
  final List<String> highlights;
  final List<String> tech;
  final bool current;
}

@immutable
class EducationItem {
  const EducationItem({
    required this.title,
    required this.institution,
    required this.period,
  });

  final String title;
  final String institution;
  final String period;
}

@immutable
class ProcessStep {
  const ProcessStep({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
}

@immutable
class StatItem {
  const StatItem({
    required this.value,
    required this.label,
    this.suffix = '',
    this.prefix = '',
    this.isNumeric = true,
    this.text,
    this.icon,
  });

  /// Target for the count-up animation. Ignored when [isNumeric] is false.
  final double value;
  final String label;
  final String suffix;
  final String prefix;

  /// Some stats are words ("Flutter", "Production") rather than numbers.
  final bool isNumeric;
  final String? text;
  final IconData? icon;
}

@immutable
class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.handle,
    this.icon,
  });

  final String label;
  final String url;
  final String handle;
  final IconData? icon;
}

/// A repository card in the GitHub section.
@immutable
class RepoCard {
  const RepoCard({
    required this.name,
    required this.description,
    required this.language,
    required this.languageColor,
    required this.url,
    this.stars = 0,
  });

  final String name;
  final String description;
  final String language;
  final Color languageColor;
  final String url;
  final int stars;
}
