import 'package:cp_wallet/ui/widgets/blur_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreditCardWidget extends StatelessWidget {
  final double blur;
  const CreditCardWidget({
    super.key,
    this.blur = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: BlurCard(
        blur: blur,
        whiteOpacity: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "VISA",
                    style: GoogleFonts.cuteFont(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Icon(
                    Icons.wallet,
                    color: Colors.white70,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "9123 0987 6543 2109",
                style: GoogleFonts.cuteFont(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "05/28",
                    style: GoogleFonts.cuteFont(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    "***",
                    style: GoogleFonts.cuteFont(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
