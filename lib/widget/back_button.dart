import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  final double scale;
  const BackButtonWidget({super.key, required this.scale});
  // 뒤로 가기 버튼
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: GestureDetector(
        //pop=뒤로 가기
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: 50 * scale,
          height: 50 * scale,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3 * scale),
                blurRadius: 4 * scale,
              ),
            ],
          ),
          child: Icon(Icons.arrow_back, color: Colors.black, size: 30 * scale),
        ),
      ),
    );
  }
}
