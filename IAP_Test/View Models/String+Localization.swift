//
//  String+Localization.swift
//  MathBooster
//
//  Created by Strazdin, Valentin on 11.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

// If you use just a Localizable.strings file for the whole project, I would suggest you to split in subfiles to clean your strings.
// If the string is not found, we show **<key>** for debugging.
import Foundation

extension String {
    func localized(tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
