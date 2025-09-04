import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:glide/core/theme/app_colors.dart';
import 'package:glide/features/map/viewmodel/map_cubit.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/shared/widgets/widgets.dart';
import '../../home/viewmodel/layout_cubit/layout_cubit.dart';
import '../model/geoCoding_model.dart';
import '../viewmodel/map_states.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  void _zoomIn() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom + 1);
  }

  void _zoomOut() {
    final currentZoom = _mapController.camera.zoom;
    _mapController.move(_mapController.camera.center, currentZoom - 1);
  }

  void _searchLocation(MapCubit mapCubit) async {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return;

    await mapCubit.searchPlaces(query);

    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapStates>(
      listener: (context, state) {
        final mapCubit = MapCubit.of(context);

        List<GeocodingResult> location = mapCubit.searchResults;
        if (location.isNotEmpty && state is MapSuccess) {
          final result = location[0];

          // Use bounding box if available for perfect zoom
          if (result.boundingBox != null) {
            _mapController.fitCamera(
              CameraFit.bounds(
                bounds: result.boundingBox!,
                padding: EdgeInsets.all(50),
              ),
            );
          } else {
            _mapController.move(result.coordinates, 13);
          }
        } else if (state is MapError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Location not found.')));
        }
      },
      builder: (context, state) {
        if (state is MapLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Column(
          children: [
            buildAppBar(context, "Map",onTap: (){
              LayoutCubit.get(context).homeBody();
            }),

            // Map with Zoom Buttons
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(30.0444, 31.2357), // Cairo
                      initialZoom: 13, // cities
                      minZoom: 3,
                      maxZoom: 18,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // can be changed to whatever tile
                        userAgentPackageName: 'com.example.glide',
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 25,
                    ),
                    child: buildSearchTextField(
                      isEnabled: true,
                      controller: _searchController,
                      hintText: "Search for a location...",
                      onSubmitted: (value) =>
                          _searchLocation(MapCubit.of(context)),
                    ),
                  ),
                  // Zoom Controls
                  Positioned(
                    right: 16,
                    bottom: 20,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Material(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                color: AppColors.accent,
                                child: InkWell(
                                  onTap: _zoomIn,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.add,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 3),

                              Material(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color: AppColors.accent,
                                child: InkWell(
                                  onTap: _zoomOut,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.remove,
                                      size: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }
}
