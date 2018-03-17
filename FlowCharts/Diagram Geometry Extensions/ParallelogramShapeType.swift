//
//  ParallelogramShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class ParallelogramShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.maxY))
        path.addLine(to: Point(rect.minX + 0.3 * rect.height, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.minY))
        path.addLine(to: Point(rect.maxX - 0.3 * rect.height, rect.maxY))
        path.close()
        return path
    }
    
    func rightPoint(within rect: Rect) -> Point {
        return Point(rect.maxX - 0.15 * rect.height, rect.midY)
    }
    
    func leftPoint(within rect: Rect) -> Point {
        return Point(rect.minX + 0.15 * rect.height, rect.midY)
    }
}
