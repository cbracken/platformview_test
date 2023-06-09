
import 'platformview_test_platform_interface.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'platformview_test_platform_interface.dart' show Location, CoordinateRegion;

// Unique identifier for each map widget.
int _nextMapCreationId = 0;

class MapView extends StatefulWidget {
  const MapView({required this.region, Key? key}) : super(key: key);

  final CoordinateRegion region;

  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final int _mapId = _nextMapCreationId++;

  @override
  void initState() {
    super.initState();
    // MapViewPlatform.instance.setRegion(_mapId, widget.region, animated: true);
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    if (oldWidget.region == widget.region) {
      return;
    }
    MapViewPlatform.instance.setRegion(_mapId, widget.region, animated: true);
  }

  @override
  Widget build(BuildContext context) {
    // This is used in the platform side to register the view.
    const String viewType = '@views/mapview-view-type';

    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}

class DeformableNativeView extends StatelessWidget {
  const DeformableNativeView(
      {required this.angle,
      required this.opacity,
      required this.radius,
      required this.scale,
      required this.region,
      Key? key})
      : super(key: key);
  final double opacity;
  final double radius;
  final double angle;
  final double scale;
  final CoordinateRegion region;

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
              child: MapView(region: region),
            ),
          ),
        ),
      ),
    );
  }
}
