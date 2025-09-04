import '../../../hotels/model/hotel_model.dart';

class InitialHotelsState {}
class LoadingHotelsState extends InitialHotelsState{}
class SuccessHotelsState extends InitialHotelsState{
  final List<Hotel> hotels;
  SuccessHotelsState(this.hotels);
}
class ErrorHotelsState extends InitialHotelsState{
  final String message;
  ErrorHotelsState(this.message);
}