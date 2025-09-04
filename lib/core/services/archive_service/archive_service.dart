import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/search/model/flight_results_model.dart';

class ArchiveService {
  static const String _archivedItemsKey = 'archived_items';
  static const String _archivedFlightsKey = 'archived_flights';

  // Get archived item IDs
  static Future<List<String>> getArchivedItems() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_archivedItemsKey) ?? [];
  }

  // Get archived flight objects
  static Future<List<FlightResult>> getArchivedFlights() async {
    final prefs = await SharedPreferences.getInstance();
    final flightStrings = prefs.getStringList(_archivedFlightsKey) ?? [];
    log("Archived flight strings: $flightStrings");

    return flightStrings.map((flightString) {
      final Map<String, dynamic> flightMap = jsonDecode(flightString);
      return FlightResult.fromStorageJson(flightMap);
    }).toList();
  }

  static Future<void> archiveItem(String itemId, FlightResult flight) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> archivedItems = await getArchivedItems();
    List<String> archivedFlightStrings = prefs.getStringList(_archivedFlightsKey) ?? [];

    if (!archivedItems.contains(itemId)) {
      // Add ID to the list
      archivedItems.add(itemId);
      await prefs.setStringList(_archivedItemsKey, archivedItems);

      final flightJson = jsonEncode(flight.toJson());
      archivedFlightStrings.add(flightJson);
      await prefs.setStringList(_archivedFlightsKey, archivedFlightStrings);
    }
  }

  static Future<void> unarchiveItem(String itemId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> archivedItems = await getArchivedItems();
    List<String> archivedFlightStrings = prefs.getStringList(_archivedFlightsKey) ?? [];

    // Find the index of the item to remove
    final itemIndex = archivedItems.indexOf(itemId);

    if (itemIndex != -1) {
      // Remove from both lists at the same index
      archivedItems.removeAt(itemIndex);
      archivedFlightStrings.removeAt(itemIndex);

      await prefs.setStringList(_archivedItemsKey, archivedItems);
      await prefs.setStringList(_archivedFlightsKey, archivedFlightStrings);
    }
  }

  // Check if item is archived
  static Future<bool> isArchived(String itemId) async {
    List<String> archivedItems = await getArchivedItems();
    return archivedItems.contains(itemId);
  }
}