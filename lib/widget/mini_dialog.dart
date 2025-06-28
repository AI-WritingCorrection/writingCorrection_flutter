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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      backgroundColor: Colors.white,
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.green,
            fontFamily: 'Pretendard',
            fontSize: 20 * scale,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Text(
        content,

        style: TextStyle(
          color: Colors.black87,
          fontFamily: 'Pretendard',
          fontSize: 15 * scale,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16 * scale),
          ),
          child: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '확인',
              style: TextStyle(
                color: Colors.red.shade400,
                fontFamily: 'Pretendard',
                fontSize: 13 * scale,
                fontWeight: FontWeight.bold,
              ),
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
