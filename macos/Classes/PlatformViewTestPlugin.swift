import Cocoa
import FlutterMacOS
import MapKit

class MapViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withViewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> NSView {
        return MapView(
            frame: CGRect(x: 0, y: 0, width: 200, height: 200),
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }
}

class MapView: NSView {
    // Hacked in hardcoded locations - extract location setting as methods and move to Dart.
    let regions = [
        // Kyoto Gosho zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 35.02517, longitude: 135.76354).coordinate,
          latitudinalMeters: 1000000,
          longitudinalMeters: 1000000),
        // Kyoto Gosho zoomed in.
        MKCoordinateRegion(
          center: CLLocation(latitude: 35.02517, longitude: 135.76354).coordinate,
          latitudinalMeters: 10000,
          longitudinalMeters: 10000),
        // Kyoto Gosho more zoomed in.
        MKCoordinateRegion(
          center: CLLocation(latitude: 35.02517, longitude: 135.76354).coordinate,
          latitudinalMeters: 1000,
          longitudinalMeters: 1000),
        // Kyoto Gosho zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 34.98538, longitude: 135.76320).coordinate,
          latitudinalMeters: 10000,
          longitudinalMeters: 10000),
        // Osaka-jou zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 34.687602115847326, longitude: 135.5263715730193).coordinate,
          latitudinalMeters: 10000,
          longitudinalMeters: 10000),
        // Osaka-jou zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 34.687602115847326, longitude: 135.5263715730193).coordinate,
          latitudinalMeters: 3000,
          longitudinalMeters: 3000),
        // Osaka-jou zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 34.687602115847326, longitude: 135.5263715730193).coordinate,
          latitudinalMeters: 10000,
          longitudinalMeters: 10000),
        // Osaka-jou zoomed out.
        MKCoordinateRegion(
          center: CLLocation(latitude: 34.687602115847326, longitude: 135.5263715730193).coordinate,
          latitudinalMeters: 100000,
          longitudinalMeters: 100000),
    ]
    var region = 0;

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        super.init(frame: frame)
        super.wantsLayer = true
        super.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

        let mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        let initialLoc = CLLocation(latitude: 34.98538, longitude: 135.76320)
        mapView.setRegion(regions[0], animated: false)
        super.addSubview(mapView)
        let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.region = (self.region + 1) % self.regions.count
            mapView.setRegion(self.regions[self.region], animated: true)
        }
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.wantsLayer = true
        super.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
}

public class PlatformViewTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "platformview_test", binaryMessenger: registrar.messenger)
    let instance = PlatformViewTestPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let factory = MapViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "@views/mapview-view-type")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
