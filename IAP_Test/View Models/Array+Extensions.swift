//
//  Array+Extensions.swift
//  SampleChart
//
//  Created by Strazdin, Valentin on 01.11.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation

extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        
        return result
    }
}
