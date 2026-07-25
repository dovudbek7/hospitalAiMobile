import 'package:url_launcher/url_launcher.dart';

/// Opens the platform dialler with [number] pre-filled. Uses the `tel:`
/// scheme, which works with no network connection — a P13 hard requirement.
Future<bool> dial(String number) {
  final cleaned = number.replaceAll(RegExp(r'[\s-]'), '');
  return launchUrl(
    Uri(scheme: 'tel', path: cleaned),
    mode: LaunchMode.externalApplication,
  );
}
