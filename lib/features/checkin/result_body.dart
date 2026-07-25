import 'package:flutter/material.dart';

import '../../core/content/txt.dart';
import '../../core/models/api_models.dart';
import '../../core/theme/typography.dart';

/// The body copy of a check-in result screen.
///
/// Preference order — and nothing else:
///  1. The server's `body` — ALREADY resolved and clinic-interpolated
///     approved copy. Render verbatim.
///  2. The server's `contentKey`, resolved through the content library.
///  3. [fallbackKey] — the tier's canonical content key.
///
/// There is no path that composes text locally.
class CheckinResultBody extends StatelessWidget {
  const CheckinResultBody({
    required this.result,
    required this.fallbackKey,
    super.key,
  });

  final CheckinResult? result;
  final String fallbackKey;

  @override
  Widget build(BuildContext context) {
    final serverBody = result?.body;
    if (serverBody != null && serverBody.isNotEmpty) {
      return Text(serverBody, style: AppText.bodyL);
    }
    return Txt(result?.contentKey ?? fallbackKey, style: AppText.bodyL);
  }
}
