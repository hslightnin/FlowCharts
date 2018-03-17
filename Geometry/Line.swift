//
//  Line.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

// a * x + b * y + c = 0
public struct Line {
    
    public var a: Double
    public var b: Double
    public var c: Double
    
    public init(a: Double, b: Double, c: Double) {
        self.a = a
        self.b = b
        self.c = c
    }
    
    public init?(point1: Point, point2: Point) {
        
        if point1 == point2 {
            return nil
        }
        
        self.init(a: point1.y - point2.y,
                  b: point2.x - point1.x,
                  c: point1.x * point2.y - point2.x * point1.y)
    }
}
