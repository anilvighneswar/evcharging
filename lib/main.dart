import 'package:evcharging/Screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './Screens/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  
  
  runApp( ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:'mini pro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:ScreenSplash(),
    );
  }
}