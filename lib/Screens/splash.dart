import 'package:evcharging/Screens/auth.dart';
import 'package:evcharging/Screens/login.dart';
import 'package:flutter/material.dart';
import './navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:hexcolor/hexcolor.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          height: height,
          width: width,
          color: HexColor('#18731B'),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'EV',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Charger',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Container(
              alignment: Alignment.bottomCenter,
              child: Lottie.asset(
                  'assets/animations/31048-electric-car-charging.json',
                  height: 120),
            ),
          ),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> gotoLogin() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return AuthPage();
    }));
  }
}
