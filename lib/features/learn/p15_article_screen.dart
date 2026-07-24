// P15ArticleScreen — F4 routing stub with its route parameter threaded through.

import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../core/widgets/content_slot.dart';

class P15ArticleScreen extends StatelessWidget {
  const P15ArticleScreen({required this.contentKey, super.key});

  final String contentKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.s24),
          child: Center(child: ContentSlot(contentKey: contentKey, lines: 4)),
        ),
      ),
    );
  }
}
