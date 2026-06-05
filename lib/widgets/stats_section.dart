import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'scroll_reveal.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  static const _stats = [
    {'value': '5B+', 'label': 'API calls served', 'sublabel': 'per month'},
    {'value': '50K+', 'label': 'Businesses', 'sublabel': 'trust Pulse'},
    {'value': '150+', 'label': 'Countries', 'sublabel': 'supported'},
    {'value': '99.99%', 'label': 'Uptime SLA', 'sublabel': 'guaranteed'},
  ];

  static const _infra = [
    {
      'icon': Icons.cloud,
      'title': 'Global Edge Network',
      'desc': 'Points of presence across 6 continents for minimal latency',
    },
    {
      'icon': Icons.shield,
      'title': 'Enterprise Security',
      'desc': 'HIPAA, GDPR, SOC 2 Type II, PCI DSS compliant',
    },
    {
      'icon': Icons.bar_chart,
      'title': 'Real-time Analytics',
      'desc': 'Full observability with dashboards and alerting',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 64 : 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              ScrollReveal(
                child: _buildSectionTag('04'),
              ),
              const SizedBox(height: 16),
              ScrollReveal(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Infrastructure built\nfor enterprise scale',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 28 : 42,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                    letterSpacing: -1,
                  ),
                ),
              ),
              const SizedBox(height: 64),
              ScrollReveal(
                delay: const Duration(milliseconds: 200),
                child: isDesktop
                    ? Row(
                        children: _stats
                            .map((s) => Expanded(child: _CountUpStat(stat: s)))
                            .toList(),
                      )
                    : Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: _stats
                            .map((s) => SizedBox(
                                  width: isMobile ? double.infinity : 200,
                                  child: _CountUpStat(stat: s),
                                ))
                            .toList(),
                      ),
              ),
              const SizedBox(height: 64),
              ScrollReveal(
                delay: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08)),
                  ),
                  child: isDesktop
                      ? Row(
                          children: _infra
                              .map((item) => Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: _InfraItem(item: item),
                                    ),
                                  ))
                              .toList(),
                        )
                      : Column(
                          children: _infra
                              .map((item) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 12),
                                    child: _InfraItem(item: item),
                                  ))
                              .toList(),
                        ),
                ),
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
        color: AppColors.primary.withValues(alpha: 0.2),
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

class _CountUpStat extends StatefulWidget {
  final Map<String, String> stat;
  const _CountUpStat({required this.stat});

  @override
  State<_CountUpStat> createState() => _CountUpStatState();
}

class _CountUpStatState extends State<_CountUpStat>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;

  // Scramble state
  String _displayed = '';
  Timer? _scrambleTimer;
  final math.Random _rng = math.Random();
  static const _chars = '0123456789';

  @override
  void initState() {
    super.initState();
    _displayed = widget.stat['value']!;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _anim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _anim.addListener(_onAnim);
    Future.delayed(
      const Duration(milliseconds: 400),
      () { if (mounted) _startScramble(); },
    );
  }

  void _startScramble() {
    _controller.forward();
    // Fast scramble timer — runs every 45 ms and updates visible digits
    _scrambleTimer = Timer.periodic(const Duration(milliseconds: 45), (_) {
      if (!mounted) return;
      setState(() => _displayed = _scrambledValue(_anim.value));
      if (_anim.isCompleted) {
        _scrambleTimer?.cancel();
        _displayed = widget.stat['value']!;
      }
    });
  }

  /// For each digit in the final string, if that position is "settled"
  /// (progress past a per-digit threshold) show the real digit, else scramble.
  String _scrambledValue(double progress) {
    final raw = widget.stat['value']!;
    final buf = StringBuffer();
    int digitIndex = 0;
    int totalDigits = raw.replaceAll(RegExp(r'[^\d]'), '').length;
    if (totalDigits == 0) return raw;

    for (int i = 0; i < raw.length; i++) {
      final ch = raw[i];
      if (RegExp(r'\d').hasMatch(ch)) {
        // Each digit settles left-to-right: digit 0 settles at progress=0.25,
        // last digit settles at progress=0.90
        final settleAt = 0.25 + (digitIndex / math.max(totalDigits - 1, 1)) * 0.65;
        if (progress >= settleAt) {
          buf.write(ch);
        } else {
          buf.write(_chars[_rng.nextInt(_chars.length)]);
        }
        digitIndex++;
      } else {
        buf.write(ch);
      }
    }
    return buf.toString();
  }

  void _onAnim() {
    if (_anim.isCompleted && mounted) {
      setState(() => _displayed = widget.stat['value']!);
    }
  }

  @override
  void dispose() {
    _scrambleTimer?.cancel();
    _anim.removeListener(_onAnim);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _displayed,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            letterSpacing: -2,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.stat['label']!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          widget.stat['sublabel']!,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.45),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _InfraItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const _InfraItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child:
              Icon(item['icon'] as IconData, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['desc'] as String,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.55),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
