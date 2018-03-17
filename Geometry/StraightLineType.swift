//
//  StraightLineType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class StraightLineType: LineType {
    
    public init() {
        
    }
    
    public func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        let path = BezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        return path
    }
    
    public func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int {
        return 0
    }
}
