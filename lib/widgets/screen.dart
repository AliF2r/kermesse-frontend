import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const Screen({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
