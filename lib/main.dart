import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:studychinesetoday/sections/home_page/home_page_2.dart';
import 'configs/app_theme.dart';
import 'sections/home_page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  const firebaseOptions = FirebaseOptions(
      apiKey: "AIzaSyA9KHSBDB5GjNU33hwle4vFXw_00soMpaA",
      authDomain: "studychinesetoday-7b129.firebaseapp.com",
      projectId: "studychinesetoday-7b129",
      storageBucket: "studychinesetoday-7b129.appspot.com",
      messagingSenderId: "526387177583",
      appId: "1:526387177583:web:6a406217101828b16a459a",
      measurementId: "G-FP8PC242MC");

  await Firebase.initializeApp(
    name: 'studychinesetoday',
    options: firebaseOptions,
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);


  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomePage2(),
    );
  }
}
