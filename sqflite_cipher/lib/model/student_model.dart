class Student {
  Student({this.id, required this.name, required this.roll});
  int? id;
  String name;
  int roll;

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json['id'],
        name: json['name'],
        roll: json['roll'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'roll': roll,
    };
  }
}
