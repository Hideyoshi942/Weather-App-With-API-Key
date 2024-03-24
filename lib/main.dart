import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:weartherproject/view/screens/home/myhomepage.dart';
import 'package:weartherproject/view/screens/login/signin.dart';
import 'package:weartherproject/view/screens/login/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: 'AIzaSyBMBOw3A99aDdRoYaq5x6fNawFwSEqrxiM',
              appId: '1:208938739384:android:87975b3225c13fc9f1764d',
              messagingSenderId: '208938739384', //project_number
              projectId: 'weatherproject-4cb43' //project_id
              ))
      : await Firebase.initializeApp();
  runApp(MaterialApp(
    home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyHomePage();
        } else {
          return SignIn();
        }
      },
    ),
    debugShowCheckedModeBanner: false,
  ));
}

