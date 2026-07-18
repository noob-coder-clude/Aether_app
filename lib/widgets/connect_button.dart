import 'package:flutter/material.dart';

enum ConnectionStatus { disconnected, connecting, connected, error }

class ConnectButton extends StatelessWidget {
  final ConnectionStatus status;
  final VoidCallback onTap;

  const ConnectButton({
    super.key,
    required this.status,
    required this.onTap,
  });

  Color _getGradientColor1() {
    switch (status) {
      case ConnectionStatus.connected:
        return const Color(0xFF00E676);
      case ConnectionStatus.connecting:
        return const Color(0xFFFFD600);
      case ConnectionStatus.error:
        return const Color(0xFFFF1744);
      case ConnectionStatus.disconnected:
      default:
        return const Color(0xFF00E5FF);
    }
  }

  Color _getGradientColor2() {
    switch (status) {
      case ConnectionStatus.connected:
        return const Color(0xFF00B0FF);
      case ConnectionStatus.connecting:
        return const Color(0xFFFF9100);
      case ConnectionStatus.error:
        return const Color(0xFFD50000);
      case ConnectionStatus.disconnected:
      default:
        return const Color(0xFF7C4DFF);
    }
  }

  IconData _getIcon() {
    switch (status) {
      case ConnectionStatus.connected:
        return Icons.power_settings_new_rounded;
      case ConnectionStatus.connecting:
        return Icons.sync_rounded;
      case ConnectionStatus.error:
        return Icons.warning_amber_rounded;
      case ConnectionStatus.disconnected:
      default:
        return Icons.power_settings_new_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c1 = _getGradientColor1();
    final c2 = _getGradientColor2();

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [c1, c2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: c1.withOpacity(0.45),
              blurRadius: status == ConnectionStatus.connected ? 36 : 20,
              spreadRadius: status == ConnectionStatus.connected ? 8 : 2,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0B0E14),
            ),
            child: Icon(
              _getIcon(),
              size: 64,
              color: c1,
            ),
          ),
        ),
      ),
    );
  }
}
