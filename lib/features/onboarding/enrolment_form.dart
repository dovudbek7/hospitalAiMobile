import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/session.dart';
import '../../core/config/env.dart';

/// Enrolment draft state. The code must survive rotation AND backgrounding
/// (spec P2) — rotation is covered by Riverpod, process death by mirroring
/// the draft into SharedPreferences until enrolment succeeds.
class EnrolmentForm {
  const EnrolmentForm({this.code = '', this.phone = ''});

  final String code;

  /// 9-digit national number (digits only; +998 is fixed UI chrome).
  final String phone;

  bool get codeComplete => code.length == 6;
  bool get phoneComplete => phone.length == 9;

  EnrolmentForm copyWith({String? code, String? phone}) =>
      EnrolmentForm(code: code ?? this.code, phone: phone ?? this.phone);
}

class EnrolmentFormNotifier extends Notifier<EnrolmentForm> {
  static const _kDraftCode = 'enrolment.draft_code';

  @override
  EnrolmentForm build() {
    final draft = ref.read(sharedPrefsProvider).getString(_kDraftCode) ?? '';
    if (draft.isEmpty && Env.demoMode) {
      // Demo mode: pre-filled so a reviewer walks straight through.
      return const EnrolmentForm(code: 'H7K9QP', phone: '901234567');
    }
    return EnrolmentForm(code: draft);
  }

  void setCode(String code) {
    final cleaned = code.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
    state = state.copyWith(code: cleaned);
    // Fire-and-forget mirror; enrolment success clears it.
    ref.read(sharedPrefsProvider).setString(_kDraftCode, cleaned);
  }

  void setPhone(String phone) {
    state = state.copyWith(
      phone: phone.replaceAll(RegExp(r'\D'), ''),
    );
  }

  Future<void> clearDraft() async {
    await ref.read(sharedPrefsProvider).remove(_kDraftCode);
    state = const EnrolmentForm();
  }
}

final enrolmentFormProvider =
    NotifierProvider<EnrolmentFormNotifier, EnrolmentForm>(
  EnrolmentFormNotifier.new,
);
