import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weartherproject/main.dart';
import 'package:weartherproject/services/auth.dart';
import 'package:weartherproject/services/store.dart';
import 'package:weartherproject/pages/home_page.dart';
import 'package:weartherproject/pages/login/signin.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  final AuthService _auth = AuthService();
  final FireStoreService _fireStore = FireStoreService();

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _hometownController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMsg;
  bool obscurePassword = true;
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_slash_fill;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

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
                          'Sign up to start',
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
                            // phone number
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: TextFormField(
                                controller: _phoneNumberController,
                                decoration: InputDecoration(
                                  hintText: 'Số điện thoại',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(
                                    CupertinoIcons.device_phone_portrait,
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
                                    return 'Vui lòng nhập số điện thoại';
                                  } else if (!RegExp(r'^[0-9]{10}$')
                                      .hasMatch(val)) {
                                    return 'Định dạng số điện thoại không chính xác';
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
                                onChanged: (val) {
                                  if (val!.contains(RegExp(r'[A-Z]'))) {
                                    setState(() {
                                      containsUpperCase = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsUpperCase = false;
                                    });
                                  }
                                  if (val.contains(RegExp(r'[a-z]'))) {
                                    setState(() {
                                      containsLowerCase = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsLowerCase = false;
                                    });
                                  }
                                  if (val.contains(RegExp(r'[0-9]'))) {
                                    setState(() {
                                      containsNumber = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsNumber = false;
                                    });
                                  }
                                  if (val.contains(RegExp(
                                      r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                                    setState(() {
                                      containsSpecialChar = true;
                                    });
                                  } else {
                                    setState(() {
                                      containsSpecialChar = false;
                                    });
                                  }
                                  if (val.length >= 8) {
                                    setState(() {
                                      contains8Length = true;
                                    });
                                  } else {
                                    setState(() {
                                      contains8Length = false;
                                    });
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                enabled: false,
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
                                keyboardType: TextInputType.visiblePassword,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Vui lòng nhập mật khẩu';
                                  } else if (!RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                                      .hasMatch(val)) {
                                    return 'Định dạng mật khẩu sai';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  Có 1 chữ in hoa",
                                      style: TextStyle(
                                          color: containsUpperCase
                                              ? Colors.green
                                              : Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    Text(
                                      "⚈  Có 1 chữ in thường",
                                      style: TextStyle(
                                          color: containsLowerCase
                                              ? Colors.green
                                              : Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    Text(
                                      "⚈  Có 1 số",
                                      style: TextStyle(
                                          color: containsNumber
                                              ? Colors.green
                                              : Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "⚈  Có 1 ký tự đặc biệt",
                                      style: TextStyle(
                                          color: containsSpecialChar
                                              ? Colors.green
                                              : Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                    Text(
                                      "⚈  Tối thiếu 8 ký tự",
                                      style: TextStyle(
                                          color: contains8Length
                                              ? Colors.green
                                              : Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    ),
                                  ],
                                ),
                              ],
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
                                  String email = _emailController.text;
                                  String phone = _phoneNumberController.text.trim();
                                  QuerySnapshot? query = await _fireStore.getData("User", "email", email);
                                  if(query!.docs.isNotEmpty){
                                    QuerySnapshot? queryIdAccount = await _fireStore.getData("Account", "account", email);
                                    String? id = queryIdAccount?.docs.first.id;
                                    String pass = _passwordController.text;
                                    String oldphone = query?.docs.first["phone_Number"];
                                    print(oldphone);
                                    if(phone == oldphone){
                                      _passwordController.text = queryIdAccount!.docs.first["password"];
                                      _emailController.clear();
                                      _phoneNumberController.clear();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Lấy lại mật khẩu thành công")));
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "sai số điện thoại")));
                                    }
                                  }
                                  else{
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Email sai")));
                                  }
                                },
                                child: Text('Mật khẩu'),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Text(
                                    'Bạn đã có tài khoản?',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignIn()));
                                    },
                                    child: Text(
                                      'Đăng nhập',
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
