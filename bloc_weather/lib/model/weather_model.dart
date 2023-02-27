class Weather {
  String cityName;
  double tem;

  Weather({required this.cityName, required this.tem});

  factory Weather.fromMap(Map<String, dynamic> json) => Weather(
        cityName: json['cityName'],
        tem: json['tem'],
      );

  Map toJson() => {
        'cityName': cityName,
        'tem': tem,
      };
}
