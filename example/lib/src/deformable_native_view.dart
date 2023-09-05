import 'package:flutter/material.dart';

class DeformableNativeView extends StatelessWidget {
  const DeformableNativeView(
	  {required this.angle,
	  required this.opacity,
	  required this.radius,
	  required this.scale,
	  required this.child,
	  Key? key})
	  : super(key: key);
  final double opacity;
  final double radius;
  final double angle;
  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
	return Transform.rotate(
	  angle: angle,
	  child: Transform.scale(
		scale: scale,
		child: Opacity(
		  opacity: opacity,
		  child: ClipRRect(
			borderRadius: BorderRadius.circular(radius),
			child: SizedBox(
			  height: 300,
			  width: 300,
			  child: child,
			),
		  ),
		),
	  ),
	);
  }
}
