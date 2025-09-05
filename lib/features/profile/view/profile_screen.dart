import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/features/auth/view/login_screen.dart';
import 'package:glide/features/auth/viewmodel/auth_cubit.dart';
import 'package:glide/features/home/viewmodel/layout_cubit/layout_cubit.dart';

import '../../../core/shared/widgets/widgets.dart';
import '../view_model/profile_cubit.dart';
import '../view_model/profile_states.dart';

class ProfileScreen extends StatelessWidget {
   ProfileScreen({super.key});
  String? profileImage;

  @override
  Widget build(BuildContext context) {
    // Trip list with names and images
    final List<Map<String, String>> trips = [
      {
        'name': 'London',
        'image': 'assets/images/london.jpg',
        'duration': '3 days'
      },
      {
        'name': 'Paris',
        'image': 'assets/images/paris.jpg',
        'duration': '3 days'
      },
      {
        'name': 'New York',
        'image': 'assets/images/new_york.jpg',
        'duration': '3 days'
      },
    ];

    return SingleChildScrollView(
      child: BlocConsumer<ProfileCubit, ProfileStates>(
        builder: (BuildContext context, state) {
          ProfileCubit profileCubit = ProfileCubit.get(context);
          if(profileCubit.currentUserName == null) {
            profileCubit.initializeProfile();

          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildAppBar(context, "Profile",onTap: (){
                LayoutCubit.get(context).homeBody();
              }),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          // Profile Picture with tap to upload
                          GestureDetector(
                            onTap: () => profileCubit.uploadProfilePicture(),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 65,
                                  backgroundImage: profileCubit.currentAvatarUrl != null
                                      ? NetworkImage(profileCubit.currentAvatarUrl!)
                                      : AssetImage("assets/images/person.png") as ImageProvider,
                                ),
                                // Loading overlay
                                if (state is ProfileLoading)
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                // Camera icon
                                if (state is! ProfileLoading)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // User Name
                          Text(
                            profileCubit.currentUserName ?? 'Loading...',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            profileCubit.date != null?"joined at ${profileCubit.date!.split("T")[0]}":'Loading...',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    Text(
                      "Trips",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 160,
                              height: 95,
                              margin: const EdgeInsets.only(right: 12),
                              // space between cards
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Image.asset(
                                trips[index]['image']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              trips[index]['name']!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              trips[index]['duration']!,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),

                        itemCount: trips.length,
                      ),
                    ),
                    Text(
                      "Settings",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.copyWith(fontSize: 20),
                    ),
                    SizedBox(height: 24),
                    SelectionRow(
                      title: "Theme",
                      options: ["Light", "Dark"],
                      initialValue: "Light",
                      onSelected: (value) {
                        log("Theme changed to $value");
                      },
                    ),
                    SelectionRow(
                      title: "Language",
                      options: ["English", "Arabic"],
                      initialValue: "English",
                      onSelected: (value) {
                        log("Language changed to $value");
                      },
                    ),
                    SizedBox(height: 10),

                    InkWell(
                      onTap: () async{
                        await AuthCubit.get(context).signOut();
                        if(context.mounted){
                          buildNavigatorPushReplacement(context, screen: LoginScreen());
                        }

                      },
                      child: Padding(
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Sign Out",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Icon(
                              Icons.logout,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
        listener: (BuildContext context, state) {
          if (state is ProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state is ProfileSuccess) {
            profileImage = state.imageUrl;
            log("New Profile Image URLlllllll: $profileImage");

          }
        },
      ),
    );
  }
}