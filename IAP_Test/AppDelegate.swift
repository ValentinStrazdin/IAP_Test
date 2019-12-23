//
//  AppDelegate.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var notificationService: NotificationServiceProtocol?
    var window: UIWindow?
    
    /// This is the date when we should start solving exercises
    private lazy var goodMorningDate: DateComponents = {
        var date = DateComponents()
        date.hour = 10
        date.minute = 0
        return date
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Add notifications handler
        UNUserNotificationCenter.current().delegate = self
        
        self.notificationService = NotificationService(goodMorningDate: goodMorningDate)
        self.notificationService?.addNotification(.goodMorning)
        // Override point for customization after application launch.
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - UNUserNotificationCenterDelegate methods
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else { return }
        processNotification(response.notification)
        completionHandler()
    }
    
    private func processNotification(_ notification: UNNotification) {
        let userInfo = notification.request.content.userInfo
        let decoder = JSONDecoder()
        guard notification.request.identifier == NotificationIdentifiers.purchaseCompleted,
            let data = userInfo["course"] as? Data,
            let course = try? decoder.decode(Course.self, from: data) else { return }
    }
}

