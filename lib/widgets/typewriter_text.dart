import 'dart:async';
import 'package:flutter/material.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration charDelay;
  final Duration startDelay;
  final VoidCallback? onDone;

  const TypewriterText({
    super.key,
    required this.text,
    required this.style,
    this.textAlign = TextAlign.left,
    this.charDelay = const Duration(milliseconds: 42),
    this.startDelay = const Duration(milliseconds: 600),
    this.onDone,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  String _displayed = '';
  int _index = 0;
  Timer? _charTimer;
  Timer? _startTimer;
  late AnimationController _cursorCtrl;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _cursorCtrl = AnimationController(
      duration: const Duration(milliseconds: 520),
      vsync: this,
    )..repeat(reverse: true);

    _startTimer = Timer(widget.startDelay, _startTyping);
  }

  void _startTyping() {
    _charTimer = Timer.periodic(widget.charDelay, (t) {
      if (!mounted) { t.cancel(); return; }
      if (_index >= widget.text.length) {
        t.cancel();
        // keep cursor blinking for 1.5s then hide
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) setState(() => _done = true);
          widget.onDone?.call();
        });
        return;
      }
      setState(() => _displayed = widget.text.substring(0, ++_index));
    });
  }

  @override
  void dispose() {
    _charTimer?.cancel();
    _startTimer?.cancel();
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cursorCtrl,
      builder: (_, _) {
        final cursor = (!_done && _cursorCtrl.value > 0.5) ? '▋' : '';
        return Text(
          '$_displayed$cursor',
          style: widget.style,
          textAlign: widget.textAlign,
        );
      },
    );
  }
}
