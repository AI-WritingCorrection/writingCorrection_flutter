import 'package:flutter/material.dart';

class Bottom extends StatelessWidget {
  const Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    var newHeight=MediaQuery.of(context).size.height * 0.08;    
    return Container(
      height: newHeight,
      color: const Color(0xFFCEEF91),
      child: SizedBox(
        height: 50,
        child: TabBar(
          labelColor: const Color.fromARGB(221, 241, 105, 14),
            unselectedLabelColor: Colors.black54,
          indicatorColor: Colors.transparent,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.home, size: newHeight*0.41),
              child: Text('홈', style: TextStyle(fontSize: newHeight*0.17, color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            Tab(
                icon: Icon(Icons.school, size: newHeight*0.41),
              child: Text('자유 공부', style: TextStyle(fontSize: newHeight*0.17, color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            Tab(
                icon: Icon(Icons.history, size: newHeight*0.41),
              child: Text('기록', style: TextStyle(fontSize: newHeight*0.17, color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
            Tab(
                icon: Icon(Icons.person, size: newHeight*0.41),
              child: Text('마이 페이지', style: TextStyle(fontSize: newHeight*0.17, color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
