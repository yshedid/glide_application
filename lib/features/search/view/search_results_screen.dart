import 'package:flutter/material.dart';
import 'package:glide/core/theme/app_colors.dart';

import '../../../core/services/archive_service/archive_service.dart';
import '../../../core/shared/widgets/widgets.dart';
import '../model/flight_results_model.dart';

class SearchResultsScreen extends StatefulWidget {
  SearchResultsScreen({super.key, required this.flights});
  List<FlightResult> flights;

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  Set<String> archivedItems = {};

  @override
  void initState() {
    super.initState();
    _loadArchivedItems();
  }

  _loadArchivedItems() async {
    final archived = await ArchiveService.getArchivedItems();
    setState(() {
      archivedItems = archived.toSet();
    });
  }

  _toggleArchive(String itemId, FlightResult flight) async {
    if (archivedItems.contains(itemId)) {
      await ArchiveService.unarchiveItem(itemId);
      setState(() {
        archivedItems.remove(itemId);
      });
    } else {
      await ArchiveService.archiveItem(itemId,flight);
      setState(() {
        archivedItems.add(itemId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context, "Flight Results", onTap: (){
                Navigator.pop(context);
              }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, idx) {
                        final flight = widget.flights[idx];
                        final isArchived = archivedItems.contains(flight.id);

                        return Container(
                          decoration: BoxDecoration(
                            color: Color(0xff1a1f2e),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Color(0xff2a3441),
                              width: 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                // Main flight route
                                Row(
                                  children: [
                                    // Departure
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          flight.departureTime,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          flight.departureAirport,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff94a3b8),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Spacer(),

                                    // Flight indicator
                                    Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Color(0xff3b82f6).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.flight_takeoff,
                                                size: 16,
                                                color: Color(0xff60a5fa),
                                              ),
                                              SizedBox(width: 6),
                                              Text(
                                                flight.duration,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff60a5fa),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Container(
                                          width: 80,
                                          height: 1,
                                          color: Color(0xff475569),
                                        ),
                                      ],
                                    ),

                                    Spacer(),

                                    // Arrival
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          flight.arrivalTime,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          flight.arrivalAirport,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xff94a3b8),
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Price and meta info
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "\$${flight.price}",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person_outline,
                                              size: 14,
                                              color: Color(0xff94a3b8),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${flight.availableSeats} seats left',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff94a3b8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),

                                    Spacer(),

                                    // Meta info
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:Colors.teal.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            flight.stopsText,
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          flight.departureDate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff94a3b8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Actions
                                Row(
                                  children: [
                                    Expanded(
                                        child: buildMaterialButton(
                                            onPressed: (){},
                                            label: "Book Flight"
                                        )
                                    ),
                                    SizedBox(width: 12),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: isArchived
                                            ? Color(0xff3b82f6).withOpacity(0.15)
                                            : Color(0xff374151),
                                        borderRadius: BorderRadius.circular(8),
                                        border: isArchived
                                            ? Border.all(color: Color(0xff3b82f6).withOpacity(0.3))
                                            : null,
                                      ),
                                      child: IconButton(
                                        onPressed: (){
                                          _toggleArchive(flight.id, flight);
                                        },
                                        icon: Icon(
                                          isArchived ? Icons.bookmark : Icons.bookmark_outline,
                                          color: isArchived
                                              ? Color(0xff60a5fa)
                                              : Color(0xff94a3b8),
                                        ),
                                        padding: EdgeInsets.all(8),
                                        constraints: BoxConstraints(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, idx) => SizedBox(height: 14),
                      itemCount: 10,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}