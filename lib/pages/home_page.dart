import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weartherproject/cubits/weather/weather_cubit.dart';
import 'package:weartherproject/pages/search_page.dart';
import 'package:weartherproject/widgets/error_dialog.dart';
import 'package:weartherproject/constants/constants.dart';
import 'package:weartherproject/cubits/temp_settings/temp_settings_cubit.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Thời tiết'),
        actions: [
          IconButton(
              onPressed: () async {
                _city = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchPage()));

                print('city->$_city');
                if (_city != null) {
                  context.read<WeatherCubit>().fetchWeather(_city!);
                }
              },
              icon: const Icon(Icons.search)),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsPage();
                }),
              );
            },
          ),
        ],
      ),
      body: _showWeather(),
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return ((temperature * 9 / 5) + 32).toStringAsFixed(2) + '℉';
    }

    return temperature.toStringAsFixed(2) + '℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Chọn thành phố',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Center(
            child: Text(
              'Chọn thành phố',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 50,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Color.fromRGBO(135, 206, 235, 0.5),
                  borderRadius: BorderRadius.circular(25)),
              child: SizedBox(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 20, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      state.weather.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          TimeOfDay.fromDateTime(state.weather.lastUpdated)
                              .format(context),
                          style: const TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          '(${state.weather.country})',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          showTemperature(state.weather.temp),
                          style: const TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text(
                              showTemperature(state.weather.tempMax),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              showTemperature(state.weather.tempMin),
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Spacer(),
                        showIcon(state.weather.icon),
                        Expanded(
                          flex: 3,
                          child: formatText(state.weather.description),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dự báo trong ngày'),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('Dự báo trong trong 5 ngày'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}