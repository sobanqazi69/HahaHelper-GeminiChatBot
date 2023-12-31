// ignore_for_file: prefer_const_constructors, camel_case_types



import 'package:flutter/material.dart';
import 'package:gemini/geminiwithimage.dart';
import 'package:gemini/geminiwithoutimage.dart';


const apiKey = "AIzaSyA2rK-LH_m_1v0x_zU8bIbPxWeywLznHSk";

class geminichat extends StatefulWidget {
  const geminichat({super.key});

  @override
  State<geminichat> createState() => _geminichatState();
}

class _geminichatState extends State<geminichat> {
  final List<Widget> _pages = [
    withimage(),
        withoutimage(),

  ];

  int _currentIndex = 0;
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepOrange,
        title: const Text('Haha Helper',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700 , color: Colors.black)),
      ),
      body:  _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepOrange,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'With Image',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Text',
          ),
        ],
      ),
    );
  }
}
