
import 'package:evcharging/Screens/navigation.dart';
import 'package:evcharging/Screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:evcharging/components/my_tf.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key,});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    final _username = usernameController.text;
    final _password = passwordController.text;

    if (_username.isEmpty || _password.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(20),
          content: Text('Please enter your login details'),
        ),
      );
    } else {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _username,
          password: _password,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomTabBar()),
        );
      } catch (e) {
        String errorMessage = '$e';
        if (e is FirebaseAuthException) {
          if (e.code == 'user-not-found') {
            errorMessage = '$e';
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red[700],
                  duration: Duration(seconds: 3),
                  margin: EdgeInsets.all(20),
                  content: Text('user-not-found'),
                ),
            );
          }
          else if (e.code == 'wrong-password') {
            errorMessage = '$e';
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red[700],
                duration: Duration(seconds: 3),
                margin: EdgeInsets.all(20),
                content: Text('wrong-password'),
              ),
            );
          }
        else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red[700],
                duration: Duration(seconds: 3),
                margin: EdgeInsets.all(20),
                content: Text("error"),
              ),

            );
          }
        }
        passwordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(0, 90, 0, 0),
                alignment: Alignment.center,
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.inter().fontFamily,
                    fontSize: 35,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              MF(
                hintText: 'username',
                controller: usernameController,
                obscureText: false,
                keyboardtype: TextInputType.emailAddress,
                decoration:InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email_sharp,color: HexColor("#58B15C")),
                ),
              ),
              SizedBox(height: 5),
              MF(
                hintText: 'password',
                controller: passwordController,
                obscureText: true,
                keyboardtype: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline,color: HexColor("#58B15C")),
                    suffixIcon: IconButton(onPressed: () {} , icon: Icon(Icons.remove_red_eye_sharp),)
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {},
                      child: Text('Forgot Password?   ',
                          style:TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black)))),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(onPressed: () {
                  signUserIn(context);
                  } ,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(HexColor('#18731B').value)),
                      fixedSize: MaterialStateProperty.all<Size>(Size(280, 45)),
                    ),
                    child: Text('Login',style:TextStyle(color: Colors.white,fontSize: 18,fontFamily: GoogleFonts.inter().fontFamily))),
              ),
              SizedBox(height: 30),
              Align(
                  alignment: Alignment.center,
                  child: Text('Or Sign in With',
                      style:TextStyle(fontSize: 16,fontWeight: FontWeight.normal,color: Colors.black))),
              SizedBox(height: 30,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                        width:140,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0,3),
                              )]
                        ),
                        child: TextButton(onPressed: () {  },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            child:
                            Row(
                              children: [
                                Expanded(flex:1,child: Image.asset('assets/images/google-g-2015-logo-svgrepo-com.png')),
                                Expanded(flex:1,child: Text('google',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),))
                              ],
                            )
                        )
                    ),
                    SizedBox(width: 30,),
                    Container(
                        width:140,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: Offset(0,3),
                              )]
                        ),
                        child: TextButton(onPressed: () {  },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                            ),
                            child:
                            Row(
                              children: [
                                Expanded(flex:1,child: Image.asset('assets/images/pngwing.com.png')),
                                Expanded(flex:2,child: Text('facebook',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black54),))
                              ],
                            )
                        )
                    ),
                  ]
              ),
              SizedBox(height: 70,width: 200,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Don't have an Account?"),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup()),
                      );
                    },
                        child: Text("Sign Up",style: TextStyle(color: HexColor('#18731B'),fontWeight: FontWeight.bold ),)
                    ),
                  ]
              ),
            ],
          ),
        ),
      ),
    );
  }

    }
