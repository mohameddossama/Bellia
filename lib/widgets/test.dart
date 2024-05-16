import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  const appBar({super.key, required this.pageName});
  final String pageName;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15),
      height: 200,
      //width: 200,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(color: Colors.black, Icons.arrow_back),
            ),
          ],
        ),
        Divider(
          color: Colors.black,
          thickness: 1.0,
        ),
        Center(
          child: Text(
            pageName,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: 
          Container(
            width: 300,
            height: 40,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 201, 201),
              borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Icon(Icons.search_rounded),
                Text("Search...",style: TextStyle(fontWeight: FontWeight.w300),)
              ],)
          ),
        ),
      ]),
    );
  }
}
