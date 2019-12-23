//
//  BuyCourseViewModel.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public class BuyCourseViewModel: HasPurchaseManager {
    public let purchaseManager: PurchaseManager
    let product: ProductViewModel
    
    /// This is localized price for App Store In-App Purchase product
    var localizedPrice: String? {
        return product.localizedPrice
    }
    
    init(purchaseManager: PurchaseManager,
         product: ProductViewModel) {
        self.purchaseManager = purchaseManager
        self.product = product
    }
    
    /// Here we purchase selected course on web service
    /// - Parameter completion: Block of code that will be executed at the end
    func buySelectedCourse(completion: @escaping PurchaseCourseCompletion) {
        guard let storeProduct = product.storeProduct else { return }
            let purchaseCourseCompletion: PurchaseCourseCompletion = { [weak self] result in
                guard let self = self else { return }
                self.purchaseManager.purchaseCourseCompletion = nil
                completion(result)
            }
            self.purchaseManager.buyProduct(storeProduct: storeProduct, completion: purchaseCourseCompletion)
    }
    
}
