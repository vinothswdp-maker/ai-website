import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'scroll_reveal.dart';

class PillarsSection extends StatelessWidget {
  const PillarsSection({super.key});

  static const _pillars = [
    {
      'icon': Icons.speed,
      'title': 'Realtime',
      'subtitle': '<500ms latency',
      'desc': 'Ultra-low latency voice streaming ensures natural, fluid conversations without awkward pauses.',
      'color': Color(0xFFFF6B2B),
    },
    {
      'icon': Icons.graphic_eq,
      'title': 'Audio Quality',
      'subtitle': '30+ accents & voices',
      'desc': 'Crystal-clear audio with noise cancellation, echo suppression, and 30+ natural-sounding accents.',
      'color': Color(0xFF9CA3AF),
    },
    {
      'icon': Icons.chat_bubble_outline,
      'title': 'Conversation',
      'subtitle': 'Human-like turns',
      'desc': 'Advanced turn detection, natural interruption handling, and context-aware responses.',
      'color': Color(0xFF22C55E),
    },
    {
      'icon': Icons.auto_awesome,
      'title': 'Self-Improving',
      'subtitle': 'Auto simulations',
      'desc': 'Agents improve automatically through simulation runs, observability metrics, and continuous feedback.',
      'color': Color(0xFFFF9500),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 64 : 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              ScrollReveal(child: _buildSectionTag('05')),
              const SizedBox(height: 16),
              ScrollReveal(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Four pillars of\nhuman-like AI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: isMobile ? 28 : 42,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ScrollReveal(
                delay: const Duration(milliseconds: 150),
                child: const Text(
                  'Every component engineered for the most natural voice experience.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 17,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_pillars.length, (i) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: i == 0 ? 0 : 10, right: i == _pillars.length - 1 ? 0 : 10),
                          child: ScrollReveal(
                            delay: Duration(milliseconds: 100 + i * 100),
                            child: _PillarCard(pillar: _pillars[i]),
                          ),
                        ),
                      )),
                    )
                  : Column(
                      children: List.generate(_pillars.length, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 80 * i),
                          child: _PillarCard(pillar: _pillars[i]),
                        ),
                      )),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        tag,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _PillarCard extends StatefulWidget {
  final Map<String, dynamic> pillar;
  const _PillarCard({required this.pillar});

  @override
  State<_PillarCard> createState() => _PillarCardState();
}

class _PillarCardState extends State<_PillarCard> {
  bool _hovered = false;
  double _tiltX = 0;
  double _tiltY = 0;

  @override
  Widget build(BuildContext context) {
    final color = widget.pillar['color'] as Color;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _tiltX = 0;
        _tiltY = 0;
      }),
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox?;
        if (box == null) return;
        final size = box.size;
        setState(() {
          _tiltX = (e.localPosition.dx - size.width / 2) / size.width;
          _tiltY = (e.localPosition.dy - size.height / 2) / size.height;
        });
      },
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(end: Offset(_tiltX, _tiltY)),
        duration: const Duration(milliseconds: 180),
        builder: (_, tilt, child) => Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(-tilt.dy * 0.18)
            ..rotateY(tilt.dx * 0.18),
          alignment: Alignment.center,
          child: child,
        ),
        child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered ? color.withValues(alpha: 0.04) : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? color.withValues(alpha: 0.4) : AppColors.border,
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: color.withValues(alpha: 0.12), blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: _hovered ? 0.18 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.pillar['icon'] as IconData, color: color, size: 24),
            ),
            const SizedBox(height: 20),
            Text(
              widget.pillar['title'] as String,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              widget.pillar['subtitle'] as String,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Text(
              widget.pillar['desc'] as String,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    ),   // TweenAnimationBuilder
    );
  }
}
