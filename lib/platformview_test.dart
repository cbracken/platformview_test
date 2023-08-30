import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
export 'platformview_test_platform_interface.dart' show Location, CoordinateRegion;

// Unique identifier for each map widget.
int _nextMapCreationId = 0;

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  State createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  void initState() {
    super.initState();
    // MapViewPlatform.instance.setRegion(_mapId, widget.region, animated: true);
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
