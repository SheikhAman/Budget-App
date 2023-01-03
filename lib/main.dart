import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'responsive_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    setPathUrlStrategy();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyB2SQnPCkOJi-2nR-JCYH-0_N2FPk09WAE",
            authDomain: "budget-app-3a037.firebaseapp.com",
            projectId: "budget-app-3a037",
            storageBucket: "budget-app-3a037.appspot.com",
            messagingSenderId: "285943362484",
            appId: "1:285943362484:web:ba7695adb79064e138f8e1",
            measurementId: "G-545N7X1S91"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(
    ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget App',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(useMaterial3: true),
      home: ResponsiveHandler(),
    );
  }
}
