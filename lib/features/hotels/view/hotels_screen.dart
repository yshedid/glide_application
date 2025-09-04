import 'package:flutter/material.dart';
import 'package:glide/core/shared/widgets/widgets.dart';
import 'package:glide/core/theme/app_colors.dart';

import '../model/hotel_model.dart';

class HotelsScreen extends StatefulWidget {
   HotelsScreen({super.key, required this.hotels});
  List<Hotel> hotels;
  List<String> images =[
    "assets/images/hotel_1.png",
    "assets/images/hotel_2.png",
    "assets/images/hotel_4.png",
    "assets/images/hotel_5.png",
    "assets/images/hotel_1.png",
    "assets/images/hotel_2.png",
  ];

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {tabController = TabController(length: 5, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildAppBar(context, "Paris",onTap: (){Navigator.pop(context);}),
              Column(
                children: [
                  TabBar(
                    controller: tabController,
                    indicatorColor: Colors.white,
                    indicatorWeight: 3,
                    unselectedLabelColor: AppColors.textSecondary,
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.water, size: 24),
                            SizedBox(height: 5),
                            Text("Seaside", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.forest_outlined, size: 24),
                            SizedBox(height: 5),
                            Text("Forest", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.cabin, size: 24),
                            SizedBox(height: 5),
                            Text("Cabin", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.location_city, size: 24),
                            SizedBox(height: 5),
                            Text("City", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Tab(
                        child: Column(
                          children: [
                            Icon(Icons.villa_outlined, size: 24),
                            SizedBox(height: 5),
                            Text("Countryside", style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(itemBuilder: (context,index)=>Padding(
                      padding: const EdgeInsets.only(bottom: 40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: double.infinity,
                              height: 200,
                              child: Image.asset(_randomImage(),fit: BoxFit.cover,)),
                          SizedBox(height: 25,),
                          Text(widget.hotels[index].name,style: Theme.of(context).textTheme.headlineMedium,),
                          SizedBox(height: 8,),
                          Text(widget.hotels[index].address,style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 16),),
                          SizedBox(height: 8,),
                          Text(widget.hotels[index].line,style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14),)
        
                        ],
                      ),
                    ),
                      itemCount: widget.hotels.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  String _randomImage(){

    widget.images.shuffle();
    return widget.images.first;
  }
}
