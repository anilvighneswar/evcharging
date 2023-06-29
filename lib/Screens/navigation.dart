import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import './home.dart';
import './login.dart';
import './bookings.dart';
import './profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({Key? key});

  @override
  State<BottomTabBar> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _index = 0;
  final screens = [
    HomeScreen(),
    BookingScreen(),
    ProfileScreen(),
  ];

  void signUserOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: Container(
        height: 98,
        color: Colors.white,
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:Row(
          children: [
              Expanded(
                flex: 3,
                child: GNav(
                  haptic: true,
                  tabActiveBorder: Border.all(color: HexColor('#18731B'), width: 2),
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 700),
                  color: Colors.black,
                  activeColor: HexColor('#18731B'),
                  gap: 2,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                  tabs: [
                    GButton(
                      icon: Icons.home_rounded,
                      text: 'Home',
                    ),
                    GButton(
                      icon: Icons.bookmark_outline_rounded,
                      text: 'Bookings',
                    ),
                    GButton(
                      icon: Icons.person_outline_rounded,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _index,
                  onTabChange: (index) {
                    setState(() {
                      _index = index;
                    });
                  },
                ),
              ),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(35,0,20,0),
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Sign Out'),
                          content: Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                // Close the dialog
                                Navigator.pop(context);

                                // Perform the sign-out action
                                signUserOut();
                              },
                              child: Text('Yes'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Close the dialog
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                          ],
                        );
                      },
                    );
                  }, icon: Icon(Icons.logout_rounded,color: Colors.red[800],),
                ),
              ),
            ),
          ],
        ),
    ),
      ),
    );
  }


}
