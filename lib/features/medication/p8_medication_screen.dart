// P8MedicationScreen — F4 routing stub with its route parameter threaded through.

import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/content_slot.dart';

class P8MedicationScreen extends StatelessWidget {
  const P8MedicationScreen({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Center(child: ContentSlot(contentKey: taskId, lines: 4)),
        ),
      ),
    );
  }
}
