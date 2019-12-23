//
//  NotificationService.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit

public protocol NotificationServiceProtocol {
    func addNotification(_ notificationType: MBNotificationType)
    func removeNotification(_ notificationType: MBNotificationType)
    func markAsRead()
}

public protocol HasNotificationService {
    var notificationService: NotificationServiceProtocol { get }
}

public final class NotificationService: NotificationServiceProtocol {
    private let goodMorningDate: DateComponents
    
    init(goodMorningDate: DateComponents) {
        self.goodMorningDate = goodMorningDate
    }
    
    /// Add notification with given type
    /// - Parameter notificationType: corresponding notification type
    public func addNotification(_ notificationType: MBNotificationType) {
        let completion: (() -> Void) = {
            DispatchQueue.main.async {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationType.identifier])
                let notification = self.createNotification(notificationType)
                UNUserNotificationCenter.current().add(notification)
            }
        }
        self.requestPermissions(completion: completion)
    }
    
    /// Remove notification with given type
    /// - Parameter notificationType: corresponding notification type
    public func removeNotification(_ notificationType: MBNotificationType) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationType.identifier])
    }
    
    /// Create Local user notification with given type
    /// - Parameter notificationType: corresponding notification type
    private func createNotification(_ notificationType: MBNotificationType) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.body = notificationType.body
        content.userInfo = notificationType.userInfo
        let trigger = getTrigger(notificationType: notificationType)
        return UNNotificationRequest(identifier: notificationType.identifier,
                                     content: content,
                                     trigger: trigger)
    }
    
    private func getTrigger(notificationType: MBNotificationType) -> UNNotificationTrigger {
        switch notificationType {
        case .purchaseCompleted(_):
            return UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        case .goodMorning:
            return UNCalendarNotificationTrigger(dateMatching: self.goodMorningDate, repeats: true)
        }
    }
    
    /// Here we check if user has allowed Notifications
    /// - Parameter completion: completion that should be executed after checking permissions
    private func requestPermissions(completion: (() -> Void)? = nil) {
        let authorizationCompletion: ((Bool, Error?) -> Void) = { (granted, error) in
            if granted {
                completion?()
            }
            else {
                self.removeNotification(.goodMorning)
            }
        }
        let completionHandler: ((UNNotificationSettings) -> Void) = { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge],
                                                                        completionHandler: authorizationCompletion)
            case .authorized:
                completion?()
            case .denied:
                self.removeNotification(.goodMorning)
            default:
                break
            }
        }
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: completionHandler)
    }
    
    /// Remove all delivered notifications
    public func markAsRead() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
}

