import 'package:flutter/material.dart';

class ScreenList extends StatefulWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const ScreenList({
    super.key,
    required this.child,
    this.appBar,
  });

  @override
  State<ScreenList> createState() => _ScreenListState();
}

class _ScreenListState extends State<ScreenList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
