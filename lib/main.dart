import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weartherproject/cubits/weather/weather_cubit.dart';
import 'package:weartherproject/repositories/weather_repository.dart';
import 'package:weartherproject/services/weather_api_services.dart';
import 'package:weartherproject/pages/home_page.dart';
import 'package:weartherproject/pages/login/signin.dart';
import 'package:http/http.dart' as http;
import 'package:weartherproject/cubits/temp_settings/temp_settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
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
          String? email = snapshot.data?.email;
          return MyApp(email!);
        } else {
          return SignIn();
        }
      },
    ),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  String _email;

  MyApp(this._email);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiServices(httpClient: http.Client())),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
          BlocProvider<TempSettingsCubit>(
              create: (context) => TempSettingsCubit())
        ],
        child: MaterialApp(
          title: 'Thời tiết',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(_email),
        ),
      ),
    );
  }
}
