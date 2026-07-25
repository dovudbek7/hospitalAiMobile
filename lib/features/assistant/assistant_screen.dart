// SP7 · AI Assistant — grounded explanation & navigation chat.
//
// The assistant EXPLAINS the clinic's approved guidance and ROUTES to
// humans. It never assesses a symptom. Safety is enforced server-side; the
// client only renders the stream and honours the contentKey the server
// sends (integration guide §7).
//
//  - Emergency affordance stays on top, like every screen.
//  - verdict red_flag_bypass → route to the P13 emergency screen.
//  - verdict replaced / error → the bubble shows APPROVED content by key.
//  - Offline → blocked, contact options shown, nothing queued (§9).
//  - The app never adds its own reassurance around a reply.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/content/emergency_bundle.dart';
import '../../core/providers.dart';
import '../../core/content/txt.dart';
import '../../core/router/guards.dart';
import '../../core/theme/tokens.dart';
import '../../core/theme/typography.dart';
import '../../core/util/dial.dart';
import '../../core/widgets/emergency_button.dart';
import '../../core/widgets/emergency_sheet.dart';
import 'assistant_models.dart';
import 'assistant_providers.dart';

class AssistantScreen extends ConsumerStatefulWidget {
  const AssistantScreen({super.key});

  @override
  ConsumerState<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends ConsumerState<AssistantScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    final emergencyKey =
        await ref.read(assistantProvider.notifier).send(text);
    _scrollToEnd();
    if (emergencyKey != null && mounted) {
      // Red flag → the emergency screen, not a chat bubble.
      unawaited(context.push(Routes.emergency));
    }
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: AppDur.screen,
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openEmergency() async {
    final bundle = await EmergencyBundle.load();
    if (!mounted) return;
    await EmergencySheet.show(
      context,
      title: const Txt('emergency.sheet_title'),
      instruction: const Txt('emergency.banner'),
      callAmbulanceLabel: const Txt('emergency.call_103'),
      callClinicLabel: const Txt('emergency.call_clinic'),
      onCallAmbulance: () => dial(bundle?.ambulanceNumber ?? '103'),
      onCallClinic: () {
        final p = bundle?.clinicPhone;
        if (p != null) dial(p);
      },
      hoursLine: const Txt('emergency.hours_line'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(assistantProvider);

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Txt('assistant.title', style: AppText.h2),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpace.s12),
            child: _AssistantEmergencyButton(onPressed: _openEmergency),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(28),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpace.s16,
              0,
              AppSpace.s16,
              AppSpace.s8,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Txt('assistant.subtitle', style: AppText.caption),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: state.messages.isEmpty
                ? const _Intro()
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.all(AppSpace.s16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, i) =>
                        _Bubble(message: state.messages[i]),
                  ),
          ),
          if (state.outcome == AssistantOutcome.offline)
            const _StateBanner(
              key: ValueKey('offline'),
              messageKey: 'assistant.offline',
            ),
          if (state.outcome == AssistantOutcome.failed)
            const _StateBanner(
              key: ValueKey('failed'),
              messageKey: 'assistant.error',
            ),
          _Composer(
            controller: _input,
            sending: state.sending,
            onSend: _send,
          ),
        ],
      ),
    );
  }
}

class _AssistantEmergencyButton extends ConsumerWidget {
  const _AssistantEmergencyButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = switch (ref.watch(txtProvider('a11y.emergency_button'))) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => '103',
    };
    return SizedBox(
      width: 44,
      height: 44,
      child: EmergencyButton(semanticLabel: label, onPressed: onPressed),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpace.s64,
              height: AppSpace.s64,
              decoration: const BoxDecoration(
                color: AppColors.brand50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.brand700,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSpace.s16),
            const Txt(
              'assistant.intro',
              style: AppText.bodyL,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpace.s24),
            const Txt(
              'assistant.disclaimer',
              style: AppText.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});
  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isPatient = message.role == ChatRole.patient;
    final child = message.contentKey != null
        // Approved content (replaced / error) — resolved, never composed.
        ? Txt(message.contentKey!, style: AppText.bodyL)
        : (message.text.isEmpty && message.streaming)
            ? const _TypingDots()
            : Text(message.text, style: AppText.bodyL);

    return Align(
      alignment: isPatient ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpace.s12),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.s16,
          vertical: AppSpace.s12,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isPatient ? AppColors.brand600 : AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppRadius.card),
            topRight: const Radius.circular(AppRadius.card),
            bottomLeft: Radius.circular(isPatient ? AppRadius.card : 6),
            bottomRight: Radius.circular(isPatient ? 6 : AppRadius.card),
          ),
          border: isPatient ? null : Border.all(color: AppColors.line),
          boxShadow: isPatient ? null : AppShadow.card,
        ),
        child: DefaultTextStyle.merge(
          style: AppText.bodyL.copyWith(
            color: isPatient ? AppColors.surface : AppColors.ink,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _TypingDots extends StatelessWidget {
  const _TypingDots();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 40,
      height: 20,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.muted,
            ),
          ),
        ],
      ),
    );
  }
}

class _StateBanner extends StatelessWidget {
  const _StateBanner({required this.messageKey, super.key});
  final String messageKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.brand50,
      padding: const EdgeInsets.all(AppSpace.s16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.brand700),
          const SizedBox(width: AppSpace.s12),
          Expanded(
            child: Txt(messageKey, style: AppText.body),
          ),
        ],
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(AppSpace.s12),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpace.s16,
                  vertical: AppSpace.s12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  border: Border.all(color: AppColors.line),
                ),
                child: _HintedField(controller: controller, onSend: onSend),
              ),
            ),
            const SizedBox(width: AppSpace.s8),
            _SendButton(sending: sending, onSend: onSend),
          ],
        ),
      ),
    );
  }
}

class _HintedField extends ConsumerWidget {
  const _HintedField({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hint = switch (ref.watch(txtProvider('assistant.input_hint'))) {
      AsyncData(value: final ContentResolved r) => r.text,
      _ => '',
    };
    return TextField(
      controller: controller,
      minLines: 1,
      maxLines: 4,
      maxLength: 2000,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => onSend(),
      style: AppText.bodyL,
      decoration: InputDecoration(
        border: InputBorder.none,
        isCollapsed: true,
        counterText: '',
        hintText: hint,
        hintStyle: AppText.bodyL.copyWith(color: AppColors.muted),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.sending, required this.onSend});
  final bool sending;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppHit.min,
      height: AppHit.min,
      child: Material(
        color: AppColors.brand600,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: sending ? null : onSend,
          customBorder: const CircleBorder(),
          child: Center(
            child: sending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: AppColors.surface,
                    ),
                  )
                : const Icon(
                    Icons.arrow_upward_rounded,
                    color: AppColors.surface,
                  ),
          ),
        ),
      ),
    );
  }
}
