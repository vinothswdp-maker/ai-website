import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/page_scroll.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/logos_section.dart';
import '../widgets/features_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/pillars_section.dart';
import '../widgets/security_section.dart';
import '../widgets/cta_section.dart';
import '../widgets/footer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 400;
      if (show != _showScrollTop) setState(() => _showScrollTop = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScroll(
      controller: _scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      Navbar(),
                      HeroSection(),
                      LogosSection(),
                      FeaturesSection(),
                      StatsSection(),
                      PillarsSection(),
                      SecuritySection(),
                      CtaSection(),
                      Footer(),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _ScrollProgressBar(controller: _scrollController),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              bottom: _showScrollTop ? 32 : -60,
              right: 32,
              child: AnimatedOpacity(
                opacity: _showScrollTop ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: AppColors.primary,
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(Icons.keyboard_arrow_up,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollProgressBar extends StatefulWidget {
  final ScrollController controller;
  const _ScrollProgressBar({required this.controller});

  @override
  State<_ScrollProgressBar> createState() => _ScrollProgressBarState();
}

class _ScrollProgressBarState extends State<_ScrollProgressBar> {
  double _progress = 0;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _listener = _onScroll;
    widget.controller.addListener(_listener);
  }

  void _onScroll() {
    final sc = widget.controller;
    if (!sc.hasClients || sc.position.maxScrollExtent == 0) return;
    final p = sc.offset / sc.position.maxScrollExtent;
    if ((p - _progress).abs() > 0.002) setState(() => _progress = p.clamp(0, 1));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        height: 3,
        child: LinearProgressIndicator(
          value: _progress,
          backgroundColor: Colors.transparent,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          minHeight: 3,
        ),
      ),
    );
  }
}
