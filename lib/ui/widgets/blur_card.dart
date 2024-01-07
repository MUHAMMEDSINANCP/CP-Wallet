import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderWidth;
  final Clip clipBehaviour;
  final double? width;
  final double whiteOpacity;
  const BlurCard({
    super.key,
    required this.child,
    this.blur = 20,
    this.borderWidth = 0.7,
    this.clipBehaviour = Clip.antiAlias,
    this.width = double.infinity,
    this.whiteOpacity = 0.15,
  });

  double get _borderRadius => 24;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: clipBehaviour,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 8,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(whiteOpacity),
            blurRadius: 20,
            spreadRadius: -10,
          ),
        ],
        border: Border.all(
          color: Colors.white.withOpacity(0.4),
          width: borderWidth,
        ),
      ),
      width: width,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_borderRadius),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blur,
                  sigmaY: blur,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
