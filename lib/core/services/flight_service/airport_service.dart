import 'package:dio/dio.dart';
import 'dart:developer';

import '../../../features/search/model/airport_model.dart';
import 'amadeus_token.dart';

class AirportService {
  final Dio _dio;
  static const String _baseUrl =
      'https://test.api.amadeus.com'; // Use test environment
  String? _accessToken;

  AirportService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Airport>> searchAirports(String query) async {
    if (query.length < 2) return [];

    try {
      _accessToken = await AmadeusTokenService().getToken();

      final response = await _dio.get(
        '$_baseUrl/v1/reference-data/locations',
        queryParameters: {
          'keyword': query,
          'subType': 'AIRPORT,CITY', // Search both airports and cities
          'page[limit]': 10, // Limit results
        },
        options: Options(
          headers: {'Authorization': 'Bearer $_accessToken'},
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200 && response.data['data'] is List) {
        final List<dynamic> data = response.data['data'];
        return data
            .where(
              (item) => item['iataCode'] != null,
            ) // Only include items with IATA codes
            .map((location) => Airport.fromAmadeusJson(location))
            .take(5)
            .toList();
      }

      return [];
    } on DioException catch (e) {
      log('Airport search error: ${e.message}');
      if (e.response?.statusCode == 401) {
        // Token expired, clear it
        _accessToken = null;
        throw Exception('Authentication failed - please try again');
      }
      throw Exception('Failed to search airports: ${e.message}');
    } catch (e) {
      log('Airport search error: $e');
      throw Exception('Unexpected error occurred while searching airports');
    }
  }
}
