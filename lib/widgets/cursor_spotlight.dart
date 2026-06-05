import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Wraps a widget. Inside the dark hero, tracks mouse and paints
/// a soft radial glow that follows the cursor.
class CursorSpotlight extends StatefulWidget {
  final Widget child;
  const CursorSpotlight({super.key, required this.child});

  @override
  State<CursorSpotlight> createState() => _CursorSpotlightState();
}

class _CursorSpotlightState extends State<CursorSpotlight> {
  Offset _norm = const Offset(0.5, 0.25);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final s = box.size;
        setState(() => _norm = Offset(
              e.localPosition.dx / s.width,
              e.localPosition.dy / s.height,
            ));
      },
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(painter: _SpotlightPainter(_norm)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Offset norm;
  _SpotlightPainter(this.norm);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(norm.dx * size.width, norm.dy * size.height);
    final radius = size.shortestSide * 0.55;
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary.withValues(alpha: 0.14),
          AppColors.primaryMuted.withValues(alpha: 0.05),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) => old.norm != norm;
}
