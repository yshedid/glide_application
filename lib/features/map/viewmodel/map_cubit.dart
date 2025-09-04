import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../../../core/services/map_service/map_service.dart';
import '../model/geoCoding_model.dart';
import 'map_states.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(MapInitial());

  static MapCubit of(BuildContext context) {
    return BlocProvider.of<MapCubit>(context);
  }

  List<GeocodingResult> searchResults = [];

  Future<void> searchPlaces(String query) async {
    emit(MapLoading());

    try {
      final results = await NominatimService.searchPlaces(query);
      searchResults = results;
      if (results.isEmpty) {
        emit(MapError());
      } else {
        emit(MapSuccess());
      }
    } catch (e) {
      developer.log('Search failed: $e', name: 'MapCubit');
      emit(MapError());
    }
  }
}
