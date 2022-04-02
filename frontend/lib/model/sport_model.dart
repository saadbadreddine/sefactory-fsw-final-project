class Sport {
  int sportID;
  String sport;

  Sport({
    required this.sportID,
    required this.sport,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      sportID: json["ID"] ?? '',
      sport: json["sport"] ?? '',
    );
  }
}
