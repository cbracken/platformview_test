import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platformview_test_method_channel.dart';

class Location {
  const Location({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  bool operator ==(Object other) {
    return other is Location &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode => Object.hash(latitude, longitude);
}

class CoordinateRegion {
  const CoordinateRegion({
    required this.center,
    required this.latitudinalMeters,
    required this.longitudinalMeters,
  });

  final Location center;
  final double latitudinalMeters;
  final double longitudinalMeters;

  @override
  bool operator ==(Object other) {
    return other is CoordinateRegion &&
        center == other.center &&
        latitudinalMeters == other.latitudinalMeters &&
        longitudinalMeters == other.longitudinalMeters;
  }

  @override
  int get hashCode => Object.hash(center, latitudinalMeters, longitudinalMeters);
}

abstract class MapViewPlatform extends PlatformInterface {
  /// Constructs a PlatformViewTestPlatform.
  MapViewPlatform() : super(token: _token);

  static final Object _token = Object();

  static MapViewPlatform _instance = MethodChannelMapView();

  /// The default instance of [PlatformViewTestPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformViewTest].
  static MapViewPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformViewTestPlatform] when
  /// they register themselves.
  static set instance(MapViewPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> init(int mapId) {
    throw UnimplementedError('init() not implemented');
  }

  Future<void> setRegion(int mapId, CoordinateRegion region,
      {bool animated = false}) {
    throw UnimplementedError('setMapLocation() not implemented');
  }
}
