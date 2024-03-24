import 'dart:developer';

import 'package:get/get.dart';
import 'package:weartherproject/model/currentWeatherData.dart';
import 'package:weartherproject/model/fiveDaysData.dart';
import 'package:weartherproject/services/weatherService.dart';

class HomeController extends GetxController {
  late String city;


  HomeController({required this.city});

  late CurrentWeatherData currentWeatherData;
  List<FiveDaysData> fiveDaysData = [];
  List<CurrentWeatherData> dataList = [];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initState();
    getTopFiveCites();
  }

  void updateWeather (){
    initState();
  }

  void initState() {
    getCurrentWeatherData();
    getFiveDaysData();
  }

  void getCurrentWeatherData() {
    WeatherService(city: city).getCurrentWeatherData(
      onSuccess: (data){
        currentWeatherData = data;
        update();
      },
      onError: (error){
        print(error);
        update();
      }
    );
  }

  void getFiveDaysData() {
    WeatherService(city: city).getFiveThreeHourForcastData(
        onSuccess: (data){
          fiveDaysData = data;
          update();
        },
        onError: (error){
          print(error);
          update();
        }
    );
  }


  void getTopFiveCites() {
    List<String> cites=[
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Huế',
      'Vinh',
    ];
    cites.forEach((city) {
      WeatherService(city: city).getCurrentWeatherData(
          onSuccess: (data){
            dataList.add(data);
            update();
          },
          onError: (error){
            print(error);
            update();
          }
      );
    });
  }
}