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
    var topLabel: NSTextField?
    var bottomLabel: NSTextField?

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
        channel.setMethodCallHandler({[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
          self?.handle(call, result: result)
        })

        topLabel = NSTextField()
        topLabel?.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44))
        topLabel?.stringValue = "Top AppKit label"
        topLabel?.isEditable = false
        topLabel?.sizeToFit()

        bottomLabel = NSTextField()
        bottomLabel?.frame = CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: 100, height: 44))
        bottomLabel?.stringValue = "Bottom AppKit label"
        bottomLabel?.isEditable = false
        bottomLabel?.sizeToFit()

        super.addSubview(topLabel!)
        super.addSubview(bottomLabel!)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.wantsLayer = true
        super.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        topLabel = nil
        bottomLabel = nil
    }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

public class PlatformViewTestPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let factory = MapViewFactory(messenger: registrar.messenger)
    registrar.register(factory, withId: "@views/mapview-view-type")
  }
}
