//classes_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 900;

    return Scaffold(
      appBar: const BlogNavBar(activeMenu: "Classes"),
      drawer: const MobileDrawer(activeMenu: '',), 
      body: Row(
        children: [
          if (!isMobile)
            Container(
              width: 250,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey[200]!)),
                color: Colors.white,
              ),
              child: ListView(
                children: const [
                  ListTile(leading: Icon(Icons.book), title: Text("1. Introduction")),
                  ListTile(leading: Icon(Icons.book), title: Text("2. Overview")),
                ],
              ),
            ),
          const Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Python Class", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("Scroll down to see the header stay fixed..."),
                  SizedBox(height: 1000), 
                  Text("End of content."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}