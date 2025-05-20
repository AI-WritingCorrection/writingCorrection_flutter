import 'package:flutter/material.dart';

class MiniDialog extends StatelessWidget {
  final double scale;
  final String title;
  final String content;
  const MiniDialog({
    super.key,
    required this.scale,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        content,

        style: TextStyle(
          color: Colors.black87,
          fontSize: 15 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            '확인',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 10 * scale,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
