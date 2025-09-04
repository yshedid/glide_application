import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../features/hotels/model/hotel_model.dart';
import '../flight_service/amadeus_token.dart';

class HotelService
{
  final Dio _dio;
  static const String _baseUrl =
      'https://test.api.amadeus.com';

  HotelService({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Hotel>> getHotelsByCity(String cityCode) async {
    try {
      final token = await AmadeusTokenService().getToken();

      final response = await _dio.get(
        '$_baseUrl/v1/reference-data/locations/hotels/by-city',
        queryParameters: {
          'cityCode': 'PAR',
          'radius': 1,
          'radiusUnit': 'KM',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      log('Hotels Response: ${response.data}');

      // Parse response to your Hotel model
      List<Hotel> hotels = [];
      if (response.data['data'] != null) {
        for (var hotelData in response.data['data']) {
          hotels.add(Hotel.fromJson(hotelData));
        }
      }

      return hotels;

    } on DioException catch (e) {
      log('Hotels search error: ${e.message}');
      rethrow;
    }
  }
}
