// ignore_for_file: camel_case_types, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gemini/chatscreen.dart';
import 'package:get/route_manager.dart';
import 'package:lottie/lottie.dart';


class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

@override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 3), () {Get.to(()=>geminichat()); });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(body: Center(child: Lottie.asset('assets/splash.json'),),);
  }
}