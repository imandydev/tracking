import 'package:flutter/cupertino.dart';

import '../configurations/screen_configuration.dart';


class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Color safeAreaBGColor;

  const Responsive(
      {super.key,
        required this.mobile,
        required this.tablet,
        required this.safeAreaBGColor});

  static bool isMobile(final BuildContext context) =>
      MediaQuery.of(context).size.width <= ScreenConfiguration.widthMaxMobile;


  @override
  Widget build(final BuildContext context) => LayoutBuilder(
    builder: (final context, final constraints) {
      if (Responsive.isMobile(context)) {
        return Container(
          color: safeAreaBGColor,
          child: SafeArea(child: mobile),
        );
      } else {
        return Container(
          color: safeAreaBGColor,
          child: SafeArea(child: tablet),
        );
      }
    },
  );
}