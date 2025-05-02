import 'package:flutter/material.dart';

class WaitdevelopDialog extends StatelessWidget {
  final double scale;
  const WaitdevelopDialog({super.key, required this.scale});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('개발 진행중'),
      content: Text(
        '해당 기능은 개발중이니 조금만 기다려주세요!',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 20 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            '확인',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16 * scale,
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
