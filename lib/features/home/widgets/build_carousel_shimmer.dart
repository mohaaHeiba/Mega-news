import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildCarouselShimmer(final context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
    ),
  );
}
