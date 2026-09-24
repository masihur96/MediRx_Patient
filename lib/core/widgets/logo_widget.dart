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
    final effectiveTextColor = textColor ?? AppColors.primaryTeal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Using the extracted logo image
        ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.2),
          child: Image.asset(
            'assets/images/logo.jpg',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to icon if asset fails to load
              return Icon(
                Icons.health_and_safety,
                size: size,
                color: color ?? AppColors.primaryTeal,
              );
            },
          ),
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
                  fontWeight: FontWeight.w400,
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
