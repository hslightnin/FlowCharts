//
//  RightTriangleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class RightTriangleShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.maxX, rect.midY))
        path.addLine(to: Point(rect.minX, rect.minY))
        path.addLine(to: Point(rect.minX, rect.maxY))
        path.close()
        return path
    }
}
