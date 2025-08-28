import Flutter
import UIKit
import KakaoMapsSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        if let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as? String {
            
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
            
            guard let registrar = self.registrar(forPlugin: "KakaoMapView") else {
                fatalError("Failed to get registrar for KakaoMapView")
            }
            
            // 3. messenger는 프로퍼티이며, register 함수를 안전하게 호출합니다.
            let factory = KakaoMapViewFactory(messenger: registrar.messenger())
            registrar.register(factory, withId: "KakaoMapView")
        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
