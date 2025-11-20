import 'package:flutter/material.dart';
import 'package:mega_news/core/constants/app_gaps.dart';
import 'package:mega_news/core/helper/context_extensions.dart';
import 'package:shimmer/shimmer.dart';

Widget buildArticleShimmer(BuildContext context) {
  return Container(
    color: context.background,

    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  AppGaps.h8,
                  Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  AppGaps.h8,
                  Container(height: 16, width: 150, color: Colors.white),
                  AppGaps.h12,
                  Container(height: 12, width: 100, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
