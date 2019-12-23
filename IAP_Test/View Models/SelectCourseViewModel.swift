//
//  SelectCourseViewModel.swift
//  MathBooster
//
//  Created by Valentin Strazdin on 17.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

public class SelectCourseViewModel: HasStoreKitService {
    public let storeKitService: StoreKitServiceProtocol
    
    public var products: [ProductViewModel] = []
    
    init(storeKitService: StoreKitServiceProtocol) {
        self.storeKitService = storeKitService
    }
    
    func getProducts(completion: @escaping CustomCompletion) {
        let storeProductsCompletion: StoreProductsCompletion = { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let storeProducts):
                for storeProduct in storeProducts {
                    self.products.filter({ $0.priceCategory == storeProduct.productIdentifier }).forEach({
                        $0.storeProduct = storeProduct
                    })
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.storeKitService.getStoreProducts(productIdentifiers: self.products.productIdentifiers,
                                              completion: storeProductsCompletion)
    }
    
}
