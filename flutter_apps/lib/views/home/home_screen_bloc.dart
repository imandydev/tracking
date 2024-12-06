import 'dart:io';
import 'dart:ui';

import 'package:flutter_apps/services/camera_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  CameraService cameraService;

  HomeScreenBloc({required this.cameraService})
      : super(HomeScreenState.initial()) {
    on<HomeScreenEvent>(_onHandleCamera);
  }

  Future<void> _onHandleCamera(
      final HomeScreenEvent event, final Emitter<HomeScreenState> emit) async {
    if (event is TakePictureEvent) {
      File? newImage = await cameraService.takePicture(
          event.template, state.templatePosition);
      emit(state.cloneWith(image: newImage));
    } else if (event is ChangeTemplatePositionEvent) {
      _handleCalculateNewPositionTemplate(event, emit);
    }
  }

  _handleCalculateNewPositionTemplate(final ChangeTemplatePositionEvent event,
      final Emitter<HomeScreenState> emit) {
    Offset newPosition = state.templatePosition + event.newTemplatePosition;
    Size screenSize = event.screenSize;
    Size tempSize = event.templateSize;
    Size cameraSize = event.cameraSize;
    double paddingAll = 5;

    if (newPosition.dx + tempSize.width >= screenSize.width - paddingAll) {
      emit(state.cloneWith(
          templatePosition: Offset(
              screenSize.width - tempSize.width - paddingAll, newPosition.dy)));
    } else if (newPosition.dx <= paddingAll) {
      emit(state.cloneWith(templatePosition: Offset(paddingAll, newPosition.dy)));
    } else if (newPosition.dy + tempSize.height >= cameraSize.height) {
      emit(state.cloneWith(
          templatePosition:
              Offset(newPosition.dx, cameraSize.height - tempSize.height)));
    } else if (newPosition.dy <= paddingAll) {
      emit(state.cloneWith(templatePosition: Offset(newPosition.dx, paddingAll)));
    } else {
      emit(state.cloneWith(templatePosition: newPosition));
    }
  }
}
