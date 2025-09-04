import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AmadeusTokenService {
  String? _token;
  DateTime? _expiryTime;
  final String _baseUrl = 'https://test.api.amadeus.com';
  final Dio _dio = Dio();

  Future<String> getToken() async {
    if (_token == null || _isTokenExpired()) {
      await _fetchNewToken();
    }
    return _token!;
  }

  bool _isTokenExpired() {
    if (_expiryTime == null) return true;
    return DateTime.now().isAfter(_expiryTime!);
  }

  Future<void> _fetchNewToken() async {
    final response = await _dio.post(
      '$_baseUrl/v1/security/oauth2/token',
      data: {
        'grant_type': 'client_credentials',
        'client_id': dotenv.env['API_KEY'],
        'client_secret': dotenv.env['SECRET'],
      },
      options: Options(
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      ),
    );
    log('Access Token Response: ${response.data}');

    _token = response.data['access_token'];
    _expiryTime = DateTime.now().add(
      Duration(minutes: 29),
    ); // Token valid for 29 minutes
  }
}
