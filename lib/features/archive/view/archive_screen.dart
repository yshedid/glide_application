import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:glide/features/search/model/flight_results_model.dart';

import '../../../core/services/archive_service/archive_service.dart';
import '../../../core/shared/widgets/widgets.dart';
import '../../home/viewmodel/layout_cubit/layout_cubit.dart';

class ArchiveScreen extends StatefulWidget {
  ArchiveScreen({super.key});

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  late Future<List<FlightResult>> _archivedFlightsFuture;
  Set<String> archivedItems = {};

  @override
  void initState() {
    super.initState();
    _archivedFlightsFuture = ArchiveService.getArchivedFlights();

  }

  _removeFromArchive(String itemId, int index) async {
    await ArchiveService.unarchiveItem(itemId);
    setState(() {
      // Refresh the future to reload data
      _archivedFlightsFuture = ArchiveService.getArchivedFlights();

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<FlightResult>>(
        future: _archivedFlightsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                buildAppBar(context, "Saved",onTap: (){
                  LayoutCubit.get(context).homeBody();
                }),
                Spacer(),
                CircularProgressIndicator(),
                Spacer(),
              ],
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {

            return Column(
              children: [
                buildAppBar(context, "Saved",onTap: (){
                  LayoutCubit.get(context).homeBody();
                }),
                Spacer(),
                Center(
                  child: Text(
                    "No saved items yet",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                Spacer()
              ],
            );
          }

          final flights = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                buildAppBar(context, "Saved",onTap: (){
                  LayoutCubit.get(context).homeBody();
                }),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, idx) {
                          return Card(
                            color: Color(0xff1f2937),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Color(0xff475c7a).withOpacity(1),
                                width: 0.7,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            flights[idx].departureTime,
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                          Text(
                                            flights[idx].departureAirport,
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 18),
                                      Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SizedBox(
                                            width: 70,
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: 1.5,
                                                  color: Colors.grey[600],
                                                ),
                                                Icon(
                                                  Icons.flight,
                                                  size: 24,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        children: [
                                          Text(
                                            flights[idx].arrivalTime,
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                          Text(
                                            flights[idx].arrivalAirport,
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      Text(
                                        "\$${flights[idx].price}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineLarge!
                                            .copyWith(fontSize: 21),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Colors.grey[400],
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        flights[idx].duration,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Spacer(),
                                      Text(
                                        flights[idx].stopsText,
                                        style: Theme.of(context).textTheme.bodySmall,
                                      ),
                                      Spacer(),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            flights[idx].availableSeats.toString(),
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                      Spacer(flex: 2),
                                      Text(
                                        flights[idx].departureDate,
                                        style: Theme.of(context).textTheme.bodySmall,
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buildMaterialButton(
                                          onPressed: () {},
                                          label: "Book Flight",
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      IconButton(
                                        onPressed: () => _removeFromArchive(flights[idx].id, idx),
                                        icon: Icon(Icons.delete_outline),
                                        padding: EdgeInsets.all(6),
                                        constraints: BoxConstraints(),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, idx) => SizedBox(height: 10),
                        itemCount: flights.length, // Use actual flights length
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}