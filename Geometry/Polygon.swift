//
//  Polygon.swift
//  FlowCharts
//
//  Created by alex on 21/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

public struct Polygon {
    
    public let points: [Point]
    
    public init(_ points: [Point]) {
        self.points = points
    }
    
    public init(_ points: Point...) {
        self.points = points
    }
    
    public func contains(point: Point) -> Bool {
        var contains = false
        var j = points.count - 1
        for i in 0..<points.count {
            if points[i].y < point.y && points[j].y >= point.y || points[j].y < point.y && points[i].y >= point.y {
                if points[i].x + (point.y - points[i].y) / (points[j].y - points[i].y) * (points[j].x - points[i].x) < point.x {
                    contains = !contains
                }
            }
            j = i
        }
        return contains
    }
}

public extension BezierPath {
    convenience init(_ polygon: Polygon) {
        self.init()
        for (idx, point) in polygon.points.enumerated() {
            if idx == 0 {
                move(to: point)
            } else {
                addLine(to: point)
            }
        }
        close()
    }
}
