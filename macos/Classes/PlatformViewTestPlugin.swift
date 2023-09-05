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

  // Returns the FlutterMessageCodec used to decode any creation arguments passed via
  // the AppKitView creationParams constructor argument.
  //
  // This method is optional, but if left unimplemented, the `arguments` argument to the create
  // method above will be nil.
  func createArgsCodec() -> (FlutterMessageCodec & NSObjectProtocol)? {
    return FlutterStandardMessageCodec.sharedInstance()
  }
}

class MapView: NSView {
  var mapView: MKMapView?

  init(
    frame: CGRect,
    viewIdentifier viewId: Int64,
    arguments args: Any?,
    binaryMessenger messenger: FlutterBinaryMessenger?
  ) {
    super.init(frame: frame)
    super.wantsLayer = true
    super.frame = CGRect(x: 0, y: 0, width: 200, height: 200)

    let channelName = "bracken.jp/mapview_macos_\(viewId)"
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger!)
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      self?.handle(call, result: result)
    })

    mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

    if var arguments = args as? [String: Any] {
      arguments["animated"] = false
      handleSetRegion(arguments)
    }
    super.addSubview(mapView!)
    NSLayoutConstraint.activate([
      mapView!.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      mapView!.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    super.wantsLayer = true
    super.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    mapView = nil
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setRegion":
      let args = call.arguments as! [String: Any]
      handleSetRegion(args)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func handleSetRegion(_ args: [String: Any]) {
    let centerArg = args["center"] as! [String: Double]
    let region = MKCoordinateRegion(
      center: CLLocation(
        latitude: centerArg["latitude"]!,
        longitude: centerArg["longitude"]!
      ).coordinate,
      latitudinalMeters: args["latitudinalMeters"] as! Double,
      longitudinalMeters: args["longitudinalMeters"] as! Double)
    let animated = args["animated"] as! Bool
    mapView?.setRegion(region, animated: animated)
  }
}

public class PlatformViewTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = MapViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "@views/mapview-view-type")
  }
}
