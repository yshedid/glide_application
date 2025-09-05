import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/shared/helper.dart';
import 'package:glide/features/auth/viewmodel/auth_cubit.dart';
import 'package:glide/features/home/viewmodel/hotels_cubit/hotels_cubit.dart';
import 'package:glide/features/home/viewmodel/hotels_cubit/hotels_states.dart';
import 'package:glide/features/hotels/view/hotels_screen.dart';
import 'package:glide/features/search/view/search_screen.dart';

import '../../../core/shared/widgets/widgets.dart';
import '../../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelsCubit,InitialHotelsState>(
      listener: (context, state){
        if(state is ErrorHotelsState){
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
        if(state is SuccessHotelsState){
          Navigator.of(context, rootNavigator: true).pop();
          buildNavigatorPush(context, screen: HotelsScreen(hotels: state.hotels,));
        }if (state is LoadingHotelsState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Hi, ${AuthCubit.get(context).currentUserName}',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings_outlined),
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(5),
                onTap: () {
                  buildNavigatorPush(context, screen: SearchScreenView());
                },
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: buildSearchTextField(),
                ),
              ),
              SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInkWellHome(context, text: "Flights"),
                  buildInkWellHome(context, text: "Hotels"),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Popular Destinations",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge!.copyWith(fontSize: 22),
              ),
              SizedBox(height: 24),
              CarouselSlider(
                items: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Container(
                          width: 160,
                          height: 160,
                          margin: const EdgeInsets.only(
                            right: 12,
                          ), // space between cards
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/images/paris.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "Paris",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Container(
                          width: 160,
                          height: 160,
                          margin: const EdgeInsets.only(
                            right: 12,
                          ), // space between cards
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/images/london.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "London",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Container(
                          width: 160,
                          height: 160,
                          margin: const EdgeInsets.only(
                            right: 12,
                          ), // space between cards
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Image.asset(
                            "assets/images/new_york.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "New York",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),


                ],
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.25,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.5,
                  padEnds: false,
                ),
              ),
              SizedBox(height: 30,),
              Text(
                "Hotels",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge!.copyWith(fontSize: 22),
              ),
              SizedBox(height: 10,),
              SizedBox(
                height: 42,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    RepeatingAnimatedDestinationItem(destinationName: "Paris",),
                    SizedBox(width: 10,),
                    RepeatingAnimatedDestinationItem(destinationName: "New York",),
                    SizedBox(width: 10,),
                    RepeatingAnimatedDestinationItem(destinationName: "London",),
                    SizedBox(width: 10,),
                    RepeatingAnimatedDestinationItem(destinationName: "Los Angeles",),

                  ],

                ),
              ),

              SizedBox(height: 30),
              Text(
                "Recent searches",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge!.copyWith(fontSize: 22),
              ),
              Row(
                children: [
                  buildMaterialButtonIcon(
                    onPressed: () {},
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  SizedBox(width: 10),
                  Text("Paris", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  buildMaterialButtonIcon(
                    onPressed: () {},
                    icon: Icon(Icons.location_on_outlined),
                  ),
                  SizedBox(width: 10),
                  Text("London", style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell buildInkWellHome(
    BuildContext context, {
    onTap,
    required String text,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(5),
      child: Container(
        width: 84,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 14),
          ),
        ),
      ),
    );
  }

  MaterialButton buildMaterialButtonIcon({
    required onPressed,
    required Widget icon,
    color = AppColors.accent,
  }) {
    return MaterialButton(
      onPressed: onPressed,
      color: color,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      minWidth: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: icon,
    );
  }
}
class RepeatingAnimatedDestinationItem extends StatefulWidget {
  final String destinationName;

  const RepeatingAnimatedDestinationItem({
    super.key,
    required this.destinationName,
  });

  @override
  State<RepeatingAnimatedDestinationItem> createState() =>
      _RepeatingAnimatedDestinationItemState();
}

// Use SingleTickerProviderStateMixin to provide the ticker for the animation controller
class _RepeatingAnimatedDestinationItemState
    extends State<RepeatingAnimatedDestinationItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Duration for one cycle of the animation
      vsync: this,
    )..repeat(reverse: true); // Make the animation repeat and reverse

    // 2. Define the color transition using a ColorTween
    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,
      end: Colors.teal,
    ).animate(_controller); // Animate the tween with the controller
  }

  @override
  void dispose() {
    // 3. Dispose the controller when the widget is removed to prevent memory leaks
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 4. Use AnimatedBuilder to rebuild the widget on every animation frame
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return GestureDetector(
          onTap: (){
            var cubit =HotelsCubit.get(context);
            cubit.getHotels(widget.destinationName);
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              // Use the current value of the color animation
              color: _colorAnimation.value,
              borderRadius: BorderRadius.circular(30.0), // Pill shape
            ),
            child: Center(
              child: Text(
                widget.destinationName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }}