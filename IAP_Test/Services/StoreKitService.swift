//
//  StoreObserver.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias StoreProductsCompletion = (Result<[SKProduct], Error>) -> Void

public protocol StoreKitServiceProtocol {
    func getStoreProducts(productIdentifiers: Set<ProductIdentifier>, completion: @escaping StoreProductsCompletion)
}

public protocol HasStoreKitService {
    var storeKitService: StoreKitServiceProtocol { get }
}

public final class StoreKitService: NSObject, StoreKitServiceProtocol {
    private var productsRequest: SKProductsRequest?
    private var storeProductsCompletion: StoreProductsCompletion?
    
    // MARK: - Get Products
    public func getStoreProducts(productIdentifiers: Set<ProductIdentifier>, completion: @escaping StoreProductsCompletion) {
        productsRequest?.cancel()
        storeProductsCompletion = completion
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
}

extension StoreKitService: SKProductsRequestDelegate {

    // MARK: - SKProductsRequestDelegate
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        storeProductsCompletion?(.success(products))
        clearProductsRequestAndHandler()
        for invalidIdentifier in response.invalidProductIdentifiers {
            print("Invalid Product Identifier - \(invalidIdentifier)")
        }
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        storeProductsCompletion?(.failure(error))
        clearProductsRequestAndHandler()
    }
    
    private func clearProductsRequestAndHandler() {
        productsRequest = nil
        storeProductsCompletion = nil
    }
}
