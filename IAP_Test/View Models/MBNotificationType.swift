//
//  MBNotificationType.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import UserNotifications

struct NotificationIdentifiers {
    static let purchaseCompleted = "Completed"
    static let goodMorning = "GoodMorning"
}

public enum MBNotificationType {
    case purchaseCompleted(Course)
    case goodMorning
    
    var identifier: String {
        switch self {
        case .purchaseCompleted(_):
            return NotificationIdentifiers.purchaseCompleted
        case .goodMorning:
            return NotificationIdentifiers.goodMorning
        }
    }
    
    var body: String {
        switch self {
        case .purchaseCompleted(let course):
            return "New course".localized() + " \"\(course.name)\""
        case .goodMorning:
            return "Good morning".localized()
        }
    }
    
    var userInfo: [AnyHashable : Any] {
        switch self {
        case .purchaseCompleted(let course):
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(course) else { return [:] }
            return ["course": data]
        case .goodMorning:
            return [:]
        }
    }
    
}
