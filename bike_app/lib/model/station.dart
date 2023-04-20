class Station {
  final String nimi;
  final String namn;
  final String name;
  final String osoite;
  final String adress;
  final String x;
  final String y;
  final String kaupunki;
  final String stad;
  final String operaattori;
  final String kapasiteetti;
  final String id;



  Station({required this.nimi,
    required this.namn,
    required this.name,
    required this.osoite,
    required this.adress,
    required this.x,
    required this.y,
    required this.kapasiteetti,
    required this.kaupunki,
    required this.stad,
    required this.operaattori,
    required this.id
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(nimi: json["nimi"],
        namn: json["namn"],
        name: json["name"],
        osoite: json["osoite"],
        adress: json["adress"],
        x: json["x"],
        y: json["y"],
        kapasiteetti: json["kapasiteetti"],
        kaupunki: json["kaupunki"],
        operaattori: json["operaattori"],
        stad: json["stad"],
        id: json["id"],

    );
  }
}

