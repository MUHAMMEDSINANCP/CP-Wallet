import 'package:cp_wallet/ui/widgets/blur_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonthlyStatCard extends StatelessWidget {
  const MonthlyStatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlurCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    "Profit",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54,
                    ),
                  ),
                ),
                Icon(
                  Icons.ssid_chart_rounded,
                  color: Colors.green,
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "53.2%",
              style: GoogleFonts.electrolize(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Feb",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final color in <Color>[
                  Colors.yellow.shade800,
                  Colors.purple.shade300,
                  Colors.indigo.shade500
                ])
                  Align(
                    widthFactor: 0.60,
                    child: Container(
                      width: 26,
                      height: 26,
                      margin: const EdgeInsets.only(left: 0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border:
                            Border.all(color: Colors.grey.shade700, width: 3),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "B",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
