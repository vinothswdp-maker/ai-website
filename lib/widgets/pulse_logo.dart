import 'package:flutter/material.dart';

class PulseLogoWidget extends StatefulWidget {
  final Color textColor;
  final Color ecgColor;
  final double fontSize;

  const PulseLogoWidget({
    super.key,
    this.textColor = Colors.white,
    this.ecgColor = const Color(0xFF0891B2),
    this.fontSize = 52,
  });

  @override
  State<PulseLogoWidget> createState() => _PulseLogoWidgetState();
}

class _PulseLogoWidgetState extends State<PulseLogoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.fontSize * 1.25;
    final w = widget.fontSize * 4.6;
    final amplitude = h * 0.48;

    return RepaintBoundary(
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ECG line layer
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (_, _) => CustomPaint(
                  painter: _EcgPainter(
                    progress: _ctrl.value,
                    color: widget.ecgColor,
                    amplitude: amplitude,
                  ),
                ),
              ),
            ),
            // Text layer
            Text(
              'pulse',
              style: TextStyle(
                color: widget.textColor,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.w900,
                height: 1.15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ECG painter ──────────────────────────────────────────────────────────

class _EcgPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double amplitude;

  _EcgPainter({
    required this.progress,
    required this.color,
    required this.amplitude,
  });

  // ECG waypoints: [x 0–1, y −1=up … +1=down]
  static const _pts = [
    [0.00, 0.0],
    [0.06, 0.0],
    [0.08, -0.18], // P-wave
    [0.10, 0.0],
    [0.13, 0.0],
    [0.145, 0.20], // Q
    [0.155, -1.10], // R spike ↑
    [0.165, 0.28], // S ↓
    [0.175, 0.0],
    [0.22, 0.0],
    [0.245, -0.22], // T-wave
    [0.275, 0.0],
    [0.36, 0.0],
    [0.375, 0.20], // Q
    [0.385, -1.10], // R spike ↑
    [0.395, 0.28], // S ↓
    [0.405, 0.0],
    [0.46, 0.0],
    [0.485, -0.20], // T-wave
    [0.515, 0.0],
    [0.62, 0.0],
    [0.635, 0.20], // Q
    [0.645, -1.05], // R spike ↑
    [0.655, 0.26], // S ↓
    [0.665, 0.0],
    [0.72, 0.0],
    [0.745, -0.18], // T-wave
    [0.775, 0.0],
    [1.00, 0.0],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final midY = size.height * 0.55;

    final path = Path();
    for (int i = 0; i < _pts.length; i++) {
      final x = _pts[i][0] * size.width;
      final y = midY + _pts[i][1] * amplitude;
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }

    // Glow behind
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.25)
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // Main line
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Moving dot
    final metrics = path.computeMetrics().toList();
    if (metrics.isNotEmpty) {
      final tangent =
          metrics[0].getTangentForOffset(metrics[0].length * progress);
      if (tangent != null) {
        final pos = tangent.position;
        // Outer glow
        canvas.drawCircle(
          pos,
          10,
          Paint()
            ..color = color.withValues(alpha: 0.20)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
        );
        // Inner dot
        canvas.drawCircle(
          pos,
          3.5,
          Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_EcgPainter old) => old.progress != progress;
}
