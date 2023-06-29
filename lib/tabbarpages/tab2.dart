import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Tab2 extends StatelessWidget {
  const Tab2({super.key});

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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child:Stack(
                  children: [
                    Positioned(
                      left: 30,
                      top: 40,
                      child: Text('Booked Slots',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('View Details',style: TextStyle(color:HexColor('#18731B')),)
                           ),
                        ),
                      ),
                    )
                  ],
                ) 
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child:Stack(
                  children: [
                    Positioned(
                      left: 30,
                      top: 40,
                      child: Text('Booked Slots',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('View Details',style: TextStyle(color:HexColor('#18731B')),)
                           ),
                        ),
                      ),
                    )
                  ],
                ) 
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10)
                ),
                child:Stack(
                  children: [
                    Positioned(
                      left: 30,
                      top: 40,
                      child: Text('Booked Slots',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('View Details',style: TextStyle(color:HexColor('#18731B')),)
                           ),
                        ),
                      ),
                    )
                  ],
                ) 
                
              ),
            ),
          ],
        ),
      ),
    );
  }



}