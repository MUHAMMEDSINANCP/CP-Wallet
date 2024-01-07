import 'package:flutter/material.dart';

const Duration detailPageEntryDuration = Duration(milliseconds: 900);

(Offset, Size) getOffsetSizeFromKey(GlobalKey key) {
  try {
    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    return (renderBox.localToGlobal(Offset.zero), renderBox.size);
  } catch (e) {
    debugPrint("Exception: $key");
    rethrow;
  }
}
