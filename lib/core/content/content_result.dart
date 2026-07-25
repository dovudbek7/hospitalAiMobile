import 'package:flutter/foundation.dart';

/// Outcome of resolving a content key. Exactly three cases — a screen must
/// handle all of them, and there is no case that silently substitutes text.
@immutable
sealed class ContentResult {
  const ContentResult();
}

/// The key resolved to approved (or explicitly-flagged placeholder) text.
class ContentResolved extends ContentResult {
  const ContentResolved({
    required this.text,
    required this.version,
    required this.isPlaceholder,
    this.fromBundledSeed = false,
  });

  final String text;
  final int version;
  final bool isPlaceholder;

  /// True when served from the build-time seed pack rather than the server
  /// or its cache — demo builds only (see ContentRepository).
  final bool fromBundledSeed;
}

/// The server refused the key for this language (CONTENT_NOT_APPROVED /
/// CLINICAL_CONTENT_NOT_APPROVED) and no permitted fallback exists.
/// Golden rule 3: render nothing. Never another language.
class ContentNotApproved extends ContentResult {
  const ContentNotApproved({required this.contentKey, required this.language});

  final String contentKey;
  final String language;
}

/// Offline and not cached. Distinct from refusal — retry when online.
class ContentUnavailable extends ContentResult {
  const ContentUnavailable({required this.contentKey, required this.language});

  final String contentKey;
  final String language;
}
