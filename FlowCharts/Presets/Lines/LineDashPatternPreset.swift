//
//  LineDashPatternPreset.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 12/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

class LineDashPatternPreset {
    
    let thumbnailPattern: [Double]
    let pattern: [Double]
    
    init(thumbnailPattern: [Double], pattern: [Double]) {
        self.thumbnailPattern = thumbnailPattern
        self.pattern = pattern
    }
    
    static func preset(withId id: Int) -> LineDashPatternPreset {
        switch (id) {
        case 0: return solid
        case 1: return small
        case 2: return medium
        case 3: return large
        default: fatalError("Invalid line dash pattern id \(id)")
        }
    }
    
    static func id(forPreset preset: LineDashPatternPreset) -> Int {
        switch (preset) {
        case let p where p === solid: return 0
        case let p where p === small: return 1
        case let p where p === medium: return 2
        case let p where p === large: return 3
        default: fatalError("Invalid line dash pattern preset \(preset)")
        }
    }
    
    static let solid = LineDashPatternPreset(thumbnailPattern: [], pattern: [])
    static let small = LineDashPatternPreset(thumbnailPattern: [0.5, 2.0], pattern: [0.01, 2.0])
    static let medium = LineDashPatternPreset(thumbnailPattern: [3.0, 2.0], pattern: [3.0, 3.0])
    static let large = LineDashPatternPreset(thumbnailPattern: [5.0, 5.0], pattern: [7.0, 7.0])
    
    static let all: [LineDashPatternPreset] = [
        solid,
        large,
        medium,
        small
    ]
}
