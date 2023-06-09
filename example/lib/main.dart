import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:platformview_test/platformview_test.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController tweenController;
  late AnimationController rotationController;
  late Animation<double> rotation;

  double opacity = 1.0;
  double radius = 30;
  double scale = 0.75;
  double angle = 0;
  double textAngle = 0;
  bool forward = true;

    // Hacked in hardcoded locations - extract location setting as methods and move to Dart.
  List<CoordinateRegion> _regions = const <CoordinateRegion>[
    // Kyoto Gosho zoomed out.
    CoordinateRegion(
      center: Location(latitude: 35.02517, longitude: 135.76354),
      latitudinalMeters: 1000000,
      longitudinalMeters: 1000000),
    // Kyoto Gosho zoomed in.
    CoordinateRegion(
      center: Location(latitude: 35.02517, longitude: 135.76354),
      latitudinalMeters: 10000,
      longitudinalMeters: 10000),
    // Kyoto Gosho more zoomed in.
    CoordinateRegion(
      center: Location(latitude: 35.02517, longitude: 135.76354),
      latitudinalMeters: 1000,
      longitudinalMeters: 1000),
    // Kyoto Gosho zoomed out.
    CoordinateRegion(
      center: Location(latitude: 34.98538, longitude: 135.76320),
      latitudinalMeters: 10000,
      longitudinalMeters: 10000),
    // Osaka-jou zoomed out.
    CoordinateRegion(
      center: Location(latitude: 34.687602115847326, longitude: 135.5263715730193),
      latitudinalMeters: 10000,
      longitudinalMeters: 10000),
    // Osaka-jou zoomed out.
    CoordinateRegion(
      center: Location(latitude: 34.687602115847326, longitude: 135.5263715730193),
      latitudinalMeters: 3000,
      longitudinalMeters: 3000),
    // Osaka-jou zoomed out.
    CoordinateRegion(
      center: Location(latitude: 34.687602115847326, longitude: 135.5263715730193),
      latitudinalMeters: 10000,
      longitudinalMeters: 10000),
    // Osaka-jou zoomed out.
    CoordinateRegion(
      center: Location(latitude: 34.687602115847326, longitude: 135.5263715730193),
      latitudinalMeters: 100000,
      longitudinalMeters: 100000),
  ];
  int _region = 0;

  @override
  void initState() {
    super.initState();
    tweenController = AnimationController(duration: const Duration(seconds: 30), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(tweenController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object's value.
          angle = animation.value * 360;
          scale = 0.5 + animation.value;
          radius = 100 * animation.value;
          opacity = 1.0 - (animation.value * 0.25);
          textAngle = 2 * math.pi * animation.value;
        });
      });
    tweenController.repeat();
    Timer.periodic(const Duration(seconds: 3), (Timer _) {
      _region = (_region + 1) % _regions.length;
    });
  }

  DeformableNativeView? nativeView;

  @override
  Widget build(BuildContext context) {
    final Widget version = Text('');
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              version,
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Transform.rotate(angle: textAngle, child: Text("Underlaid flutter widget",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.red))),
                  DeformableNativeView(
                    angle: -4 * math.pi / 180 * angle,
                    opacity: opacity,
                    radius: radius,
                    scale: scale,
                    region: _regions[_region],
                  ),
                  Transform.rotate(angle: -textAngle, child: Opacity(
                    opacity: 0.75,
                    child: Container(
                      constraints: const BoxConstraints.expand(
                        height: 75,
                        width: 350,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.blue[600],
                      alignment: Alignment.center,
                      transform: Matrix4.rotationZ(0.2),
                      child: Text("Overlaid Flutter widget",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(color: Colors.white)),
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  const Text('Opacity'),
                  Slider(
                    value: opacity,
                    min: 0.0,
                    max: 1.0,
                    divisions: 20,
                    activeColor: Colors.greenAccent,
                    label: opacity.toString(),
                    onChanged: (double value) {
                      setState(() {
                        opacity = value;
                      });
                    },
                  ),
                  Text(opacity.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Rotate'),
                  Slider(
                    value: angle,
                    min: 0.0,
                    max: 360.0,
                    divisions: 72,
                    activeColor: Colors.greenAccent,
                    label: angle.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        angle = value;
                      });
                    },
                  ),
                  Text(angle.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Radius'),
                  Slider(
                    value: radius,
                    min: 0.0,
                    max: 100.0,
                    divisions: 10,
                    activeColor: Colors.greenAccent,
                    label: radius.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                  Text(radius.toStringAsFixed(2)),
                ],
              ),
              Row(
                children: [
                  const Text('Scale'),
                  Slider(
                    value: scale,
                    min: 0.0,
                    max: 1.5,
                    divisions: 15,
                    activeColor: Colors.greenAccent,
                    label: scale.toString(),
                    onChanged: (double value) {
                      setState(() {
                        scale = value;
                      });
                    },
                  ),
                  Text(scale.toStringAsFixed(2)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
