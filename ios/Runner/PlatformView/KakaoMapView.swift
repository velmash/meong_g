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
    
    func authenticationSucceeded() {
        print("✅ Authentication Succeeded")
        mapController?.activateEngine()
    }
    
    func authenticationFailed(_ errorCode: Int, desc: String) {
        print("❌ Authentication Failed: \(errorCode) - \(desc)")
    }
    
    func prepareEngineSucceeded() {
        print("✅ Engine Prepared Successfully")
        isEngineReady = true
    }
    
    func prepareEngineFailed(_ errorCode: Int, desc: String) {
        print("❌ Engine Prepare Failed: \(errorCode) - \(desc)")
        
        // 준비 실패시 다시 시도
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.retryPrepareEngine()
        }
    }
    
    func engineActivated() {
        print("✅ Engine Activated")
        if !isViewAdded {
            // 엔진이 활성화된 후 약간의 지연을 두고 뷰 추가
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.addViews()
            }
        }
    }
    
    func engineDeactivated() {
        print("⚠️ Engine Deactivated")
    }
    
    func addViewsSucceeded() {
        print("✅ Views Added Successfully")
        isViewAdded = true
        
        // 약간의 지연 후 카메라 설정
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupInitialCamera()
        }
    }
    
    func addViewsFailed(_ errorCode: Int, desc: String) {
        print("❌ Add Views Failed: \(errorCode) - \(desc)")
        
        // 뷰 추가 실패시 다시 시도
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.addViews()
        }
    }
    
    func containerDidResized(_ size: CGSize) {
        print("📐 Container Resized: \(size)")
        
        // 크기가 변경되었을 때 엔진이 준비되지 않았다면 다시 준비
        if !isEngineReady && size.width > 0 && size.height > 0 {
            setupMapController()
        }
    }
    
    private func retryPrepareEngine() {
        print("🔄 Retrying prepare engine...")
        if mapViewContainer.frame.width > 0 && mapViewContainer.frame.height > 0 {
            mapController?.prepareEngine()
        }
    }
    
    internal func addViews() {
        guard let mapController = self.mapController else {
            print("❌ MapController is nil")
            return
        }
        
        print("🗺️ Adding map view...")
        
        let defaultPosition = MapPoint(
            longitude: self.initialLon ?? 126.986,
            latitude: self.initialLat ?? 37.566
        )
        
        // appName을 번들 식별자나 간단한 이름으로 변경
        let appName = Bundle.main.bundleIdentifier ?? "MapApp"
        print("📱 Using app name: \(appName)")
        
        let mapviewInfo = MapviewInfo(
            viewName: "map",
            appName: "openmap",
            defaultPosition: defaultPosition
        )
        
        // 뷰 추가 전 상태 확인
        print("🔍 Container frame: \(mapViewContainer.frame)")
//        print("🔍 Default position: lat=\(defaultPosition.latitude), lon=\(defaultPosition.longitude)")
        
        mapController.addView(mapviewInfo)
    }
    
    private func setupInitialCamera() {
        guard let mapController = self.mapController,
              let lat = self.initialLat,
              let lon = self.initialLon else {
            print("❌ Missing mapController or coordinates")
            return
        }
        
        guard let mapView = mapController.getView("mapview") as? KakaoMap else {
            print("❌ Failed to get mapview")
            // 맵뷰를 가져오지 못했다면 잠시 후 다시 시도
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setupInitialCamera()
            }
            return
        }
        
        print("📍 Setting up camera for coordinates: \(lat), \(lon)")
        
        let targetPoint = MapPoint(longitude: lon, latitude: lat)
        let cameraUpdate = CameraUpdate.make(target: targetPoint, zoomLevel: 15, mapView: mapView)
        
        mapView.moveCamera(cameraUpdate)
        print("✅ Camera moved to: \(lat), \(lon)")
    }
}
