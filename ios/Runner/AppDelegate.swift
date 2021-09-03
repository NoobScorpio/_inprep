import UIKit
import Flutter
import Firebase
import FirebaseMessaging
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
//      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//      UNUserNotificationCenter.current().requestAuthorization(
//    options: authOptions,
//    completionHandler: {_, _ in })
//    }
//    else {
//  let settings: UIUserNotificationSettings =
//  UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//  application.registerUserNotificationSettings(settings)
//}
        GeneratedPluginRegistrant.register(with: self)
        application.registerForRemoteNotifications()  //* I Forgot This Line *
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
//    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
////        Mixpanel.mainInstance().people.addPushDeviceToken(deviceToken) //For Mixpanel purposes, not needed if not using
//        Messaging.messaging().apnsToken = deviceToken //*THIS WAS MISSING*
//        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken) //Not sure if calling super is required, but did anyway
//      }
//    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        ///Not sure if calling super is required here
//        super.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
//      }
}
