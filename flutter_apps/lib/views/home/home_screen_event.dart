import 'dart:ui';

import 'package:equatable/equatable.dart';

abstract class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object?> get props => [];
}

class TakePictureEvent extends HomeScreenEvent {
  final String template;

  const TakePictureEvent({required this.template});

  @override
  List<Object?> get props => [template];
}

class AccessCameraEvent extends HomeScreenEvent {
  const AccessCameraEvent();

  @override
  List<Object?> get props => [];
}

class ChangeTemplatePositionEvent extends HomeScreenEvent {
  final Offset newTemplatePosition;
  final Size screenSize;
  final Size templateSize;
  final Size cameraSize;

  const ChangeTemplatePositionEvent(
      {required this.newTemplatePosition,
      required this.screenSize,
      required this.templateSize,
      required this.cameraSize});

  @override
  List<Object?> get props =>
      [newTemplatePosition, screenSize, templateSize, cameraSize];
}
