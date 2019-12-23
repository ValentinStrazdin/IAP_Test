//
//  SKProduct+Extension.swift
//  MathBooster
//
//  Created by Valentin Strazdin on 23.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import StoreKit

extension SKProduct {
    
    var localizedPrice: String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)
    }
}
