//
//  Rect.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Rect: Equatable {
    
    public var origin: Point
    public var size: Size
    
    public init() {
        self.origin = Point()
        self.size = Size()
    }
    
    public init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    public init(center: Point, size: Size) {
        self.origin = Point(center.x - size.width / 2, center.y - size.height / 2)
        self.size = size
    }
    
    public init(x: Double, y: Double, width: Double, height: Double) {
        self.origin = Point(x, y)
        self.size = Size(width, height)
    }
    
    public var center: Point {
        return Point(midX, midY)
    }
    
    public var width: Double {
        return size.width
    }
    
    public var height: Double {
        return size.height
    }
    
    public var minX: Double {
        return origin.x
    }
    
    public var midX: Double {
        return origin.x + width / 2
    }
    
    public var maxX: Double {
        return origin.x + width
    }
    
    public var minY: Double {
        return origin.y
    }
    
    public var midY: Double {
        return origin.y + height / 2
    }
    
    public var maxY: Double {
        return origin.y + height
    }
    
    public var topLeftPoint: Point {
        return Point(minX, minY)
    }
    
    public var topRightPoint: Point {
        return Point(maxX, minY)
    }
    
    public var bottomLeftPoint: Point {
        return Point(minX, maxY)
    }
    
    public var bottomRightPoint: Point {
        return Point(maxX, maxY)
    }
    
    public func insetBy(dx: Double, dy: Double) -> Rect {
        return Rect(x: minX + dx, y: minY + dx, width: width - 2 * dx, height: height - 2 * dy)
    }
    
    public func contains(_ point: Point) -> Bool {
        return point.x >= minX && point.x <= maxX && point.y >= minY && point.y <= maxY
    }
    
    public static func ==(lhs: Rect, rhs: Rect) -> Bool {
        return lhs.origin == rhs.origin && lhs.size == rhs.size
    }
    
    public static let zero = Rect()
}

public extension CGRect {
    public init(_ rect: Rect) {
        self.init(origin: CGPoint(rect.origin), size: CGSize(rect.size))
    }
}

public extension Rect {
    public init(_ rect: CGRect) {
        self.init(origin: Point(rect.origin), size: Size(rect.size))
    }
}
