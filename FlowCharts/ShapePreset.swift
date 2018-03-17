//
//  ShapePreset.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class ShapePreset {
    
    var shapeType: ShapeType {
        fatalError("Must be implemented in subclass")
    }
    
    var defaultSize: Size {
        return Size(74, 40)
    }
    
    var requiredWidthToHeightRatio: Double? {
        return nil
    }
    
    var preferredWidthToHeightRatio: Double? {
        return nil
    }
    
    func requiredSize(withConstraints constraints: Size) -> Size {
        if let ratio = requiredWidthToHeightRatio {
            return size(withConstraints: constraints, ratio: ratio)
        } else {
            return constraints
        }
    }
    
    func preferredSize(withConstraints constraints: Size) -> Size {
        if let ratio = requiredWidthToHeightRatio ?? preferredWidthToHeightRatio {
            return size(withConstraints: constraints, ratio: ratio)
        } else {
            return constraints
        }
    }
    
    private func size(withConstraints constraints: Size, ratio: Double) -> Size {
        var height = constraints.height
        var width = height * ratio
        if width > constraints.width {
            width = constraints.width
            height = width / ratio
        }
        return Size(width, height)
    }
    
    static func preset(withId id: Int) -> ShapePreset {
        switch (id) {
        case -1: return placeholder
        case 0: return circle
        case 1: return ellipsis
        case 2: return roundedSideRect
        case 3: return roundedCorderRect
        case 4: return rect
        case 5: return rhombus
        case 6: return hexagon
        case 7: return beveledTopCornerRect
        case 8: return parallelogram
        case 9: return document
        case 10: return database
        case 11: return storedData
        case 12: return upTriangle
        case 13: return downTriangle
        case 14: return rightTriangle
        case 15: return leftTriangle
        default: fatalError("Invalid symbol shape preset id \(id)")
        }
    }
    
    static func id(forPreset preset: ShapePreset) -> Int {
        switch (preset) {
        case let p where p === placeholder: return -1
        case let p where p === circle: return 0
        case let p where p === ellipsis: return 1
        case let p where p === roundedSideRect: return 2
        case let p where p === roundedCorderRect: return 3
        case let p where p === rect: return 4
        case let p where p === rhombus: return 5
        case let p where p === hexagon: return 6
        case let p where p === beveledTopCornerRect: return 7
        case let p where p === parallelogram: return 8
        case let p where p === document: return 9
        case let p where p === database: return 10
        case let p where p === storedData: return 11
        case let p where p === upTriangle: return 12
        case let p where p === downTriangle: return 13
        case let p where p === rightTriangle: return 14
        case let p where p === leftTriangle: return 15
        default: fatalError("Invalid symbol shape preset \(preset)")
        }
    }
    
    static let placeholder = PlaceholderShapePreset()
    static let circle = CircleShapePreset()
    static let ellipsis = EllipsisShapePreset()
    static let roundedSideRect = RoundedSideRectShapePreset()
    static let roundedCorderRect = RoundedCorderRectShapePreset()
    static let rect = RectShapePreset()
    static let rhombus = RhombusShapePreset()
    static let hexagon = HexagonShapePreset()
    static let beveledTopCornerRect = BeveledTopCornerRectShapePreset()
    static let parallelogram = ParallelogramShapePreset()
    static let document = DocumentShapePreset()
    static let database = DatabaseShapePreset()
    static let storedData = StoredDataShapePreset()
    static let upTriangle = UpTriangleShapePreset()
    static let downTriangle = DownTriangleShapePreset()
    static let rightTriangle = RightTriangleShapePreset()
    static let leftTriangle = LeftTriangleShapePreset()
    
    static let all: [ShapePreset] = [
        circle,
        ellipsis,
        roundedSideRect,
        roundedCorderRect,
        rect,
        rhombus,
        hexagon,
        beveledTopCornerRect,
        parallelogram,
        document,
        database,
        storedData,
        upTriangle,
        downTriangle,
        rightTriangle,
        leftTriangle
    ]
}
