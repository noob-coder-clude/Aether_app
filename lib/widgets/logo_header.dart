import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoHeader extends StatelessWidget {
  final double size;
  const LogoHeader({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00E5FF).withOpacity(0.35),
                blurRadius: 28,
                spreadRadius: 4,
              ),
              BoxShadow(
                color: const Color(0xFF7C4DFF).withOpacity(0.25),
                blurRadius: 40,
                spreadRadius: 8,
              ),
            ],
          ),
          child: SvgPicture.asset(
            'assets/logo/aether_logo.svg',
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
