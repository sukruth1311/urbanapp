import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:urban_gardening/Chat/chat.dart';
import 'package:urban_gardening/Chat/consts.dart';
import 'package:urban_gardening/HomePage.dart';
import 'package:urban_gardening/addplant.dart';
import 'package:urban_gardening/authentication/Auth.dart';
import 'package:urban_gardening/community.dart';
import 'package:urban_gardening/firebase_options.dart';
import 'package:urban_gardening/Recommendations/plantrec.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(
    apiKey: GEMINI_API_KEY,
  
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home:AuthPage()
    );
  }
}
