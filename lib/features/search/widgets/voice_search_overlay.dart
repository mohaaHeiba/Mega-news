import 'package:flutter/material.dart' hide SearchController;
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/features/search/controller/search_controller.dart';
import 'package:mega_news/generated/l10n.dart';

Widget voiceSearchOverlay(SearchController controller, S s) {
  return Positioned.fill(
    child: GestureDetector(
      onTap: controller.stopListening,
      child: Container(
        color: Colors.black.withOpacity(0.85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.6),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: const Icon(
                Icons.mic_rounded,
                color: Colors.white,
                size: 70,
              ),
            ),
            AppGaps.h32,
            Text(
              s.search_listening,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            AppGaps.h12,
            Text(
              s.search_listening_hint,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
