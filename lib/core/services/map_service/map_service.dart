import 'package:dio/dio.dart';

import '../../../features/map/model/geoCoding_model.dart';

class NominatimService {
  static const String baseUrl = 'https://nominatim.openstreetmap.org';
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'User-Agent': 'Glide/1.0'},
    ),
  );

  // Forward Geocoding: Address → Coordinates
  static Future<List<GeocodingResult>> searchPlaces(String query) async {
    try {
      final response = await _dio.get(
        '$baseUrl/search',
        queryParameters: {
          'format': 'json',
          'q': query,
          'limit': 5,
          'addressdetails': 1, // Get detailed address info
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((item) => GeocodingResult.fromJson(item)).toList();
      }
    } on DioException catch (e) {
      print('Geocoding DioException: ${e.message}');
    } catch (e) {
      print('Geocoding error: $e');
    }

    return [];
  }

  // Reverse Geocoding: Coordinates → Address
  static Future<String?> reverseGeocode(double lat, double lng) async {
    try {
      final response = await _dio.get(
        '$baseUrl/reverse',
        queryParameters: {'format': 'json', 'lat': lat, 'lon': lng},
      );

      if (response.statusCode == 200) {
        return response.data['display_name'];
      }
    } on DioException catch (e) {
      print('Reverse geocoding DioException: ${e.message}');
    } catch (e) {
      print('Reverse geocoding error: $e');
    }

    return null;
  }
}
