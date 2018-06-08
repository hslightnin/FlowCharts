//
//  LinePreset.swift
//  FlowCharts
//
//  Created by alex on 08/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class LineTypePreset {
    
    var lineType: LineType {
        fatalError("Must be implemented in subclass")
    }
    
    var thumbnailLineType: LineType {
        fatalError("Must be implemented in subclass")
    }
    
    static func preset(withId id: Int) -> LineTypePreset {
        switch (id) {
        case 0: return straight
        case 1: return curved
        case 2: return poly
        case 3: return zigzag
        default: fatalError("Invalid line type preset id \(id)")
        }
    }
    
    static func id(forPreset preset: LineTypePreset) -> Int {
        switch (preset) {
        case let p where p === straight: return 0
        case let p where p === curved: return 1
        case let p where p === poly: return 2
        case let p where p === zigzag: return 3
        default: fatalError("Invalid line type preset \(preset)")
        }
    }
    
    static let straight = StraightLinePreset()
    static let curved = CurvedLinePreset()
    static let poly = PolyLinePreset()
    static let zigzag = ZigzagLinePreset()
    
    static let all: [LineTypePreset] = [
        straight,
        curved,
        poly,
        zigzag
    ]
}
