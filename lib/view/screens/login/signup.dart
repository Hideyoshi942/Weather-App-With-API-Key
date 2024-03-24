import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weartherproject/services/auth.dart';
import 'package:weartherproject/services/store.dart';
import 'package:weartherproject/view/screens/home/myhomepage.dart';
import 'package:weartherproject/view/screens/login/signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
                            // fullname design & setup
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.77,
                              child: TextFormField(
                                controller: _fullnameController,
                                decoration: InputDecoration(
                                  hintText: 'Họ tên',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  prefixIcon: const Icon(
                                    CupertinoIcons.person_fill,
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
                                    return 'Vui lòng nhập tên';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                  User? user = await _auth
                                      .registerUserWithEmailAndPassword(
                                          _emailController.text,
                                          _passwordController.text);
                                  if (user != null) {
                                    _fireStore.addData({
                                      'account': email,
                                      'password': _passwordController.text,
                                    }, 'Account');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Đăng ký thành công")));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyHomePage(),
                                      ),
                                    );
                                    Map<String, dynamic> data = {
                                      'name': _fullnameController.text,
                                      'date': DateFormat('yyyy/MM/dd')
                                          .format(DateTime.now()),
                                      'gender': _genderController.text,
                                      'address': _hometownController.text,
                                      'email': email,
                                      'phone_Number': _phoneNumberController.text,
                                    };
                                    _fireStore.addData(data, "User");
                                    _emailController.clear();
                                    _passwordController.clear();
                                    _fullnameController.clear();
                                    _phoneNumberController.clear();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Đăng ký không thành công")));
                                  }
                                },
                                child: Text('Đăng ký'),
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
