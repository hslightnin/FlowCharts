//
//  Vector.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Vector: Equatable {
    
    public var x: Double
    public var y: Double
    
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(point1: Point, point2: Point) {
        self.x = point2.x - point1.x
        self.y = point2.y - point1.y
    }
    
    public init() {
        self.init(0.0, 0.0)
    }
    
    public static let zero = Vector()
    
    public func rotated(by radians: Double) -> Vector {
        return Vector(x * cos(radians) - y * sin(radians),
                      x * sin(radians) + y * cos(radians))
    }
    
    public var unit: Vector {
        return Vector(x / sqrt(x * x + y * y),
                      y / sqrt(x * x + y * y))
    }
    
    public var length: Double {
        return sqrt(x * x + y * y)
    }
    
    public static func ==(lhs: Vector, rhs: Vector) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public static prefix func -(point: Vector) -> Vector {
        return Vector(-point.x, -point.y)
    }
    
    public static prefix func +(point: Vector) -> Vector {
        return point
    }
    
    public static func +(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    @discardableResult
    public static func +=(lhs: inout Vector, rhs: Vector) -> Vector {
        lhs = lhs + rhs
        return lhs
    }
    
    public static func -(lhs: Vector, rhs: Vector) -> Vector {
        return Vector(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    @discardableResult
    public static func -=(lhs: inout Vector, rhs: Vector) -> Vector {
        lhs = lhs - rhs
        return lhs
    }
    
    public static func *(lhs: Double, rhs: Vector) -> Vector {
        return Vector(rhs.x * lhs, rhs.y * lhs)
    }
    
    public static func *(lhs: Vector, rhs: Double) -> Vector {
        return rhs * lhs
    }
}

public extension CGVector {
    public init(_ vector: Vector) {
        self.init(dx: vector.x, dy: vector.y)
    }
}

public extension Vector {
    public init(_ vector: CGVector) {
        self.init(Double(vector.dx), Double(vector.dy))
    }
}
