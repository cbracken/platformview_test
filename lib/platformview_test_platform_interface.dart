import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'platformview_test_method_channel.dart';

abstract class PlatformViewTestPlatform extends PlatformInterface {
  /// Constructs a PlatformViewTestPlatform.
  PlatformViewTestPlatform() : super(token: _token);

  static final Object _token = Object();

  static PlatformViewTestPlatform _instance = MethodChannelPlatformViewTest();

  /// The default instance of [PlatformViewTestPlatform] to use.
  ///
  /// Defaults to [MethodChannelPlatformViewTest].
  static PlatformViewTestPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PlatformViewTestPlatform] when
  /// they register themselves.
  static set instance(PlatformViewTestPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setMapLocation(double latitude, double longitude) {
    throw UnimplementedError('setMapLocation() not implemented');
  }
}
