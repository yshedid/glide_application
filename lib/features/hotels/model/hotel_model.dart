class Hotel {
  final String id;
  final String name;
  final String address;
  final String line;

  Hotel({required this.id, required this.name, required this.address,required this.line});

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address']['cityName'] + ', ' + json['address']['countryCode'],
      line: json['address']['lines'] != null && (json['address']['lines'] as List).isNotEmpty
          ? (json['address']['lines'][0] +
          (json['address']['lines'].length > 1 ? ', ' + json['address']['lines'][1] : ''))
          : "default line",

    );
  }
}