import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'typewriter_text.dart';
import 'cursor_spotlight.dart';
import 'audio_waveform.dart';
import 'magnetic_button.dart';
import 'floating_particles.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 1024;
    final isMobile = width < 600;

    return CursorSpotlight(
      child: Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          _buildGridPattern(),
          _buildGlowEffect(),
          const Positioned.fill(child: FloatingParticles(count: 22)),
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: AudioWaveform(height: 80),
          ),
          const Positioned(
            bottom: 24, left: 0, right: 0,
            child: _BouncingArrow(),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 48,
                  vertical: isMobile ? 64 : 100,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: isDesktop
                        ? _buildDesktopLayout()
                        : _buildMobileLayout(isMobile),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),   // Container
    );   // CursorSpotlight
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: _buildLeftContent(isMobile: false),
        ),
        const SizedBox(width: 64),
        Expanded(
          flex: 4,
          child: const _FloatingDemo(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isMobile) {
    return Column(
      children: [
        _buildLeftContent(isMobile: isMobile),
        const SizedBox(height: 48),
        const _FloatingDemo(),
      ],
    );
  }

  Widget _buildLeftContent({required bool isMobile}) {
    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildBadge(),
        const SizedBox(height: 28),
        _buildHeadline(isMobile),
        const SizedBox(height: 22),
        _buildSubheadline(isMobile),
        const SizedBox(height: 36),
        _buildCtaButtons(isMobile),
        const SizedBox(height: 48),
        _buildStatsBadges(isMobile),
      ],
    );
  }

  Widget _buildGridPattern() {
    return Positioned.fill(
      child: CustomPaint(painter: _GridPainter()),
    );
  }

  Widget _buildGlowEffect() {
    return Positioned(
      top: -100,
      right: -100,
      child: Container(
        width: 500,
        height: 500,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.18),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        border:
            Border.all(color: AppColors.primary.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(100),
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Now available: Voice AI Agents with <500ms latency',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline(bool isMobile) {
    return _GradientHeadline(
      isMobile: isMobile,
    );
  }

  Widget _buildSubheadline(bool isMobile) {
    return Text(
      'From no-code builders for teams to flexible APIs for developers, deploy voice agents that actually sound human.',
      textAlign: isMobile ? TextAlign.center : TextAlign.left,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.62),
        fontSize: isMobile ? 15 : 17,
        height: 1.65,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildCtaButtons(bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment:
          isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        MagneticButton(
          child: _PrimaryCtaButton(
            label: 'Start for free',
            sublabel: '\$10 in free credits',
            onTap: () => Navigator.pushNamed(context, '/signup'),
          ),
        ),
        MagneticButton(
          child: _SecondaryCtaButton(
            label: 'Read the docs',
            icon: Icons.arrow_forward,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBadges(bool isMobile) {
    final stats = [
      {'value': '<500ms', 'label': 'Latency'},
      {'value': '99.99%', 'label': 'Uptime'},
      {'value': '150+', 'label': 'Countries'},
      {'value': '30+', 'label': 'Accents'},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment:
          isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: stats
          .map((s) => _StatBadge(value: s['value']!, label: s['label']!))
          .toList(),
    );
  }
}

// ─── Floating wrapper ─────────────────────────────────────────────────────

class _FloatingDemo extends StatefulWidget {
  const _FloatingDemo();

  @override
  State<_FloatingDemo> createState() => _FloatingDemoState();
}

class _FloatingDemoState extends State<_FloatingDemo>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
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
        animation: _anim,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, _anim.value),
          child: child,
        ),
        child: const VoiceAgentDemoWidget(),
      ),
    );
  }
}

// ─── Voice Agent Demo Widget ───────────────────────────────────────────────

class VoiceAgentDemoWidget extends StatefulWidget {
  const VoiceAgentDemoWidget({super.key});

  @override
  State<VoiceAgentDemoWidget> createState() => _VoiceAgentDemoWidgetState();
}

