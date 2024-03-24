class Clouds {
  int all;

  Clouds({required this.all});

  Map<String, dynamic> toJson() {
    return {
      "all": this.all,
    };
  }

  factory Clouds.fromJson(Map<String, dynamic> json) {
    return Clouds(
      all: int.parse(json["all"]),
    );
  }
//
}