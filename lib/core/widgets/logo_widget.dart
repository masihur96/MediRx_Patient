import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MediRxLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;
  final Color? textColor;

  const MediRxLogo({
    super.key,
    this.size = 100,
    this.showText = true,
    this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.primaryTeal;
    final effectiveTextColor = textColor ?? AppColors.primaryTeal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // A stylized icon to represent the logo in the image
        // Since we don't have the exact asset, we use a combination of icons
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.health_and_safety, // A placeholder for the cross/leaf icon
              size: size,
              color: effectiveColor,
            ),
            // We can add some overlay if we want to make it look unique
            Positioned(
              right: size * 0.1,
              bottom: size * 0.1,
              child: Icon(
                Icons.eco, // represents the leaf part
                size: size * 0.4,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
        if (showText) ...[
          SizedBox(height: size * 0.1),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Medi',
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.bold,
                  color: effectiveTextColor,
                ),
              ),
              Text(
                'Rx',
                style: TextStyle(
                  fontSize: size * 0.35,
                  fontWeight: FontWeight.w400, // Lighter weight for Rx
                  color: effectiveTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: size * 0.05),
          Text(
            'Your Digital Health Partner',
            style: TextStyle(
              fontSize: size * 0.12,
              fontWeight: FontWeight.w500,
              color: effectiveTextColor.withOpacity(0.7),
            ),
          ),
        ],
      ],
    );
  }
}
