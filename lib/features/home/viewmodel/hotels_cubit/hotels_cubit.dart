import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/core/services/hotel_service/hotel_service.dart';
import 'package:glide/features/home/viewmodel/hotels_cubit/hotels_states.dart';
import 'package:glide/features/hotels/model/hotel_model.dart';

class HotelsCubit extends Cubit<InitialHotelsState>{

  HotelsCubit() : super(InitialHotelsState());
  static HotelsCubit get(context) => BlocProvider.of(context);
  Future<List<Hotel>> getHotels(city)async{
    log("hiiiiii");

    String cityCode = getCityCode(city);
    log(cityCode);

    try{
      emit(LoadingHotelsState());
      List<Hotel> hotels = await  HotelService().getHotelsByCity(cityCode);
      log("hi11w12d2kndewl iiiii");

      log(hotels[0].name);
      emit(SuccessHotelsState(hotels));
      return hotels;
    }
    catch(e){
      emit(ErrorHotelsState(e.toString()));
      return [];
    }
  }
  getCityCode(String cityName){
    Map<String,String> cityCodes = {
      "Paris":"PAR",
      "New York":"NYC",
      "London":"LON",
      "Los Angeles":"LAX",
      "Tokyo":"TYO",
      "Dubai":"DXB",
      "Singapore":"SIN",
      "Hong Kong":"HKG",
      "Bangkok":"BKK",
      "Istanbul":"IST",
      "Barcelona":"BCN",
      "Amsterdam":"AMS",
      "Rome":"ROM",
      "San Francisco":"SFO",
      "Miami":"MIA",
    };
    return cityCodes[cityName] ?? "PAR";
  }
}