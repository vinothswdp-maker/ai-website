import 'package:flutter/material.dart';

/// Wraps any widget with a magnetic hover effect —
/// the child gently drifts toward the cursor when hovered.
class MagneticButton extends StatefulWidget {
  final Widget child;
  final double strength; // 0.0 – 1.0, how strongly it pulls

  const MagneticButton({
    super.key,
    required this.child,
    this.strength = 0.22,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _offset = Offset.zero;

  void _onHover(PointerEvent e) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final size = box.size;
    final dx = (e.localPosition.dx - size.width / 2) * widget.strength;
    final dy = (e.localPosition.dy - size.height / 2) * widget.strength;
    setState(() => _offset = Offset(dx, dy));
  }

  void _onExit(PointerEvent _) => setState(() => _offset = Offset.zero);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onHover,
      onExit: _onExit,
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: _offset),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        builder: (_, off, child) =>
            Transform.translate(offset: off, child: child),
        child: widget.child,
      ),
    );
  }
}
