class FlightSearchParams {
  final String originLocationCode;
  final String destinationLocationCode;
  final String departureDate;
  final String? returnDate;
  final int adults;
  final String travelClass;
  final bool nonStop;
  final int max;

  FlightSearchParams({
    required this.originLocationCode,
    required this.destinationLocationCode,
    required this.departureDate,
    this.returnDate,
    required this.adults,
    required this.travelClass,
    this.nonStop = false,
    this.max = 10,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'originLocationCode': originLocationCode,
      'destinationLocationCode': destinationLocationCode,
      'departureDate': departureDate,
      'adults': adults,
      'travelClass': travelClass,
      'nonStop': nonStop,
      'max': max,
    };

    if (returnDate != null) {
      json['returnDate'] = returnDate!;
    }

    return json;
  }
}
