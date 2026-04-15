import 'package:flutter/material.dart';

class ShellPage extends StatelessWidget {
  const ShellPage({super.key, required this.child, this.maxWidth = 1120});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 980;
    final padding = EdgeInsets.fromLTRB(24, isDesktop ? 86 : 16, 24, 24);
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: child,
        ),
      ),
    );
  }
}

