import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String? value;
  final String? hint;
  final TextEditingController controller;

  const TextInput({
    super.key,
    this.value,
    this.hint,
    required this.controller,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    if (widget.value != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.value!;
    }

    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hint ?? '',
      ),
    );
  }
}
