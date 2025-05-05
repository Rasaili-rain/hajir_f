class Subject {
  String name;
  int presentDays;
  int totalDays;

  Subject({required this.name, this.presentDays = 0, this.totalDays = 0});

  Map<String, dynamic> toJson() => {
        'name': name,
        'presentDays': presentDays,
        'totalDays': totalDays,
      };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json['name'] as String,
        presentDays: json['presentDays'] as int,
        totalDays: json['totalDays'] as int,
      );
}