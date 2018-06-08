//
//  PointerPreset.swift
//  FlowCharts
//
//  Created by alex on 14/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView

class PointerPreset {
    
    // MARK: - Diagram
    
    var pointerType: PointerType {
        return EmptyPointerType()
    }
    
    var pointerSize: Size {
        return Size(8, 6)
    }
    
    var pointerFillPattern: LinkPointerFillPattern {
        return .none
    }
    
    var minPointerTailLength: Double {
        return 9
    }
    
    // MARK: - Thumbnail
    
    var tumbnailArrowWidth: Double {
        return 38
    }
    
    var thumbnailPointerSize: Size {
        return Size(16, 12)
    }
    
    // MARK: - Button
    
    var buttonPointerType: PointerType {
        return pointerType
    }
    
    var buttonArrowLength: Double {
        return 16
    }
    
    var buttonPointerSize: Size {
        return Size(10.5, 8)
    }
    
    static func preset(withId id: Int) -> PointerPreset {
        switch (id) {
        case 0: return empty
        case 1: return thinArrow
        case 2: return strokedThickArrow
        case 3: return filledThickArrow
        case 4: return strokedTriangle
        case 5: return filledTriangle
        case 6: return strokedCircle
        case 7: return filledCircle
        default: fatalError("Invalid pointer preset id \(id)")
        }
    }
    
    static func id(forPreset preset: PointerPreset) -> Int {
        switch (preset) {
        case let p where p === empty: return 0
        case let p where p === thinArrow: return 1
        case let p where p === strokedThickArrow: return 2
        case let p where p === filledThickArrow: return 3
        case let p where p === strokedTriangle: return 4
        case let p where p === filledTriangle: return 5
        case let p where p === strokedCircle: return 6
        case let p where p === filledCircle: return 7
        default: fatalError("Invalid pointer preset \(preset)")
        }
    }
    
    static let empty = EmptyPointerPreset()
    static let thinArrow = ThinArrowPointerPreset()
    static let strokedThickArrow = StrokedThickArrowPointerPreset()
    static let filledThickArrow = FilledThickArrowPointerPreset()
    static let strokedTriangle = StrokedTrianglePointerPreset()
    static let filledTriangle = FilledTrianglePointerPreset()
    static let strokedCircle = StrokedCirclePointerPreset()
    static let filledCircle = FilledCirclePointerPreset()
    
    static let all: [PointerPreset] = [
        empty,
        thinArrow,
        strokedThickArrow,
        filledThickArrow,
        strokedTriangle,
        filledTriangle,
        strokedCircle,
        filledCircle
    ]
}
