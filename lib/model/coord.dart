class Coord{
  double lon;
  double lat;

  Coord({required this.lon, required this.lat});

  factory Coord.fromJson(Map<String, dynamic> json) {
    return Coord(
      lon: double.parse(json["lon"]),
      lat: double.parse(json["lat"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lon": this.lon,
      "lat": this.lat,
    };
  }

}