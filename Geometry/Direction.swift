//
//  Direction.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public enum Direction: Int {
    
    case up
    case right
    case down
    case left
    
    public var vector: Vector {
        switch self {
        case .up:
            return Vector(0.0, -1.0)
        case .right:
            return Vector(1.0, 0.0)
        case .down:
            return Vector(0.0, 1.0)
        case .left:
            return Vector(-1.0, 0.0)
        }
    }
    
    public var isHorizontal: Bool {
        switch self {
        case .left, .right:
            return true
        default:
            return false
        }
    }
    
    public var isVertical: Bool {
        return !isHorizontal
    }
    
    public var opposite: Direction {
        switch self {
        case .up:
            return .down
        case .right:
            return .left
        case .down:
            return .up
        case .left:
            return .right
        }
    }
    
    public var rotatedClockwise: Direction {
        switch self {
        case .up:
            return .right
        case .right:
            return .down
        case .down:
            return .left
        case .left:
            return .up
        }
    }
    
    public var rotatedCounterClockwise: Direction {
        switch self {
        case .up:
            return .left
        case .right:
            return .up
        case .down:
            return .right
        case .left:
            return .down
        }
    }
    
    public func isOpposite(_ direction: Direction) -> Bool {
        switch self {
        case .up:
            return direction == .down
        case .right:
            return direction == .left
        case .down:
            return direction == .up
        case .left:
            return direction == .right
        }
    }
}
