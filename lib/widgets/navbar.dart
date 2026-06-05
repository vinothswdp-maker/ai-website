import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/page_scroll.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> with SingleTickerProviderStateMixin {
  bool _scrolled = false;
  String? _hoveredItem;
  ScrollController? _sc;
  VoidCallback? _listener;
  late AnimationController _staggerCtrl;

  static const _navItems = ['AI Agents', 'Platform', 'Docs', 'Pricing'];

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Remove old listener before adding new one — prevents listener leak
    if (_listener != null) _sc?.removeListener(_listener!);
    try {
      _sc = PageScroll.of(context);
      _listener = _onScroll;
      _sc!.addListener(_listener!);
    } catch (_) {}
  }

  void _onScroll() {
    final s = (_sc?.offset ?? 0) > 10;
    if (s != _scrolled) setState(() => _scrolled = s);
  }

  @override
  void dispose() {
    if (_listener != null) _sc?.removeListener(_listener!);
    _staggerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return RepaintBoundary(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(bottom: BorderSide(color: AppColors.border)),
          boxShadow: _scrolled
              ? [BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                )]
              : [],
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    _buildLogo(),
                    const SizedBox(width: 40),
                                    if (isDesktop)
                      ..._navItems.asMap().entries.map(
                        (e) => _buildNavItem(e.value, e.key),
                      ),
                    const Spacer(),
                    if (isDesktop) ...[
                      _buildTextBtn('Login'),
                      const SizedBox(width: 8),
                      _buildOutlineBtn('Contact Sales'),
                      const SizedBox(width: 8),
                      const _NavCta(label: 'Sign up for free'),
                    ] else
                      IconButton(
                        icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                        onPressed: () {},
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: Text('P',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
          ),
        ),
        const SizedBox(width: 10),
        const Text('Pulse',
            style: TextStyle(
                color: AppColors.textPrimary, fontSize: 20,
                fontWeight: FontWeight.w800, letterSpacing: -0.5)),
      ],
    );
  }

  Widget _buildNavItem(String label, [int index = 0]) {
    final start = index * 0.15;
    final end = (start + 0.55).clamp(0.0, 1.0);
    final anim = CurvedAnimation(
      parent: _staggerCtrl,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    final isHovered = _hoveredItem == label;
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.4),
          end: Offset.zero,
        ).animate(anim),
        child: MouseRegion(
      onEnter: (_) => setState(() => _hoveredItem = label),
      onExit: (_) => setState(() => _hoveredItem = null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 150),
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: isHovered ? AppColors.primary : AppColors.textPrimary,
                ),
                child: Text(label),
              ),
              const SizedBox(width: 4),
              AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: isHovered ? 0.5 : 0,
                child: Icon(Icons.keyboard_arrow_down, size: 16,
                    color: isHovered ? AppColors.primary : AppColors.textSecondary),
              ),
            ],
          ),
        ),   // TextButton
      ),     // Padding
    ),       // MouseRegion
  ),         // SlideTransition
);           // FadeTransition
  }

  Widget _buildTextBtn(String label) => TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      );

  Widget _buildOutlineBtn(String label) => OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      );
}

class _NavCta extends StatefulWidget {
  final String label;
  const _NavCta({required this.label});

  @override
  State<_NavCta> createState() => _NavCtaState();
}

class _NavCtaState extends State<_NavCta> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          gradient: _hovered
              ? const LinearGradient(colors: [Color(0xFFFF8C42), Color(0xFFFFAD00)])
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 12, offset: const Offset(0, 4))]
              : [],
        ),
        child: TextButton(
          onPressed: () => Navigator.pushNamed(context, '/signup'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(widget.label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
