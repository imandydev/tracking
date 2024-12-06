import 'dart:io';

import 'package:camera/camera.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apps/services/camera_service.dart';
import 'package:flutter_apps/utils/template_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../configurations/color_configuration.dart';
import '../../widgets/responsive.dart';
import 'home_screen_bloc.dart';
import 'home_screen_event.dart';
import 'home_screen_state.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenState homeScreenState;
  final CameraService cameraService;
  final String template;

  const HomeScreen(
      {super.key,
      required this.homeScreenState,
      required this.cameraService,
      required this.template});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenBloc homeScreenBloc;
  late Future<void> cameraValue;
  File? image;

  @override
  void initState() {
    super.initState();

    // Access camera
    cameraValue = widget.cameraService.startCamera();

    homeScreenBloc = BlocProvider.of<HomeScreenBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    widget.cameraService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final GlobalKey templateKey = GlobalKey();
    final GlobalKey cameraKey = GlobalKey();

    return Responsive(
        mobile: Scaffold(
            backgroundColor: ColorConfiguration.colorWhite,
            floatingActionButton: Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ElevatedButton(
                onPressed: () {
                  homeScreenBloc
                      .add(TakePictureEvent(template: widget.template));
                },
                style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: const BorderSide(color: Colors.black, width: 4),
                    backgroundColor: Colors.white),
                child: null,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: Stack(
              children: [
                FutureBuilder(
                    future: cameraValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return SizedBox(
                          width: size.width,
                          height: size.height - 200,
                          key: cameraKey,
                          child: CameraPreview(
                              widget.cameraService.getController()),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
                Positioned(
                  left: widget.homeScreenState.templatePosition.dx,
                  top: widget.homeScreenState.templatePosition.dy,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      homeScreenBloc.add(
                        ChangeTemplatePositionEvent(
                            newTemplatePosition: details.delta,
                            screenSize: size,
                            cameraSize: (cameraKey.currentContext!
                                    .findRenderObject() as RenderBox)
                                .size,
                            templateSize: (templateKey.currentContext!
                                    .findRenderObject() as RenderBox)
                                .size),
                      );
                    },
                    child: Text(
                      widget.template,
                      key: templateKey,
                      style: const TextStyle(
                          color: ColorConfiguration.colorWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 40),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: widget.homeScreenState.image == null
                        ? null
                        : Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image(
                                    fit: BoxFit.cover,
                                    image: FileImage(
                                        widget.homeScreenState.image!)),
                              ),
                            ),
                          ),
                  ),
                )
              ],
            )),
        tablet: Container(),
        safeAreaBGColor: ColorConfiguration.colorWhite);
  }
}
