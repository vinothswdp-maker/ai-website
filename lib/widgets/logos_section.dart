import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'scroll_reveal.dart';

class LogosSection extends StatelessWidget {
  const LogosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollReveal(
      delay: const Duration(milliseconds: 100),
      child: Container(
        width: double.infinity,
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            Text(
              'TRUSTED BY 50,000+ BUSINESSES WORLDWIDE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 40),
            const _SmoothMarquee(reverse: false, durationSeconds: 32),
            const SizedBox(height: 16),
            const _SmoothMarquee(reverse: true, durationSeconds: 28),
          ],
        ),
      ),
    );
  }
}

/// Smooth infinite marquee using AnimationController + Transform.translate.
/// No ScrollController, no Timer, no jumpTo — zero jank.
class _SmoothMarquee extends StatefulWidget {
  final bool reverse;
  final int durationSeconds;

  const _SmoothMarquee({
    this.reverse = false,
    this.durationSeconds = 30,
  });

  @override
  State<_SmoothMarquee> createState() => _SmoothMarqueeState();
}

class _SmoothMarqueeState extends State<_SmoothMarquee>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  // Estimated width per chip (padding + text + margin)
  static const double _chipWidth = 152.0;

  static const _companies = [
    'Meta', 'Uber', 'Zomato', 'Discord', 'GoDaddy',
    'Razorpay', 'Nykaa', 'Freshworks', 'Swiggy', 'PhonePe',
    'PolicyBazaar', 'Meesho', 'ShareChat', 'Ola', 'Zepto',
  ];

  // totalWidth = one copy of all companies
  double get _oneSetWidth => _chipWidth * _companies.length;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: Duration(seconds: widget.durationSeconds),
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
    // Render 3 copies so the loop is always seamless
    final allItems = [..._companies, ..._companies, ..._companies];

    return SizedBox(
      height: 52,
      child: RepaintBoundary(
        child: ClipRect(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) {
              final offset = widget.reverse
                  ? -_oneSetWidth + _ctrl.value * _oneSetWidth
                  : -_ctrl.value * _oneSetWidth;
              return Transform.translate(
                offset: Offset(offset, 0),
                child: child,
              );
            },
            // OverflowBox removes the tight width constraint so the Row
            // can be wider than the screen without triggering overflow warnings
            child: OverflowBox(
              maxWidth: double.infinity,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: allItems.map((name) => _LogoChip(name: name)).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoChip extends StatefulWidget {
  final String name;
  const _LogoChip({required this.name});

  @override
  State<_LogoChip> createState() => _LogoChipState();
}

class _LogoChipState extends State<_LogoChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 132,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.backgroundGray : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? AppColors.primary.withValues(alpha: 0.3)
                : AppColors.border,
          ),
        ),
        child: Text(
          widget.name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _hovered ? AppColors.primary : AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
