//
//  Course.swift
//  MathBooster
//
//  Created by Strazdin, Valentin on 21.10.2019.
//  Copyright © 2019 Strazdin, Valentin. All rights reserved.
//

import Foundation
import UIKit

public class Course: Codable, Equatable {
    var id: Int
    var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    public static func == (lhs: Course, rhs: Course) -> Bool {
        return (lhs.id == rhs.id)
    }
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Course: Comparable {
    
    /// Here we compare courses names and difficulty
    /// - Parameters:
    ///   - lhs: left hand side course
    ///   - rhs: right hand side course
    public static func < (lhs: Course, rhs: Course) -> Bool {
        return (lhs.name < rhs.name)
    }

}
