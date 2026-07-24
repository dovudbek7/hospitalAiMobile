// P14LearnScreen — F4 routing stub. The real screen lands in its build phase
// (see md/steps.md); this stub keeps the router compiling and shows the
// screen's primary content key so navigation is reviewable.

import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/content_slot.dart';

class P14LearnScreen extends StatelessWidget {
  const P14LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpace.s24),
          child: Center(child: ContentSlot(contentKey: 'learn.title', lines: 4)),
        ),
      ),
    );
  }
}
