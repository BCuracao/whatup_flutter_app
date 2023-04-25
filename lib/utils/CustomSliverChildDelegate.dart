// ignore: file_names
import 'package:flutter/material.dart';

class CustomSliverChildDelegate extends SliverChildDelegate {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final List<double> heightFactors;

  CustomSliverChildDelegate({
    required this.itemCount,
    required this.itemBuilder,
    required this.heightFactors,
  });

  @override
  Widget? build(BuildContext context, int index) {
    if (index >= itemCount) return null;
    return itemBuilder(context, index);
  }

  @override
  double? estimateMaxScrollOffset(
    int firstIndex,
    int lastIndex,
    double leadingScrollOffset,
    double trailingScrollOffset,
  ) {
    return itemCount *
        (trailingScrollOffset - leadingScrollOffset) /
        (lastIndex - firstIndex + 1);
  }

  @override
  bool shouldRebuild(covariant CustomSliverChildDelegate oldDelegate) {
    return itemCount != oldDelegate.itemCount ||
        itemBuilder != oldDelegate.itemBuilder ||
        heightFactors != oldDelegate.heightFactors;
  }

  @override
  int? estimateIndexOf(double scrollOffset) => null;

  @override
  double? getLayoutDimension(int index) {
    return heightFactors[index];
  }

  @override
  int get estimatedChildCount => itemCount;
}
