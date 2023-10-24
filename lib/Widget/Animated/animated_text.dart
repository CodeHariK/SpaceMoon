import 'package:flutter/material.dart';

class AnimatedText extends StatelessWidget {
  const AnimatedText({
    super.key,
    required this.text1,
    required this.text2,
    this.duration = const Duration(milliseconds: 300),
    required this.show,
    this.style,
  });

  final String text1, text2;
  final Duration duration;
  final bool show;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: Text(text1, style: style),
      secondChild: Text(text2, style: style),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}
