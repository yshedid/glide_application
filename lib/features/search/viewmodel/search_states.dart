import '../model/airport_model.dart';

abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class AirportSearchLoading extends SearchState {
  final bool isFromField;

  const AirportSearchLoading({required this.isFromField});
}

class AirportSearchSuccess extends SearchState {
  final List<Airport> airports;
  final bool isFromField;

  const AirportSearchSuccess({
    required this.airports,
    required this.isFromField,
  });
}

class FlightSearchSuccess extends SearchState {
  final Map<String, dynamic> flightData;

  const FlightSearchSuccess({required this.flightData});
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}
