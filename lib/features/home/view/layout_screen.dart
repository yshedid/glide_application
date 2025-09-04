import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/theme/app_colors.dart';
import 'package:glide/features/archive/view/archive_screen.dart';
import 'package:glide/features/home/view/home_screen.dart';
import 'package:glide/features/home/viewmodel/hotels_cubit/hotels_cubit.dart';
import 'package:glide/features/map/view/map_screen.dart';
import 'package:glide/features/profile/view/profile_screen.dart';
import 'package:glide/features/search/view/search_screen.dart';

import '../../../core/services/flight_service/airport_service.dart';
import '../../../core/services/flight_service/flight_service.dart';
import '../../hotels/view/hotels_screen.dart';
import '../../map/viewmodel/map_cubit.dart';
import '../../profile/view_model/profile_cubit.dart';
import '../../search/viewmodel/search_cubit.dart';
import '../viewmodel/layout_cubit/layout_cubit.dart';
import '../viewmodel/layout_cubit/layout_states.dart';

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int index = 0;
  final _airportService = AirportService();
  final _flightService = FlightServiceImpl();
  final screens = [
    HomeScreen(),
    ArchiveScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MapCubit>(create: (context) => MapCubit()),
        BlocProvider<HotelsCubit>(create: (context) => HotelsCubit()),
        BlocProvider<ProfileCubit>(create: (context) => ProfileCubit()),
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(
            airportService: _airportService,
            flightService: _flightService,
          ),
        ),
      ],
      child: BlocListener<LayoutCubit,LayoutStates>(
        listener: (context,state){
          if(state is LayoutDefaultBottomNavState){
            index = 0;
            setState(() {});
          }

        },
        child: SafeArea(
          child: Scaffold(
            body: screens[index],
            bottomNavigationBar: SizedBox(
              height: (90 / 844) * MediaQuery.of(context).size.height,
              child: buildBottomNavigationBar(),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.bottomNav,

      showUnselectedLabels: true,
      elevation: 2,
      iconSize: 25,
      selectedItemColor: Colors.white,
      onTap: (index) {
        this.index = index;
        setState(() {});
      },
      currentIndex: index,
      items: const [
        BottomNavigationBarItem(
          backgroundColor: AppColors.bottomNav,

          icon: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.home_filled),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bottomNav,

          icon: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.local_library_outlined),
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bottomNav,

          icon: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.map_outlined),
          ),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bottomNav,

          icon: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Icon(Icons.person),
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
