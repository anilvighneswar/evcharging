import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String mail='';
  String pno='';
  String userName = '';
  @override
  void initState() {
    super.initState();
    loadUserName();
  }
  Future<void> loadUserName() async {
    try {
      // Check if the user is authenticated
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data();
        if (data != null && data.containsKey('name') && data.containsKey('email')) {
          setState(() {
            userName = data['name'];
            mail = data['email'];
          });
        }

        else {
          setState(() {
            userName = '';
          });
        }
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: GoogleFonts.inter().fontFamily)),
        backgroundColor: HexColor('#18731B'),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {

          },
        ),
      ),
      body:
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePicture(
              name: '$userName',
              radius: 50,
              fontsize: 25,
              tooltip: false,
              random: true,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: Text('$userName',style:TextStyle(color: Colors.black54,fontSize: 22,fontFamily: GoogleFonts.raleway().fontFamily,fontWeight: FontWeight.bold))),
                  Center(child:Text('$mail',style:TextStyle(color: Colors.black54,fontSize: 16,fontFamily: GoogleFonts.robotoCondensed().fontFamily))),
                  SizedBox(height: 30,),
                  buildTextBar('My Profile', Icons.person),
                  SizedBox(height: 30),
                  buildTextBar('Saved Chargers', Icons.charging_station_rounded),
                  SizedBox(height: 30),
                  buildTextBar('Settings', Icons.settings),
                ],
              ),
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

  Widget buildTextBar(String text, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon,color: HexColor('#18731B'),),
          SizedBox(width: 16),
          Expanded(child: Text(text,style:TextStyle(color: Colors.black,fontSize: 18,fontFamily: GoogleFonts.inter().fontFamily))),
          Icon(Icons.arrow_forward,color: HexColor('#18731B'),),
        ],
      ),
    );
  }
}

