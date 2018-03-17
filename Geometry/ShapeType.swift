//
//  ShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public protocol ShapeType {
    func path(within rect: Rect) -> BezierPath
    func textPath(within rect: Rect) -> BezierPath
    func topPoint(within rect: Rect) -> Point
    func bottomPoint(within rect: Rect) -> Point
    func rightPoint(within rect: Rect) -> Point
    func leftPoint(within rect: Rect) -> Point
}

public extension ShapeType {
    
    func textPath(within rect: Rect) -> BezierPath {
        return path(within: rect)
    }
    
    func topPoint(within rect: Rect) -> Point {
        return Point(rect.midX, rect.minY)
    }
    
    func bottomPoint(within rect: Rect) -> Point {
        return Point(rect.midX, rect.maxY)
    }
    
    func rightPoint(within rect: Rect) -> Point {
        return Point(rect.maxX, rect.midY)
    }
    
    func leftPoint(within rect: Rect) -> Point {
        return Point(rect.minX, rect.midY)
    }
}
