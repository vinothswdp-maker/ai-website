import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FloatingParticles extends StatefulWidget {
  final int count;
  const FloatingParticles({super.key, this.count = 18});

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late List<_Particle> _particles;
  final math.Random _rng = math.Random(42);

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _particles = List.generate(widget.count, (_) => _Particle(_rng));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => CustomPaint(
          painter: _ParticlePainter(_particles, _ctrl.value),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _Particle {
  final double x;      // 0–1 horizontal start
  final double y;      // 0–1 vertical start
  final double size;   // radius
  final double speed;  // vertical drift speed multiplier
  final double phase;  // animation phase offset
  final double alpha;

  _Particle(math.Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        size = 1.5 + rng.nextDouble() * 2.5,
        speed = 0.3 + rng.nextDouble() * 0.7,
        phase = rng.nextDouble(),
        alpha = 0.06 + rng.nextDouble() * 0.12;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double t;
  _ParticlePainter(this.particles, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final progress = ((t * p.speed + p.phase) % 1.0);
      final dx = p.x * size.width +
          math.sin(progress * 2 * math.pi + p.phase * 6) * 18;
      // float upward, wrap around
      final dy = ((p.y - progress * 0.6) % 1.0) * size.height;
      final paint = Paint()
        ..color = AppColors.primary.withValues(alpha: p.alpha)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => old.t != t;
}
