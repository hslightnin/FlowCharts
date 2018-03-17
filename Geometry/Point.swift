//
//  Point.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 30/05/17.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Point: Equatable {
    
    public var x: Double
    public var y: Double
    
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    public init() {
        self.init(0.0, 0.0)
    }
    
    public static let zero = Point()
    
    public mutating func translate(by translation: Vector) {
        x += translation.x
        y += translation.y
    }
    
    public func translated(by translation: Vector) -> Point {
        return Point(x + translation.x, y + translation.y)
    }
    
    public func distance(to point: Point) -> Double {
        return sqrt((point.x - x) * (point.x - x) + (point.y - y) * (point.y - y))
    }
    
    public static func ==(lhs: Point, rhs: Point) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }

    public static prefix func -(point: Point) -> Point {
        return Point(-point.x, -point.y)
    }
    
    public static prefix func +(point: Point) -> Point {
        return point
    }
    
    public static func +(lhs: Point, rhs: Point) -> Point {
        return Point(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    @discardableResult
    public static func +=(lhs: inout Point, rhs: Point) -> Point {
        lhs = lhs + rhs
        return lhs
    }
    
    public static func -(lhs: Point, rhs: Point) -> Point {
        return Point(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    @discardableResult
    public static func -=(lhs: inout Point, rhs: Point) -> Point {
        lhs = lhs - rhs
        return lhs
    }
    
    public static func *(lhs: Double, rhs: Point) -> Point {
        return Point(rhs.x * lhs, rhs.y * lhs)
    }
    
    public static func *(lhs: Point, rhs: Double) -> Point {
        return rhs * lhs
    }
    
    @discardableResult
    public static func *=(lhs: inout Point, rhs: Double) -> Point {
        lhs = lhs * rhs
        return lhs
    }
}

public extension CGPoint {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
    }
}

public extension Point {
    init(_ point: CGPoint) {
        self.init(Double(point.x), Double(point.y))
    }
}
