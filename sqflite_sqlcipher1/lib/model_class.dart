class StudentModel {
  String name;
  int roll;
  bool isMale;
  double result;
  StudentModel({
    required this.name,
    required this.roll,
    required this.isMale,
    required this.result,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "roll": roll,
      "isMale": isMale,
      "result": result,
    };
  }

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      name: json["name"],
      roll: json["roll"],
      isMale: json["isMale"],
      result: json["result"]?.toDouble(),
    );
  }
}
