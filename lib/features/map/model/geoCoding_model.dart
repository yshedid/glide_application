import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeocodingResult {
  final String displayName;
  final LatLng coordinates;
  final String? country;
  final String? city;
  final String? state;
  final LatLngBounds? boundingBox; // New field for perfect zoom
  final String? locationType; // e.g., "city", "country", "street"

  GeocodingResult({
    required this.displayName,
    required this.coordinates,
    this.country,
    this.city,
    this.state,
    this.boundingBox,
    this.locationType,
  });

  factory GeocodingResult.fromJson(Map<String, dynamic> json) {
    final address = json['address'] ?? {};

    // Parse bounding box if available
    LatLngBounds? bounds;
    if (json['boundingbox'] != null) {
      final bbox = json['boundingbox'];
      bounds = LatLngBounds(
        LatLng(double.parse(bbox[0]), double.parse(bbox[2])), // southwest
        LatLng(double.parse(bbox[1]), double.parse(bbox[3])), // northeast
      );
    }

    return GeocodingResult(
      displayName: json['display_name'] ?? '',
      coordinates: LatLng(double.parse(json['lat']), double.parse(json['lon'])),
      country: address['country'],
      city: address['city'] ?? address['town'] ?? address['village'],
      state: address['state'],
      boundingBox: bounds,
      locationType: json['type'], // Nominatim provides this
    );
  }
}
