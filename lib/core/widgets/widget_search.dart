import 'package:flutter/material.dart';

class WidgetSearch extends StatelessWidget {
  const WidgetSearch({super.key});
  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Center(child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          border:Border.all(
            width: 2,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.search,),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Tìm kiếm ...",
                  border: InputBorder.none,
                  
                ),
              )
              
            ),
          ],
        ),
      ),
      ),
    );
  }
}
