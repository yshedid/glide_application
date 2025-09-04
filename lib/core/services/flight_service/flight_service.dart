import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:glide/core/services/flight_service/amadeus_token.dart';

import '../../../features/search/model/flight_search_params.dart';

abstract class FlightService {
  Future<Map<String, dynamic>> searchFlights(FlightSearchParams params);
}

class FlightServiceImpl implements FlightService {
  final Dio _dio;
  String _accessToken = '';
  static const String _baseUrl = 'https://test.api.amadeus.com';

  FlightServiceImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Map<String, dynamic>> searchFlights(FlightSearchParams params) async {
    try {
      _accessToken = await AmadeusTokenService().getToken();
      final response = await _dio.get(
        '$_baseUrl/v2/shopping/flight-offers',
        queryParameters: params.toJson(),
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception('Failed to fetch flights');
    } on DioException catch (e) {
      log('Flight search error: ${e.message}');
      throw Exception('Failed to search flights: ${e.message}');
    } catch (e) {
      log('Flight search error: $e');
      throw Exception('Unexpected error occurred while searching flights');
    }
  }
}
