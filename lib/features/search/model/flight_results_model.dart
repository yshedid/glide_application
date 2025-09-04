class FlightResult {
  final String id;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String departureAirport;
  final String arrivalAirport;
  final String duration;
  final String price;
  final String currency;
  final String airline;
  final String flightNumber;
  final String aircraft;
  final int stops;
  final int availableSeats;

  FlightResult({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.duration,
    required this.price,
    required this.currency,
    required this.airline,
    required this.flightNumber,
    required this.aircraft,
    required this.stops,
    required this.availableSeats,
    required this.departureDate,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departureTime': departureTime,
      'departureDate': departureDate,
      'arrivalTime': arrivalTime,
      'departureAirport': departureAirport,
      'arrivalAirport': arrivalAirport,
      'duration': duration,
      'price': price,
      'currency': currency,
      'airline': airline,
      'flightNumber': flightNumber,
      'aircraft': aircraft,
      'stops': stops,
      'availableSeats': availableSeats,
    };
  }

  factory FlightResult.fromJson(Map<String, dynamic> json) {
    // Get first segment for basic info
    final segment = json['itineraries'][0]['segments'][0];

    return FlightResult(
      id: json['id'],
      departureTime: _formatTime(segment['departure']['at']),
      departureDate: _formatDate(segment['departure']['at']),
      arrivalTime: _formatTime(segment['arrival']['at']),
      departureAirport: segment['departure']['iataCode'],
      arrivalAirport: segment['arrival']['iataCode'],
      duration: _formatDuration(json['itineraries'][0]['duration']),
      price: json['price']['total'],
      currency: json['price']['currency'],
      airline: segment['carrierCode'],
      flightNumber: segment['number'],
      aircraft: segment['aircraft']['code'],
      stops: segment['numberOfStops'],
      availableSeats: json['numberOfBookableSeats'],
    );
  }
  factory FlightResult.fromStorageJson(Map<String, dynamic> json) {
    return FlightResult(
      id: json['id'],
      departureTime: json['departureTime'],
      departureDate: json['departureDate'],
      arrivalTime: json['arrivalTime'],
      departureAirport: json['departureAirport'],
      arrivalAirport: json['arrivalAirport'],
      duration: json['duration'],
      price: json['price'],
      currency: json['currency'],
      airline: json['airline'],
      flightNumber: json['flightNumber'],
      aircraft: json['aircraft'],
      stops: json['stops'],
      availableSeats: json['availableSeats'],
    );
  }

  static String _formatTime(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
  static String _formatDate(String dateTime) {
    final dt = DateTime.parse(dateTime);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
  static String _formatDuration(String duration) {
    return duration
        .replaceAll('PT', '')
        .replaceAll('H', 'h ')
        .replaceAll('M', 'm')
        .toLowerCase();
  }

  String get flightInfo => '$airline $flightNumber • $aircraft';
  String get formattedPrice => '$currency $price';
  String get stopsText => stops == 0 ? 'Direct' : '$stops stop${stops > 1 ? 's' : ''}';
}