import 'dart:io';

import 'package:flutter/cupertino.dart';


@immutable
class HomeScreenState {
  final File? image;
  final Offset templatePosition;

  const HomeScreenState({required this.image, required this.templatePosition});

  factory HomeScreenState.initial() => const HomeScreenState(image: null, templatePosition: Offset(10, 500));

  HomeScreenState cloneWith(
          {final File? image, final Offset? templatePosition, final String? template}) =>
      HomeScreenState(
          image: image ?? this.image,
          templatePosition: templatePosition ?? this.templatePosition
          );
}
