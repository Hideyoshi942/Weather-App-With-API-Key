import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weartherproject/services/auth.dart';
import 'package:weartherproject/view/screens/login/signin.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(
            child: Icon(Icons.close),
            onTap: () async {
              await _auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
            },
          )
        ],
      ),
    );
  }
}
