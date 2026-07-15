import 'package:flutter/material.dart';

class ChatInputSection extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String hintText;
  final String startLabel;
  final VoidCallback onStart;

  const ChatInputSection({
    super.key,
    required this.controller,
    required this.enabled,
    required this.hintText,
    required this.startLabel,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF3DE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Color(0xFF3B6D11),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: hintText,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            FilledButton.icon(
              onPressed: enabled ? onStart : null,
              icon: const Icon(Icons.send_rounded),
              label: Text(startLabel),
            ),
          ],
        ),
      ),
    );
  }
}
