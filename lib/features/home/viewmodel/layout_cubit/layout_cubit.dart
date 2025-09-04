import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glide/features/home/viewmodel/layout_cubit/layout_states.dart';

import '../../../../core/services/profile_picture/profile_picture_service.dart';

class LayoutCubit extends Cubit<LayoutStates>
{
  LayoutCubit() : super(LayoutInitialState());
  String? _currentUserName;
  static LayoutCubit get(context) => BlocProvider.of(context);
  void homeBody(){
    emit(LayoutDefaultBottomNavState());
  }
}