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
    
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class KakaoFlutterMapView: NSObject, FlutterPlatformView {
    private var mapViewContainer: KMViewContainer
    private var mapController: KMController?
    private var initialLat: Double?
    private var initialLon: Double?
    private var isEngineReady = false
    private var isViewAdded = false
    
    init(frame: CGRect, viewId: Int64, messenger: FlutterBinaryMessenger, args: Any?) {
        // 최소 크기 보장
        let adjustedFrame = CGRect(
            x: frame.origin.x,
            y: frame.origin.y,
            width: max(frame.width, 100),
            height: max(frame.height, 100)
        )
        
        self.mapViewContainer = KMViewContainer(frame: adjustedFrame)
        
        if let argsDict = args as? [String: Any],
           let lat = argsDict["lat"] as? Double,
           let lon = argsDict["lon"] as? Double {
            self.initialLat = lat
            self.initialLon = lon
        }
        
        super.init()
        
        // 뷰 컨테이너 설정
        mapViewContainer.backgroundColor = UIColor.lightGray
        
        // 약간의 지연 후 맵 컨트롤러 설정 (뷰가 완전히 생성된 후)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setupMapController()
        }
    }
    
    func view() -> UIView {
        return mapViewContainer
    }
    
    private func setupMapController() {
        print("Setting up map controller with frame: \(mapViewContainer.frame)")
        
        mapController = KMController(viewContainer: mapViewContainer)
        mapController?.delegate = self
        
        // 뷰 크기가 유효한지 확인
        if mapViewContainer.frame.width > 0 && mapViewContainer.frame.height > 0 {
            mapController?.prepareEngine()
        } else {
            // 뷰 크기가 0이면 조금 더 기다려서 다시 시도
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.setupMapController()
            }
        }
    }
    
    // MARK: - MapControllerDelegate
    private func setupInitialCamera(_ viewName: String) {
        guard let mapController = self.mapController,
              let lat = self.initialLat,
              let lon = self.initialLon else {
            print("초기값 없음")
            return
        }
        
        guard let mapView = mapController.getView(viewName) as? KakaoMap else {
            print("❌ Failed to get mapview")
            // 맵뷰를 가져오지 못했다면 잠시 후 다시 시도
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setupInitialCamera(viewName)
            }
            return
        }
        
        let targetPoint = MapPoint(longitude: lon, latitude: lat)
        let cameraUpdate = CameraUpdate.make(target: targetPoint, zoomLevel: 15, mapView: mapView)
        
        mapView.moveCamera(cameraUpdate)
    }
}

extension KakaoFlutterMapView: MapControllerDelegate {
    func authenticationSucceeded() {
        mapController?.activateEngine()
    }
    
    func addViews() {
        guard let mapController = self.mapController else { return }
        
        let defaultPosition = MapPoint(
            longitude: self.initialLon ?? 126.986,
            latitude: self.initialLat ?? 37.566
        )
        
        let mapviewInfo = MapviewInfo(
            viewName: "map",
            appName: "openmap",
            defaultPosition: defaultPosition
        )
        
        mapController.addView(mapviewInfo)
    }
    
    func addViewSucceeded(_ viewName: String, viewInfoName: String) {
        setupInitialCamera(viewName)
    }
}
