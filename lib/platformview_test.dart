import 'platformview_test_platform_interface.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'platformview_test_platform_interface.dart' show Location, CoordinateRegion;

class MapView extends StatefulWidget {
  const MapView({required this.region, Key? key}) : super(key: key);

  final CoordinateRegion region;

  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // Unique identifier for each map widget.
  static int _nextMapCreationId = 0;

  final int _mapId = _nextMapCreationId++;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
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
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'center': <String, dynamic>{
        'latitude': widget.region.center.latitude,
        'longitude': widget.region.center.longitude,
      },
      'latitudinalMeters': widget.region.latitudinalMeters,
      'longitudinalMeters': widget.region.longitudinalMeters,
    };

    return AppKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
    );
  }
}
