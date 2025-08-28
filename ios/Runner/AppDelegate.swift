import Flutter
import UIKit
import KakaoMapsSDK

@main
class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        // Flutter 플러그인 먼저 등록
        GeneratedPluginRegistrant.register(with: self)
        
        // 카카오 SDK 초기화
        guard let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as? String else {
            print("❌ KakaoAppKey not found in Info.plist")
            fatalError("KakaoAppKey not found in Info.plist")
        }
        
        print("🔑 Initializing Kakao SDK with key: \(kakaoAppKey.prefix(10))...")
        
        // SDK 초기화
        SDKInitializer.InitSDK(appKey: kakaoAppKey)
        
        // 플랫폼 뷰 팩토리 등록
        guard let registrar = self.registrar(forPlugin: "KakaoMapView") else {
            print("❌ Failed to get registrar for KakaoMapView")
            fatalError("Failed to get registrar for KakaoMapView")
        }
        
        let factory = KakaoMapViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "KakaoMapView")
        
        print("✅ Kakao SDK and Platform View Factory registered successfully")
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
