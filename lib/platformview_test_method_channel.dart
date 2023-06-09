import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platformview_test_platform_interface.dart';

/// An implementation of [MapViewPlatform] that uses method channels.
class MethodChannelMapView extends MapViewPlatform {
  final Map<int, MethodChannel> _channels = <int, MethodChannel>{};

  @override
  Future<void> init(int mapId) async {
    _ensureChannelInitialized(mapId);
  }

  @override
  Future<void> setRegion(int mapId, CoordinateRegion region, {bool animated = false}) async {
    // TODO(cbracken): Ensure all maps call init, then use _channels[mapId].
    MethodChannel channel = _ensureChannelInitialized(mapId);
    await channel.invokeMethod<String>('setRegion', <String, dynamic>{
      'center': <String, dynamic>{
        'latitude': region.center.latitude,
        'longitude': region.center.longitude,
      },
      'latitudinalMeters': region.latitudinalMeters,
      'longitudinalMeters': region.longitudinalMeters,
      'animated': animated,
    });
  }

  MethodChannel _ensureChannelInitialized(int mapId) {
    MethodChannel? channel = _channels[mapId];
    if (channel == null) {
      channel = MethodChannel('bracken.jp/mapview_macos_$mapId');
      channel.setMethodCallHandler((MethodCall call) => _handleMethodCall(call, mapId));
      _channels[mapId] = channel;
    }
    return channel;
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    // TODO(cbracken): implement.
  }
}
