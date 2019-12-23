//
//  PaymentQueueDelegate.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public protocol HasPaymentQueueDelegate {
    var paymentQueueDelegate: SKPaymentQueueDelegate { get }
}

public final class PaymentQueueDelegate: NSObject, SKPaymentQueueDelegate {
    
    @available(iOS 13.0, *)
    public func paymentQueue(_ paymentQueue: SKPaymentQueue, shouldContinue transaction: SKPaymentTransaction, in newStorefront: SKStorefront) -> Bool {
        print("New Store front - \(newStorefront.countryCode)")
        return false
    }
}
