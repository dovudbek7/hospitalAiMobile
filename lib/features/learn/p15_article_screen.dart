// P15 · Article detail. Rendered EXACTLY as the clinician approved — no
// summarisation, no simplification, no AI adaptation. The footer disclaimer
// appears verbatim on every article. A missing translation shows an
// explicit message plus the clinic contact — never a silent fallback.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/content/txt.dart';
import '../../core/telemetry/client_events.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/fail_closed_panel.dart';

class P15ArticleScreen extends ConsumerStatefulWidget {
  const P15ArticleScreen({required this.contentKey, super.key});

  final String contentKey;

  @override
  ConsumerState<P15ArticleScreen> createState() => _P15ArticleScreenState();
}

class _P15ArticleScreenState extends ConsumerState<P15ArticleScreen> {
  @override
  void initState() {
    super.initState();
    // content_viewed carries the content_ref only — an id, never prose.
    // ignore: unawaited_futures
    ref
        .read(clientEventsProvider)
        .contentViewed(contentRef: widget.contentKey)
        .catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final key = widget.contentKey;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            final router = GoRouter.maybeOf(context);
            if (router == null) {
              Navigator.of(context).maybePop();
            } else if (router.canPop()) {
              router.pop();
            } else {
              router.go('/learn');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpace.s24),
        child: TxtGate(
          requiredKeys: [key],
          fallback: FutureBuilder<EmergencyBundle?>(
            future: EmergencyBundle.load(),
            builder: (context, snapshot) => FailClosedPanel(
              title: const Txt('content.unavailable_in_language'),
              body: const Txt('content.contact_hint'),
              callLabel: Text(snapshot.data?.clinicPhone ?? ''),
              onCallClinic: () {
                final phone = snapshot.data?.clinicPhone;
                if (phone != null) dial(phone);
              },
              diagnosticCode: 'CONTENT_NOT_APPROVED',
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // The body — verbatim, untransformed. (No separate title key
              // exists server-side; the approved text stands on its own.)
              Txt(key, style: AppText.bodyL),
              const SizedBox(height: AppSpace.s32),
              const Divider(),
              const SizedBox(height: AppSpace.s16),
              // The disclaimer, verbatim, on EVERY article.
              const Txt('content.disclaimer', style: AppText.caption),
            ],
          ),
        ),
      ),
    );
  }
}
