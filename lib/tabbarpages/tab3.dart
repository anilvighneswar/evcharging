import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Tab3 extends StatelessWidget {
  const Tab3({super.key});

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
                      child: Text('History',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('Rebook Slot',style: TextStyle(color:HexColor('#18731B')),)
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
                      child: Text('History',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('Rebook Slot',style: TextStyle(color:HexColor('#18731B')),)
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
                      child: Text('History',style: TextStyle(color: Colors.black87),)),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: OutlinedButton(onPressed: (){},
                          style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                          ,side:  BorderSide(color:HexColor('#18731B'),width: 2 )),
                          child: Text('Rebook Slot',style: TextStyle(color:HexColor('#18731B')),)
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