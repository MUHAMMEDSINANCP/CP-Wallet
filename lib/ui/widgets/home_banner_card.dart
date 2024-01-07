import 'package:flutter/material.dart';

import 'blur_card.dart';

class HomeBannerCard extends StatelessWidget {
  const HomeBannerCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlurCard(
      child: Stack(
        children: [
          Container(),
          const Positioned(
            bottom: -20,
            right: -40,
            child: FlutterLogo(
              size: 240,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Monitor your\nexpenses",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  child: const Text(
                    "Get",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
