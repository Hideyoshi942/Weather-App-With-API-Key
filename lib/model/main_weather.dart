class MainWeather {
  double temp, feels_like, temp_min, temp_max, pressure, humidity, sea_level, grnd_level;

  MainWeather({required this.temp, required this.feels_like, required this.temp_min, required this.temp_max,
    required this.pressure, required this.humidity, required this.sea_level, required this.grnd_level});

  Map<String, dynamic> toJson() {
    return {
      "temp": this.temp,
      "feels_like": this.feels_like,
      "temp_min": this.temp_min,
      "temp_max": this.temp_max,
      "pressure": this.pressure,
      "humidity": this.humidity,
      "sea_level": this.sea_level,
      "grnd_level": this.grnd_level,
    };
  }

  factory MainWeather.fromJson(Map<String, dynamic> json) {
    return MainWeather(
      temp: double.parse(json["temp"]),
      feels_like: json["feels_like"],
      temp_min: json["temp_min"],
      temp_max: json["temp_max"],
      pressure: json["pressure"],
      humidity: json["humidity"],
      sea_level: json["sea_level"],
      grnd_level: json["grnd_level"],
    );
  }
//
}