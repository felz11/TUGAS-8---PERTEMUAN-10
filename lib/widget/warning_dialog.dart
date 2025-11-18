import 'package:flutter/material.dart';

class WarningDialog extends StatelessWidget {
  final String description;

  const WarningDialog({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(description),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
