import 'package:flutter/material.dart';

@immutable
class AnimatedYHide extends StatelessWidget {
  const AnimatedYHide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    required this.show,
  });

  final Widget child;
  final Duration duration;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox(width: double.infinity),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
    );
  }
}
