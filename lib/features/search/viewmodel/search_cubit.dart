import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:glide/features/search/viewmodel/search_states.dart';

import '../../../core/services/flight_service/airport_service.dart';
import '../../../core/services/flight_service/flight_service.dart';
import '../model/flight_search_params.dart';

class SearchCubit extends Cubit<SearchState> {
  final AirportService _airportService;
  final FlightService _flightService;

  Timer? _searchTimer;

  SearchCubit({
    required AirportService airportService,
    required FlightService flightService,
  }) : _airportService = airportService,
       _flightService = flightService,
       super(SearchInitial());

  void searchAirports(String query, {required bool isFromField}) {
    // Cancel previous search timer
    _searchTimer?.cancel();

    if (query.length < 2) {
      emit(const AirportSearchSuccess(airports: [], isFromField: true));
      return;
    }

    emit(AirportSearchLoading(isFromField: isFromField));

    // Debounce search requests
    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      try {
        final airports = await _airportService.searchAirports(query);
        emit(
          AirportSearchSuccess(airports: airports, isFromField: isFromField),
        );
      } catch (e) {
        emit(SearchError(message: e.toString()));
      }
    });
  }

  Future<void> searchFlights(FlightSearchParams params) async {
    emit(SearchLoading());

    try {
      final flightData = await _flightService.searchFlights(params);
      log(flightData['data'].toString());
      emit(FlightSearchSuccess(flightData: flightData));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }

  void clearAirportSuggestions() {
    // Emit empty suggestions without loading state
    if (state is AirportSearchSuccess || state is AirportSearchLoading) {
      emit(SearchInitial());
    }
  }

  @override
  Future<void> close() {
    _searchTimer?.cancel();
    return super.close();
  }
}
