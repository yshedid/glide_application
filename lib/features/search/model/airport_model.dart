class Airport {
  final String iata;
  final String icao;
  final String name;
  final String city;
  final String country;

  Airport({
    required this.iata,
    required this.icao,
    required this.name,
    required this.city,
    required this.country,
  });

  factory Airport.fromAmadeusJson(Map<String, dynamic> json) {
    return Airport(
      iata: json['iataCode'] ?? '',
      icao: json['icaoCode'] ?? '',
      name: json['name'] ?? '',
      city: json['address']?['cityName'] ?? '',
      country: json['address']?['countryName'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'iata': iata,
      'icao': icao,
      'name': name,
      'city': city,
      'country': country,
    };
  }
}
