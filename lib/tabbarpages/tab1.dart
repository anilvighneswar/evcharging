import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Tab1 extends StatelessWidget {
  const Tab1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: HexColor('#BEE5BE'),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Ongoing Charging',style: TextStyle(color: Colors.black87),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: HexColor('#BEE5BE'),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Ongoing Charging',style: TextStyle(color: Colors.black87),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: HexColor('#BEE5BE'),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Ongoing Charging',style: TextStyle(color: Colors.black87),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}