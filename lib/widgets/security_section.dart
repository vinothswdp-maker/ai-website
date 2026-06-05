import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'scroll_reveal.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  static const _badges = [
    {'label': 'HIPAA', 'color': Color(0xFF22C55E)},
    {'label': 'GDPR', 'color': Color(0xFFFF6B2B)},
    {'label': 'SOC 2', 'color': Color(0xFF6B7280)},
    {'label': 'PCI DSS', 'color': Color(0xFFFF9500)},
    {'label': 'ISO 27001', 'color': Color(0xFFEA580C)},
  ];

  static const _features = [
    {
      'icon': Icons.lock_outline,
      'title': 'End-to-End Encryption',
      'desc': 'All data encrypted in transit with TLS 1.3 and at rest with AES-256.',
      'color': Color(0xFFFF6B2B),
    },
    {
      'icon': Icons.public,
      'title': 'Data Residency',
      'desc': 'Choose where your data lives — US, EU, or APAC regions.',
      'color': Color(0xFF22C55E),
    },
    {
      'icon': Icons.receipt_long,
      'title': 'Audit Readiness',
      'desc': 'Complete audit trails, access logs, and compliance reports on demand.',
      'color': Color(0xFF6B7280),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      color: AppColors.backgroundLight,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 48,
        vertical: isMobile ? 64 : 96,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              ScrollReveal(child: _buildSectionTag('06')),
              const SizedBox(height: 16),
              ScrollReveal(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Enterprise-grade\nsecurity by default',
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
                  'Security and compliance are not afterthoughts — they are built into every layer.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 17, height: 1.6),
                ),
              ),
              const SizedBox(height: 48),
              ScrollReveal(
                delay: const Duration(milliseconds: 200),
                child: _buildComplianceBadges(),
              ),
              const SizedBox(height: 64),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(_features.length, (i) => Expanded(
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 100 + i * 110),
                          child: _SecurityCard(feature: _features[i]),
                        ),
                      )),
                    )
                  : Column(
                      children: List.generate(_features.length, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ScrollReveal(
                          delay: Duration(milliseconds: 80 * i),
                          child: _SecurityCard(feature: _features[i]),
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

  Widget _buildComplianceBadges() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: _badges.map((badge) {
        final color = badge['color'] as Color;
        return _BadgeChip(label: badge['label'] as String, color: color);
      }).toList(),
    );
  }
}

class _BadgeChip extends StatefulWidget {
  final String label;
  final Color color;
  const _BadgeChip({required this.label, required this.color});

  @override
  State<_BadgeChip> createState() => _BadgeChipState();
}

class _BadgeChipState extends State<_BadgeChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: _hovered ? widget.color.withValues(alpha: 0.06) : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? widget.color.withValues(alpha: 0.5) : widget.color.withValues(alpha: 0.25),
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: widget.color.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurityCard extends StatefulWidget {
  final Map<String, dynamic> feature;
  const _SecurityCard({required this.feature});

  @override
  State<_SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<_SecurityCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.feature['color'] as Color;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered ? color.withValues(alpha: 0.04) : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? color.withValues(alpha: 0.35) : AppColors.border,
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: _hovered ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.feature['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 20),
            Text(
              widget.feature['title'] as String,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            Text(
              widget.feature['desc'] as String,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.65),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Learn more', style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                AnimatedSlide(
                  offset: _hovered ? const Offset(0.2, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.arrow_forward, color: color, size: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
