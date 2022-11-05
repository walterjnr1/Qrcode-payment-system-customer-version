import 'package:flutter/material.dart';
import 'package:customer_version_qrcode_payment_system/pages/welcome.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

void main() =>  runApp(
    MaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
      ),
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) =>   const WelcomeScreen(),
  },
));

