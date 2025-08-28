import Flutter
import UIKit
import KakaoMapsSDK

class KakaoMapViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return KakaoFlutterMapView(frame: frame, viewId: viewId, messenger: messenger, args: args)
    }
}

class KakaoFlutterMapView: NSObject, FlutterPlatformView, MapControllerDelegate {
    private var mapViewContainer: KMViewContainer
    private var mapController: KMController?
    private var initialLat: Double?
    private var initialLon: Double?

    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
        self.mapViewContainer = KMViewContainer(frame: frame)
        
        if let argsDict = args as? [String: Any],
           let lat = argsDict["lat"] as? Double,
           let lon = argsDict["lon"] as? Double {
            self.initialLat = lat
            self.initialLon = lon
        }
        
        super.init()
        
        setupMapController()
    }

    func view() -> UIView {
        return mapViewContainer
    }
    
    private func setupMapController() {
        mapController = KMController(viewContainer: mapViewContainer)
        mapController?.delegate = self
        mapController?.prepareEngine()
    }
    
    // MARK: - MapControllerDelegate
    
    func authenticationSucceeded() {
        print("Authentication Succeeded")
        mapController?.activateEngine()
    }

    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("Authentication Failed: \(errorCode) - \(desc)")
    }

    func prepareEngineSucceeded() {
        print("Engine Prepared Successfully")
    }
    
    func prepareEngineFailed(_ errorCode: Int, desc: String) {
        print("Engine Prepare Failed: \(errorCode) - \(desc)")
    }

    func engineActivated() {
        print("Engine Activated")
        addViews()
    }
    
    func engineDeactivated() {
        print("Engine Deactivated")
    }

    func addViewsSucceeded() {
        print("Views Added Successfully")
        setupInitialCamera()
    }

    func addViewsFailed(_ errorCode: Int, desc: String) {
        print("Add Views Failed: \(errorCode) - \(desc)")
    }

    func containerDidResized(_ size: CGSize) {
        print("Container Resized: \(size)")
    }
    
    internal func addViews() {
        guard let mapController = self.mapController else { return }
        
        let defaultPosition = MapPoint(longitude: self.initialLon ?? 126.986, latitude: self.initialLat ?? 37.566)
        let mapviewInfo = MapviewInfo(viewName: "mapview", appName: "map", defaultPosition: defaultPosition)
        
        mapController.addView(mapviewInfo)
    }
    
    private func setupInitialCamera() {
        guard let mapController = self.mapController,
              let lat = self.initialLat,
              let lon = self.initialLon else { return }

        guard let mapView = mapController.getView("mapview") as? KakaoMap else {
            print("Failed to get mapview")
            return
        }

        let targetPoint = MapPoint(longitude: lon, latitude: lat)
        let cameraUpdate = CameraUpdate.make(target: targetPoint, zoomLevel: 16, mapView: mapView)

        mapView.moveCamera(cameraUpdate)
        print("Camera moved to: \(lat), \(lon)")
    }
}
