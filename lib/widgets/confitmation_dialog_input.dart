import 'package:flutter/material.dart';

Future<void> showDataInputDialog(BuildContext context, TextEditingController controller, VoidCallback onConfirm) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter Data'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your data',
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );
}
