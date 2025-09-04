import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/features/search/view/search_results_screen.dart';

import '../../../core/services/flight_service/airport_service.dart';
import '../../../core/services/flight_service/flight_service.dart';
import '../../../core/shared/widgets/widgets.dart';
import '../model/flight_results_model.dart';
import '../model/flight_search_params.dart';
import '../viewmodel/search_cubit.dart';
import '../viewmodel/search_states.dart';
import 'flight_search_form.dart';

class SearchScreenView extends StatelessWidget {
   const SearchScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchCubit>(
      create: (context)=> SearchCubit(airportService: AirportService(),flightService:FlightServiceImpl() ),
      child: Builder(
        builder: (context) {
          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    buildAppBar(context, "Search",onTap:  (){
                      Navigator.pop(context);
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          BlocBuilder<SearchCubit, SearchState>(
                            builder: (context, state) {
                              if (state is SearchLoading) {
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 15),
                                  child: LinearProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          BlocListener<SearchCubit, SearchState>(
                            listener: (context, state) {
                              if (state is SearchError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else if (state is FlightSearchSuccess) {
                                List<FlightResult> flights =
                                    (state.flightData['data'] as List)
                                        .map((json) {
                                          return FlightResult.fromJson(json);
                                        })
                                        .toList();
                                buildNavigatorPush(
                                  context,
                                  screen: SearchResultsScreen(flights: flights),
                                );
                              }
                            },
                            child: FlightSearchForm(
                              onFlightSearchRequested: (searchParams) {
                                final params = FlightSearchParams(
                                  originLocationCode:
                                      searchParams['originLocationCode'],
                                  destinationLocationCode:
                                      searchParams['destinationLocationCode'],
                                  departureDate: searchParams['departureDate'],
                                  returnDate: searchParams['returnDate'],
                                  adults: searchParams['adults'],
                                  travelClass: searchParams['travelClass'],
                                  nonStop: searchParams['nonStop'] ?? false,
                                  max: searchParams['max'] ?? 10,
                                );
            
                                context.read<SearchCubit>().searchFlights(params);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
