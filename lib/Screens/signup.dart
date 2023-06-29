
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:evcharging/components/my_tf.dart';
import 'login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Signup extends StatefulWidget{
  const Signup({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Signup();
}

class _Signup extends State<Signup>{
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final mnoController = TextEditingController();
  final pwordController = TextEditingController();
  bool acceptedTerms = false;

  Future<void> signUpUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: mailController.text,
        password: pwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        final newUser = {
          'name': nameController.text,
          'email': mailController.text,
          'phone': mnoController.text,
        };

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            newUser);

        // Show a success snackbar
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: HexColor('#18731B'),
            duration: Duration(seconds: 2),
            margin: EdgeInsets.all(20),
            content: Text('Sign up successful. Please login again.'),
          ),
        );

        // Clear the text fields
        nameController.clear();
        mailController.clear();
        mnoController.clear();
        pwordController.clear();
        setState(() {
          acceptedTerms = false;
        });

        // Redirect to the login page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }catch (error) {
      // Show an error snackbar
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(20),
          content: Text("Couldn't sign up, please try again later."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:100),
              Center(
                child: Text('Sign Up',style:TextStyle(fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.black,
                  letterSpacing: 1,)),
              ),
              SizedBox(height:30),
              Center(
                child: Text('Enter details to sign up your account',style:TextStyle(fontFamily: GoogleFonts.inter().fontFamily,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black,)),
              ),
              MF(hintText: 'Full Name',
                obscureText: false,
                controller: nameController,
                keyboardtype: TextInputType.name,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_outline_rounded,color: HexColor('#58B15C'),)
                ),
              ),
              MF(hintText: 'Email',
                obscureText: false,
                keyboardtype: TextInputType.emailAddress,
                controller: mailController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mail_outline_rounded,color: HexColor('#58B15C'),)
                ),
              ),
              MF(hintText: 'Phone Number',
                obscureText: false,
                keyboardtype: TextInputType.phone,
                controller: mnoController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone,color: HexColor('#58B15C'),)
                ),
              ),
              MF(hintText: 'Password',
                obscureText: true,
                keyboardtype: TextInputType.emailAddress,
                controller: pwordController,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline_rounded,color: HexColor('#58B15C'),),
                    suffixIcon: IconButton(icon: Icon(Icons.remove_red_eye_outlined),
                    onPressed:() {})/*Icon(Icons.remove_red_eye_outlined)*/
                ),
              ),
              Row(
                children: [
                  Checkbox(value: acceptedTerms, onChanged: (value) {
                    setState(() {
                      acceptedTerms= value!;
                    });
                  },
                  ),
                  Text('I agreee to '),
                  Text('T&C.',style: TextStyle(fontFamily: GoogleFonts.inter().fontFamily,color: HexColor('#58B15C'),fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(onPressed: () {
                  if (acceptedTerms) {
                    signUpUser();
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                        margin: EdgeInsets.all(20),
                        content: Text('please accept T&C')));
                  }
                },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Color(HexColor('#18731B').value)),
                      fixedSize: MaterialStateProperty.all<Size>(Size(280, 45)),
                    ),
                    child: Text('Sign Up',style:TextStyle(color: Colors.white,fontSize: 18,fontFamily: GoogleFonts.inter().fontFamily))),
              ),
              SizedBox(height: 70,width: 200,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Already have an account?"),
                    TextButton(onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                        child: Text("Login",style: TextStyle(color: HexColor('#18731B'),fontWeight: FontWeight.bold ),)
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
