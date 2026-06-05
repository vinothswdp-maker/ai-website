import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'scroll_reveal.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isMobile = MediaQuery.of(context).size.width < 600;

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
              ScrollReveal(child: _buildSectionTag('03')),
              const SizedBox(height: 16),
              ScrollReveal(
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'Two ways to build.\nOne powerful platform.',
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
                  'Whether you prefer code or visual tools, Pulse has you covered.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 17, height: 1.6),
                ),
              ),
              const SizedBox(height: 64),
              isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ScrollReveal(
                            delay: const Duration(milliseconds: 100),
                            slideOffset: 40,
                            child: _buildApiCard(),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: ScrollReveal(
                            delay: const Duration(milliseconds: 220),
                            slideOffset: 40,
                            child: _buildNoCodeCard(),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        ScrollReveal(child: _buildApiCard()),
                        const SizedBox(height: 24),
                        ScrollReveal(
                          delay: const Duration(milliseconds: 120),
                          child: _buildNoCodeCard(),
                        ),
                      ],
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

  Widget _buildApiCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'For Developers',
              style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Programmable Voice API',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'Full control over TTS, STT, turn detection, VAD, and more with our flexible REST APIs.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 28),
          const _TypingCodeCard(),
          const SizedBox(height: 28),
          _buildFeatureList([
            'Text-to-Speech (30+ voices)',
            'Speech-to-Text (real-time)',
            'Turn detection & VAD',
            'Interruption handling',
            'WebSocket streaming',
          ], isDark: true),
        ],
      ),
    );
  }

  Widget _buildNoCodeCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'For Teams',
              style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No-Code Studio',
            style: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Build and deploy voice agents visually with our drag-and-drop studio. No coding required.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15, height: 1.6),
          ),
          const SizedBox(height: 28),
          _buildVisualBuilder(),
          const SizedBox(height: 28),
          _buildFeatureList([
            'Visual prompt builder',
            'Pre-built templates',
            'One-click deployment',
            'Analytics dashboard',
            'A/B testing',
          ], isDark: false),
        ],
      ),
    );
  }

  Widget _buildVisualBuilder() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildFlowNode('Start', Icons.play_circle, AppColors.success),
          _buildConnector(),
          _buildFlowNode('Greet User', Icons.record_voice_over, AppColors.primary),
          _buildConnector(),
          _buildFlowNode('Handle Intent', Icons.account_tree, AppColors.primaryMuted),
          _buildConnector(),
          _buildFlowNode('Complete Task', Icons.check_circle, AppColors.success),
        ],
      ),
    );
  }

  Widget _buildFlowNode(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          const Spacer(),
          Icon(Icons.drag_indicator, color: AppColors.textLight, size: 16),
        ],
      ),
    );
  }

  Widget _buildConnector() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Center(child: Container(width: 2, height: 20, color: AppColors.border)),
    );
  }

  Widget _buildFeatureList(List<String> items, {required bool isDark}) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.success, size: 13),
              ),
              const SizedBox(width: 10),
              Text(
                item,
                style: TextStyle(
                  color: isDark ? Colors.white.withValues(alpha: 0.75) : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─── Typing Code Card ─────────────────────────────────────────────────────

class _TypingCodeCard extends StatefulWidget {
  const _TypingCodeCard();

  @override
  State<_TypingCodeCard> createState() => _TypingCodeCardState();
}

class _TypingCodeCardState extends State<_TypingCodeCard> {
  static const _lines = [
    'const agent = await pulse.voice.create({',
    '  model: "gemini-2.0-flash",',
    '  voice: "en-US-Neural2-F",',
    '  instructions: "You are helpful.",',
    '  tools: [searchTool, calendarTool],',
    '});',
  ];

  int _visibleLines = 0;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _scheduleNextLine();
  }

  void _scheduleNextLine() {
    Future.delayed(Duration(milliseconds: 700 + _visibleLines * 380), () {
      if (!mounted) return;
      if (_visibleLines < _lines.length) {
        setState(() => _visibleLines++);
        if (_visibleLines < _lines.length) {
          _scheduleNextLine();
        } else {
          Future.delayed(const Duration(milliseconds: 600),
              () { if (mounted) setState(() => _done = true); });
        }
      }
    });
  }

  Widget _dot(Color color) => Container(
        width: 10, height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _dot(Colors.red), const SizedBox(width: 6),
            _dot(Colors.orange), const SizedBox(width: 6),
            _dot(Colors.green),
          ]),
          const SizedBox(height: 16),
          ...List.generate(_lines.length, (i) {
            final visible = i < _visibleLines;
            final isCursor = i == _visibleLines - 1 && !_done;
            return AnimatedOpacity(
              opacity: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedSlide(
                offset: visible ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: _CodeLine(
                  text: _lines[i],
                  showCursor: isCursor,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CodeLine extends StatefulWidget {
  final String text;
  final bool showCursor;
  const _CodeLine({required this.text, required this.showCursor});

  @override
  State<_CodeLine> createState() => _CodeLineState();
}

class _CodeLineState extends State<_CodeLine>
    with SingleTickerProviderStateMixin {
  late AnimationController _cursorCtrl;

  @override
  void initState() {
    super.initState();
    _cursorCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cursorCtrl,
      builder: (_, _) {
        final cursor = widget.showCursor && _cursorCtrl.value > 0.5 ? '▋' : '';
        return Text(
          '${widget.text}$cursor',
          style: TextStyle(
            color: AppColors.primaryLight,
            fontSize: 12.5,
            fontFamily: 'monospace',
            height: 1.75,
          ),
        );
      },
    );
  }
}
