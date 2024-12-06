import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/services/camera_service.dart';
import 'package:flutter_apps/services/google_map_service.dart';
import 'package:flutter_apps/utils/template_util.dart';
import 'package:flutter_apps/views/home/home_screen.dart';
import 'package:flutter_apps/views/home/home_screen_bloc.dart';
import 'package:flutter_apps/views/home/home_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  CameraController cameraController =
      CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);

  CameraService cameraService =
      CameraService(cameraController: cameraController);

  // Google Map load initial data
  GoogleMapService googleMapService = GoogleMapService();
  googleMapService.loadLocationSettings();
  googleMapService.isEnabledGetLocation();

  String template = await TemplateUtil.defaultTemplate();

  runApp(MaterialApp(
    home: BlocProvider(
      create: (final context) => HomeScreenBloc(cameraService: cameraService),
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          builder: (final context, final homeScreenState) => HomeScreen(
                homeScreenState: homeScreenState,
                cameraService: cameraService,
                template: template,
              )),
    ),
  ));
}
