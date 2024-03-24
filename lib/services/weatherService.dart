import 'package:weartherproject/api/apiRepo.dart';
import 'package:weartherproject/model/currentWeatherData.dart';
import 'package:weartherproject/model/fiveDaysData.dart';

class WeatherService {
  String city;

  WeatherService({required this.city});
  //https://api.openweathermap.org/data/2.5/weather?q=hanoi&lang=vi&mode=json&appid=019ec9cc8927a7f299765ffd44c721b9#

  String baseUrl = "https://api.openweathermap.org/data/2.5";
  String apiKey = "appid=019ec9cc8927a7f299765ffd44c721b9";

  void getCurrentWeatherData({
    Function()? beforeSend,
    Function(CurrentWeatherData currentWeatherData)? onSuccess,
    Function(dynamic error)? onError,
}) {
    // method body
    final url = "$baseUrl/weather?q=$city&$apiKey";
    ApiRepo(url: url,payload: {}).getData(
      beforeSend: ()=>beforeSend!(),
      onSuccess: (data)=>onSuccess!(CurrentWeatherData.fromJson(data)),
      onError: (error)=>onError!(error),
    );
  }

  void getFiveThreeHourForcastData({
    //https://api.openweathermap.org/data/2.5/forecast?q=hanoi&appid=019ec9cc8927a7f299765ffd44c721b9#
    Function()? beforeSend,
    Function(List<FiveDaysData> fiveDaysData)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    // method body
    final url = "$baseUrl/forecast?q=$city&lang=vi&$apiKey";
    print(url);
    ApiRepo(url: '$url',payload: {}).getData(
      beforeSend: ()=>beforeSend!(),
      onSuccess: (data) => {
        onSuccess!((data['list'] as List)
              ?.map((t) => FiveDaysData.fromJson(t))
              ?.toList() ??
              List.empty()),
      },
      onError: (error)=>
      {
        onError!(error),
      });
  }
}