import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:weartherproject/cubits/temp_settings/temp_settings_cubit.dart';
import 'package:weartherproject/services/auth.dart';
import 'package:weartherproject/services/store.dart';
import 'package:weartherproject/pages/login/signin.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthService _auth = AuthService();
  FireStoreService _service = FireStoreService();
  GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            child: ListTile(
              title: const Text('Đơn vị nhiệt độ'),
              subtitle: const Text('Độ C/Độ F (Mặc định: Độ C)'),
              trailing: Switch(
                value: context.watch<TempSettingsCubit>().state.tempUnit ==
                    TempUnit.celsius,
                onChanged: (_) {
                  context.read<TempSettingsCubit>().toggleTempUnit();
                },
              ),
            ),
          ),
          Padding(
            padding: const  EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
            ),
            child: ListTile(
              trailing: Icon(Icons.exit_to_app),
              title: const Text('Thoát'),
              onTap: () async {
                await _auth.signOut();
                _googleSignIn.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn(),));
              },
            ),
          ),
        ],
      ),
    );
  }
}
