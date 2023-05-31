import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'platformview_test_platform_interface.dart';

/// An implementation of [PlatformViewTestPlatform] that uses method channels.
class MethodChannelPlatformViewTest extends PlatformViewTestPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('platformview_test');

  @override
  Future<void> setMapLocation(double latitude, double longitude) async {
    await methodChannel.invokeMethod<String>('setMapLocation', <String, dynamic>{'latitude': latitude, 'longitude': longitude});
  }
}
