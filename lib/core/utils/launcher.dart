import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// Thin wrapper around `url_launcher` so failures never surface as an
/// unhandled exception in the middle of a click.
abstract final class Launcher {
  /// Opens [url] in a new browser tab. Returns false if it could not be
  /// opened, so callers can show a fallback (e.g. copy-to-clipboard).
  static Future<bool> open(String? url) async {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    try {
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: _opensInPlace(uri) ? '_self' : '_blank',
      );
    } catch (error, stack) {
      debugPrint('Launcher failed for $url: $error\n$stack');
      return false;
    }
  }

  /// `mailto:` and `tel:` should hand off to the OS in the current tab —
  /// opening them in a new tab leaves a blank window behind.
  static bool _opensInPlace(Uri uri) =>
      uri.scheme == 'mailto' || uri.scheme == 'tel';

  /// Builds a pre-filled mail link from the contact form.
  static String composeMail({
    required String to,
    required String subject,
    required String body,
  }) {
    final query = Uri(
      queryParameters: {'subject': subject, 'body': body},
    ).query;
    return 'mailto:$to?$query';
  }
}
