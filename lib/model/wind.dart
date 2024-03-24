class Wind{
  double speed, deg, gust;

  Wind({required this.speed, required this.deg, required this.gust});

  Map<String, dynamic> toJson() {
    return {
      "speed": this.speed,
      "deg": this.deg,
      "gust": this.gust,
    };
  }

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: double.parse(json["speed"]),
      deg: json["deg"],
      gust: json["gust"],
    );
  }
//
}