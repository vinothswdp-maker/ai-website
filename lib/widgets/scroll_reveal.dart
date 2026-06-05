import 'package:flutter/material.dart';
import '../utils/page_scroll.dart';

class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final double slideOffset;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 550),
    this.slideOffset = 28,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _slide;
  bool _triggered = false;
  late VoidCallback _listener;
  ScrollController? _sc;
  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: widget.duration, vsync: this);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<double>(begin: widget.slideOffset, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _listener = _check;
    WidgetsBinding.instance.addPostFrameCallback((_) => _subscribe());
  }

  void _subscribe() {
    if (!mounted) return;
    try {
      _sc = PageScroll.of(context);
      _sc!.addListener(_listener);
      _check(); // check immediately in case already visible
    } catch (_) {
      _trigger();
    }
  }

  void _check() {
    if (_triggered || !mounted) return;
    final box = _key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;
    final dy = box.localToGlobal(Offset.zero).dy;
    final screenH = MediaQuery.of(context).size.height;
    if (dy < screenH * 0.94) _trigger();
  }

  void _trigger() {
    if (_triggered) return;
    _triggered = true;
    // Remove listener immediately — no more overhead after trigger
    _sc?.removeListener(_listener);
    if (widget.delay == Duration.zero) {
      if (mounted) _ctrl.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _ctrl.forward();
      });
    }
  }

  @override
  void dispose() {
    _sc?.removeListener(_listener);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: FadeTransition(
        key: _key,
        opacity: _fade,
        child: AnimatedBuilder(
          animation: _slide,
          builder: (_, child) =>
              Transform.translate(offset: Offset(0, _slide.value), child: child),
          child: widget.child,
        ),
      ),
    );
  }
}
