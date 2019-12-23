//
//  PurchaseManager.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public typealias TransactionIdentifier = String
/// Closure to be executed when a request has completed.
public typealias PurchaseCourseCompletion = (Swift.Result<Course, Error>) -> Void
public typealias CustomCompletion = (Swift.Result<Void, Error>) -> Void

public protocol HasPurchaseManager {
    var purchaseManager: PurchaseManager { get }
}

/// We use this manager for processing all payment transactions, start, cancel and complete purchases
public final class PurchaseManager: NSObject, HasPaymentQueueDelegate, HasNotificationService {
    public let paymentQueueDelegate: SKPaymentQueueDelegate
    public let notificationService: NotificationServiceProtocol
    
    public var purchaseCourseCompletion: PurchaseCourseCompletion?
    
    public init(paymentQueueDelegate: SKPaymentQueueDelegate,
                notificationService: NotificationServiceProtocol) {
        self.paymentQueueDelegate = paymentQueueDelegate
        self.notificationService = notificationService
        super.init()
    }
    
    // MARK: - Payments
    public var canMakePayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    /// Here we check corresponding course state on server, then either delete purchase item and close transaction if server was updated.
    /// If server was not updated yet then we either complete or cancel purchase depending on purchase item state
    /// - Parameters:
    ///   - transaction: transaction that we are checking
    ///   - purchaseItem: purchaseItem for which we complete / cancel purchase
    ///   - completion: Handler that should be executed at the end
    func processTransaction(_ transaction: SKPaymentTransaction,
                            completion: (() -> Void)? = nil) {
        // We are processing only purchased or failed transactions
        switch transaction.transactionState {
        case .purchasing:
            // Start purchasing
            break
        case .purchased:
            // Complete purchasing
            SKPaymentQueue.default().finishTransaction(transaction)
            let course = Course(id: 1, name: "course")
            if let purchaseCourseCompletion = self.purchaseCourseCompletion {
                purchaseCourseCompletion(.success(course))
            }
            else {
                // Post Notification that course was successfully purchased
                self.notificationService.addNotification(.purchaseCompleted(course))
            }
        case .failed:
            // Failed purchasing
            SKPaymentQueue.default().finishTransaction(transaction)
        default:
            break
        }
    }
    
    // MARK: - Buy Product
    
    /// Here we create SKPayment and add it in SKPaymentQueue
    /// - Parameters:
    ///   - storeProduct: Product that we are buying
    ///   - completion: completion that should run after purchase is completed or failed
    public func buyProduct(storeProduct: SKProduct,
                           completion: @escaping PurchaseCourseCompletion) {
        let payment = SKPayment(product: storeProduct)
        self.purchaseCourseCompletion = completion
        if #available(iOS 13.0, *) {
            SKPaymentQueue.default().delegate = paymentQueueDelegate
        }
        SKPaymentQueue.default().add(payment)
    }
    
    public func getReceipt() -> String? {
        // Get the receipt if it's available
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else { return nil }
        
        do {
            let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
            let receiptString = receiptData.base64EncodedString(options: [])
            return receiptString
        }
        catch {
            print("Error - \(error.localizedDescription)")
            return nil
        }
    }
    
}

extension PurchaseManager: SKPaymentTransactionObserver {

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        // Transaction array has changed (additions or state changes).
        for transaction in transactions {
            self.processTransaction(transaction)
        }
    }

    public func paymentQueue(_ queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        // Transactions removed from the queue (via finishTransaction:)
    }

    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        // Sent when a user initiates an IAP buy from the App Store
        return true
    }
    
}
