import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weartherproject/main.dart';
import 'package:weartherproject/services/auth.dart';
import 'package:weartherproject/services/store.dart';
import 'package:weartherproject/pages/home_page.dart';
import 'package:weartherproject/pages/login/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with TickerProviderStateMixin {
  final AuthService _auth = new AuthService();
  final FireStoreService _fireStore = FireStoreService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;

  Future<String?> signInWithGoogle() async{
    GoogleSignInAccount? googleUSer = await GoogleSignIn().signIn();
    String? email = googleUSer?.email;
    GoogleSignInAuthentication? googleAuth = await googleUSer?.authentication;

    AuthCredential credential =  GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: AlignmentDirectional(20, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(-2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.pinkAccent,
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional(2.7, -1.2),
                child: Container(
                  height: MediaQuery.of(context).size.width / 1.3,
                  width: MediaQuery.of(context).size.width / 1.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
                child: Container(),
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Image(
                            image: AssetImage('assets/icons/weatherlogo.png')),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Welcome to the weather service',
                          style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            // email design & setup
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(
                                    CupertinoIcons.mail_solid,
                                    color: Colors.grey,
                                  ),
                                  error: _errorMsg != null
                                      ? Text(_errorMsg!)
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.pinkAccent),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Vui lòng nhập email';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
                                      .hasMatch(val)) {
                                    return 'Định dạng email không chính xác';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            // password design & setup
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        obscurePassword = !obscurePassword;
                                        if (obscurePassword) {
                                          iconPassword =
                                              CupertinoIcons.eye_fill;
                                        } else {
                                          iconPassword =
                                              CupertinoIcons.eye_slash_fill;
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      iconPassword,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  hintText: 'Mật khẩu',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(
                                    CupertinoIcons.lock_fill,
                                    color: Colors.grey,
                                  ),
                                  error: _errorMsg != null
                                      ? Text(_errorMsg!)
                                      : null,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        BorderSide(color: Colors.pinkAccent),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white70,
                                ),
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  } else if (!RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                      .hasMatch(val)) {
                                    return 'Định dạng mật khẩu không chính xác';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            // forget password
                            const SizedBox(height: 10),
                            SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      'Quên mật khẩu',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.grey),
                                    ),
                                    onTap: () {
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            // sign in design & setup
                            SizedBox(
                              width: 200,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color.fromRGBO(253, 101, 145, 1),
                                  onPrimary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                                onPressed: () async {
                                  if(_emailController.text == ""){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập email")));
                                  }
                                  else if(_passwordController.text == ""){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập mật khẩu")));
                                  }
                                  else{
                                    User? user = await _auth.loginUserWithEmailAndPassword(_emailController.text, _passwordController.text);
                                    if(user != null){
                                      String email = _emailController.text;
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng nhập thành công")));
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(
                                        builder: (context) => MyApp(),));
                                      _emailController.clear();
                                      _passwordController.clear();
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đăng nhập không thành công")));
                                    }
                                  }
                                },
                                child: Text('Sign In'),
                              ),
                            ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 1,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    'hoặc đăng nhập bằng',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.pinkAccent),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 1,
                                    color: Colors.pinkAccent,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    String? email = await signInWithGoogle();
                                    QuerySnapshot? query = await _fireStore.getData("Account", "account", email);
                                    if(query?.docs.length == 0){
                                      _fireStore.addData({
                                        'account' : email,
                                        'password' : "",
                                      }, 'Account');

                                    }
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(
                                      builder: (context) => MyApp(),));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white, // Màu nền của nút
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Định dạng viền của nút
                                    ),
                                  ),
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/icons/google.png'),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        // Khoảng cách giữa hình ảnh và văn bản
                                        Text(
                                          'Đăng nhập bằng Google',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white, // Màu nền của nút
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    width: 300,
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(
                                              'assets/icons/facebook.png'),
                                        ),
                                        SizedBox(width: 10),
                                        // Khoảng cách giữa hình ảnh và văn bản
                                        Text(
                                          'Đăng nhập bằng Facebook',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'Bạn chưa có tài khoản?',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      'Đăng ký',
                                      style: TextStyle(
                                          color: Colors.pinkAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
