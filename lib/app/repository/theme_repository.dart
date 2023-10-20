// import 'package:flutter/material.dart';

// class ThemeRepository {
//   final window = WidgetsBinding.instance.window;
//   final _controller = Stream<Brightness>();

//   Theme() {
//     window.onPlatformBrightnessChanged = () {
//       // This callback gets invoked every time brightness changes
//       final brightness = window.platformBrightness;
//       _controller.sink.add(brightness);
//     };
//   }

//   Stream<Brightness> get stream => _controller.stream;
// }