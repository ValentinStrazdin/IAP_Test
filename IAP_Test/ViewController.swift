//
//  ViewController.swift
//  IAP_Test
//
//  Created by Strazdin, Valentin on 28.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import UIKit
import StoreKit

class ViewController: UIViewController {
    let consumableID: ProductIdentifier = "consumableID"
    let nonConsumableID: ProductIdentifier = "nonConsumableID"
    
    // Keep a strong reference to the product request.
    var request: SKProductsRequest!
    var products = [SKProduct]()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validate(productIdentifiers: [consumableID, nonConsumableID])
    }
    
    func validate(productIdentifiers: [String]) {
         let productIdentifiers = Set(productIdentifiers)

    }

}
