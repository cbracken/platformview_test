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
  final _platformViewTestPlugin = PlatformViewTest();

  double opacity = 1.0;
  double radius = 30;
  double scale = 0.75;
  double angle = 0;
  double textAngle = 0;
  bool forward = true;

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
  }

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
