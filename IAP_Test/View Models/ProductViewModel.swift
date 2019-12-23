//
//  ProductViewModel.swift
//  MathBooster
//
//  Created by Valentin Strazdin on 17.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public class ProductViewModel {
    let freePriceCategories = ["category_0"]
    
    var id: String
    var name: String
    var priceCategory: String
    var storeProduct: SKProduct?
    
    init(id: String, name: String, priceCategory: String) {
        self.id = id
        self.name = name
        self.priceCategory = priceCategory
    }
    
    var isFree: Bool {
        return freePriceCategories.contains(priceCategory.lowercased())
    }
    
    var isEnabled: Bool {
        return (isFree || storeProduct != nil)
    }
    
    var localizedPrice: String? {
        return isFree ? "Free".localized() : storeProduct?.localizedPrice
    }
}

extension ProductViewModel {
    
    /// Here we try to get Payment Transaction for Product using priceCategory as product identifier
    func getTransaction() -> SKPaymentTransaction? {
        let transactions = SKPaymentQueue.default().transactions
        guard transactions.count > 0 else { return nil }
        if let transaction = transactions.filter({ $0.payment.productIdentifier == self.priceCategory }).first {
            return transaction
        }
        else {
            return nil
        }
    }
}

extension Array where Element == ProductViewModel {
    
    /// Here we remove free products from the list and get array of different priceCategories
    var productIdentifiers: Set<ProductIdentifier> {
        let priceCategories = self.filter({ !$0.isFree}).map({ $0.priceCategory }).removeDuplicates()
        return Set(priceCategories)
    }
}
