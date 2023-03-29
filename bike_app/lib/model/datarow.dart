class Datarow {
  final String departure;
  final String returning;
  final String depStatID;
  final String depStatName;
  final String retStatID;
  final String retStatName;
  final String duration;
  final String distance;
  final String id;



  Datarow({required this.departure,
    required this.returning,
    required this.retStatID,
    required this.retStatName,
    required this.depStatID,
    required this.depStatName,
    required this.distance,
    required this.duration,
    required this.id
  });

  factory Datarow.fromJson(Map<String, dynamic> json) {
    return Datarow(departure: json["departure"],
        returning: json["return"],
        retStatID: json["retStatID"],
        retStatName: json["retStatName"],
        depStatID: json["depStatID"],
        depStatName: json["depStatName"],
        distance: json["distance"],
        duration: json["duration"],
        id: json["_id"]
    );
  }
}

