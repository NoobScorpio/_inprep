import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import flutter_downloader
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}

        GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
        application.registerForRemoteNotifications()  //* I Forgot This Line *
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
       FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
func applicationDidBecomeActive(_ application: UIApplication) {
  application.applicationIconBadgeNumber = 0;
}
