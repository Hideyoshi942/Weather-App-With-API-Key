import 'package:weartherproject/model/clouds.dart';
import 'package:weartherproject/model/coord.dart';
import 'package:weartherproject/model/main_weather.dart';
import 'package:weartherproject/model/sys.dart';
import 'package:weartherproject/model/weather.dart';

class CurrentWeatherData {
  Coord coord;
  List<Weather> weather;
  String base;
  MainWeather mainWeather;
  int visibility;
  Clouds clouds;
  int dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int cod;

  CurrentWeatherData(
  { required this.coord,
    required this.weather,
    required this.base,
    required this.mainWeather,
    required this.visibility,
    required this.clouds,
    required this.dt,
    required this.sys,
    required this.timezone,
    required this.id,
    required this.name,
    required this.cod});

  factory CurrentWeatherData.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherData(
      coord: Coord.fromJson(json["coord"]),
      weather: (json["weather"] as List<dynamic>)
          .map((weatherJson) => Weather.fromJson(weatherJson))
          .toList(),
      base: json["base"],
      mainWeather: MainWeather.fromJson(json["mainWeather"]),
      visibility: json["visibility"],
      clouds: Clouds.fromJson(json["clouds"]),
      dt: json["dt"],
      sys: Sys.fromJson(json["sys"]),
      timezone: json["timezone"],
      id: json["id"],
      name: json["name"],
      cod: json["cod"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "coord": this.coord.toJson(),
      "weather": this.weather.map((weather) => weather.toJson()).toList(),
      "base": this.base,
      "mainWeather": this.mainWeather.toJson(),
      "visibility": this.visibility,
      "clouds": this.clouds.toJson(),
      "dt": this.dt,
      "sys": this.sys.toJson(),
      "timezone": this.timezone,
      "id": this.id,
      "name": this.name,
      "cod": this.cod,
    };
  }

//
}