class _VoiceAgentDemoWidgetState extends State<VoiceAgentDemoWidget>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  int _seconds = 0;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  int _activePipeline = 0;
  Timer? _pipelineTimer;

  // Conversation ticker
  final List<_ConvTurn> _convTurns = [];
  Timer? _convTimer;
  final ScrollController _convScroll = ScrollController();
  int _convIndex = 0;

  static const int _totalDuration = 57;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pipelineTimer?.cancel();
    _convTimer?.cancel();
    _convScroll.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _convTurns.clear();
      _convIndex = 0;
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_seconds >= _totalDuration) {
          t.cancel();
          setState(() {
            _isPlaying = false;
            _seconds = 0;
          });
        } else {
          setState(() => _seconds++);
        }
      });
      _pipelineTimer = Timer.periodic(const Duration(milliseconds: 600), (_) {
        setState(() => _activePipeline = (_activePipeline + 1) % 3);
      });
      // Add a new conversation turn every 1.8 s
      _convTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
        if (!mounted) return;
        if (_convIndex < _kConvScript.length) {
          setState(() => _convTurns.add(_kConvScript[_convIndex++]));
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_convScroll.hasClients) {
              _convScroll.animateTo(
                _convScroll.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    } else {
      _timer?.cancel();
      _pipelineTimer?.cancel();
      _convTimer?.cancel();
    }
  }

  String get _timeDisplay {
    if (_seconds == 0 && !_isPlaying) return '—:—';
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAvailableOnBar(),
            _buildCallCard(),
            _buildScriptSection(),
            _buildBottomStats(),
            _buildPipelineBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailableOnBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      color: const Color(0xFFF8F9FA),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AVAILABLE ON',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(width: 8),
          _dot(),
          ...[' VOICE', ' SMS', ' WHATSAPP', ' CHAT'].map(
            (t) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Text(
                  t.trim(),
                  style: const TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot() => Container(
        width: 4,
        height: 4,
        decoration:
            const BoxDecoration(color: Color(0xFFD1D5DB), shape: BoxShape.circle),
      );

  Widget _buildCallCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          _buildStatusRow(),
          const SizedBox(height: 16),
          _buildPlayArea(),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _pulseAnim,
          builder: (_, _) => Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: _isPlaying
                  ? AppColors.primary.withValues(alpha: _pulseAnim.value)
                  : AppColors.success,
              shape: BoxShape.circle,
              boxShadow: _isPlaying
                  ? [
                      BoxShadow(
                        color: AppColors.primary
                            .withValues(alpha: _pulseAnim.value * 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _isPlaying ? 'playing' : 'ready',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '· sample call',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const Spacer(),
        Text(
          '$_timeDisplay / 00:57',
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            fontFamily: 'monospace',
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'ag_01HAZ7K',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 10,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _togglePlay,
            child: SizedBox(
              width: 72,
              height: 72,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_isPlaying) ...[
                    _PulseRing(delay: Duration.zero),
                    _PulseRing(delay: const Duration(milliseconds: 500)),
                    _PulseRing(delay: const Duration(milliseconds: 1000)),
                  ],
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'PLAY SAMPLE CALL',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      ' · 00:57',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'एक real voice agent dental appointment reschedule कर रहा है.',
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                _buildWaveformBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformBar() {
    final progress = _seconds / _totalDuration;
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 3,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(28, (i) {
            final barProgress = i / 27;
            final active = barProgress <= progress;
            final heights = [
              6.0, 14.0, 8.0, 18.0, 10.0, 22.0, 14.0, 18.0, 8.0,
              24.0, 16.0, 12.0, 20.0, 10.0, 18.0, 14.0, 22.0, 8.0,
              16.0, 20.0, 12.0, 18.0, 10.0, 22.0, 14.0, 8.0, 16.0, 10.0,
            ];
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: heights[i],
                  decoration: BoxDecoration(
                    color: active
                        ? AppColors.primary.withValues(alpha: 0.8)
                        : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildScriptSection() {
    final bool showTicker = _convTurns.isNotEmpty;
    return Container(
      height: showTicker ? 140 : null,
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: showTicker ? _buildTicker() : _buildStaticScript(),
    );
  }

  Widget _buildStaticScript() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chevron_right, size: 14, color: Color(0xFF9CA3AF)),
              Text(
                'SCRIPT',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inbound · customer Bright Smile Dental की appointment reschedule कर रहे हैं.',
                  style: TextStyle(color: Color(0xFF374151), fontSize: 13, height: 1.45),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildScriptChip('11 turns'),
                    const SizedBox(width: 6),
                    _buildScriptChip('4 tool calls'),
                    const SizedBox(width: 6),
                    _buildScriptChip('~57 sec'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicker() {
    return ListView.builder(
      controller: _convScroll,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _convTurns.length,
      itemBuilder: (_, i) {
        final turn = _convTurns[i];
        final isAgent = turn.speaker == 'Agent';
        final isNew = i == _convTurns.length - 1;
        return AnimatedSlide(
          offset: isNew ? const Offset(0, 0.3) : Offset.zero,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: AnimatedOpacity(
            opacity: isNew ? 1.0 : 0.72,
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      isAgent ? 'AI' : 'You',
                      style: TextStyle(
                        color: isAgent ? AppColors.primary : const Color(0xFF6B7280),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      turn.text,
                      style: TextStyle(
                        color: isAgent
                            ? const Color(0xFF111827)
                            : const Color(0xFF374151),
                        fontSize: 12,
                        height: 1.4,
                        fontWeight: isAgent ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildScriptChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFEA580C),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildBottomStats() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(child: _buildStat('LATENCY', '453ms', AppColors.primary)),
          _buildVerticalDivider(),
          Expanded(child: _buildStat('LANG', 'hi-IN', Colors.green)),
          _buildVerticalDivider(),
          Expanded(child: _buildStat('TOOL', 'idle', Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: const Color(0xFFE5E7EB),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildPipelineBar() {
    final stages = ['STT', 'LLM', 'TTS'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          ...stages.asMap().entries.expand((entry) {
            final i = entry.key;
            final label = entry.value;
            final isActive = _isPlaying && _activePipeline == i;
            return [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primary : const Color(0xFFD1D5DB),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? AppColors.primary
                          : Colors.grey[400],
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              if (i < stages.length - 1)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      children: List.generate(
                        6,
                        (j) => Expanded(
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200 + j * 50),
                            height: 1.5,
                            color: _isPlaying && _activePipeline == i
                                ? AppColors.primary.withValues(alpha: 0.4)
                                : const Color(0xFFE5E7EB),
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ];
          }),
        ],
      ),
    );
  }
}

// ─── Supporting widgets ────────────────────────────────────────────────────

class _PrimaryCtaButton extends StatefulWidget {
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _PrimaryCtaButton({
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  State<_PrimaryCtaButton> createState() => _PrimaryCtaButtonState();
}

class _PrimaryCtaButtonState extends State<_PrimaryCtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 13),
          decoration: BoxDecoration(
            gradient: _hovered
                ? const LinearGradient(
                    colors: [Color(0xFFFF8A50), Color(0xFFFFAD00)])
                : AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: _hovered ? 0.5 : 0.3),
                blurRadius: _hovered ? 24 : 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
              Text(widget.sublabel,
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 11,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryCtaButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryCtaButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_SecondaryCtaButton> createState() => _SecondaryCtaButtonState();
}

class _SecondaryCtaButtonState extends State<_SecondaryCtaButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.white.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white
                  .withValues(alpha: _hovered ? 0.3 : 0.15),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.label,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Icon(widget.icon, color: Colors.white, size: 17),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;

  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 1),
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 11,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}

// ─── Pulse Ring ───────────────────────────────────────────────────────────

class _PulseRing extends StatefulWidget {
  final Duration delay;
  const _PulseRing({required this.delay});

  @override
  State<_PulseRing> createState() => _PulseRingState();
}

class _PulseRingState extends State<_PulseRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.6, end: 1.6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.55, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, _) => Transform.scale(
        scale: _scale.value,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: _opacity.value),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Grid Painter ─────────────────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Gradient Headline ────────────────────────────────────────────────────

class _GradientHeadline extends StatefulWidget {
  final bool isMobile;
  const _GradientHeadline({required this.isMobile});

  @override
  State<_GradientHeadline> createState() => _GradientHeadlineState();
}

class _GradientHeadlineState extends State<_GradientHeadline>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _anim = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value + 1, 0),
          colors: const [
            Colors.white,
            Colors.white,
            AppColors.primary,
            Color(0xFFFFD580),
            Colors.white,
            Colors.white,
          ],
          stops: const [0.0, 0.3, 0.45, 0.55, 0.7, 1.0],
        ).createShader(bounds),
        child: child,
      ),
      child: TypewriterText(
        text: 'Build human-like\nvoice AI agents',
        textAlign:
            widget.isMobile ? TextAlign.center : TextAlign.left,
        startDelay: const Duration(milliseconds: 400),
        charDelay: const Duration(milliseconds: 38),
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.isMobile ? 34 : 54,
          fontWeight: FontWeight.w800,
          height: 1.1,
          letterSpacing: -2,
        ),
      ),
    );
  }
}

// ─── Bouncing Scroll Arrow ────────────────────────────────────────────────

class _BouncingArrow extends StatefulWidget {
  const _BouncingArrow();

  @override
  State<_BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<_BouncingArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, _) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white.withValues(alpha: 0.35),
          size: 28,
        ),
      ),
    );
  }
}

// ─── Conversation Ticker Data ─────────────────────────────────────────────

class _ConvTurn {
  final String speaker;
  final String text;
  const _ConvTurn(this.speaker, this.text);
}

const _kConvScript = [
  _ConvTurn('Agent', 'Hello! Thanks for calling Bright Smile Dental. How can I help?'),
  _ConvTurn('User', 'Hi, I need to reschedule my appointment.'),
  _ConvTurn('Agent', 'Of course! May I have your name and date of birth?'),
  _ConvTurn('User', 'Sarah Johnson, March 12th, 1985.'),
  _ConvTurn('Agent', 'Found it — Tuesday at 2 PM. What day works better for you?'),
  _ConvTurn('User', 'Thursday morning if possible?'),
  _ConvTurn('Agent', 'Thursday 10 AM is open. Shall I book that?'),
  _ConvTurn('User', 'Perfect, yes please!'),
  _ConvTurn('Agent', 'Done! Confirmed for Thursday at 10 AM. See you then!'),
];
