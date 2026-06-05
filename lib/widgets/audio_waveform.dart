import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated sine-wave strip — place at the bottom of the hero section.
class AudioWaveform extends StatefulWidget {
  final double height;
  const AudioWaveform({super.key, this.height = 72});

  @override
  State<AudioWaveform> createState() => _AudioWaveformState();
}

class _AudioWaveformState extends State<AudioWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: double.infinity,
        height: widget.height,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, _) => CustomPaint(
            painter: _WavePainter(_ctrl.value),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double phase;
  _WavePainter(this.phase);

  void _drawWave(
    Canvas canvas,
    Size size,
    double phaseOffset,
    double amplitude,
    Color color,
    double strokeWidth,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final midY = size.height * 0.5;
    final totalPhase = (phase + phaseOffset) * 2 * math.pi;
    const step = 3.0;

    for (double x = 0; x <= size.width; x += step) {
      final y = midY +
          math.sin((x / size.width * 2.5 * math.pi) + totalPhase) *
              amplitude +
          math.sin((x / size.width * 4 * math.pi) + totalPhase * 0.7) *
              (amplitude * 0.4);
      x == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawWave(canvas, size, 0.0, size.height * 0.22,
        AppColors.primary.withValues(alpha: 0.30), 1.8);
    _drawWave(canvas, size, 0.28, size.height * 0.15,
        AppColors.primaryMuted.withValues(alpha: 0.18), 1.4);
    _drawWave(canvas, size, 0.55, size.height * 0.10,
        AppColors.primary.withValues(alpha: 0.10), 1.0);
  }

  @override
  bool shouldRepaint(_WavePainter old) => old.phase != phase;
}
