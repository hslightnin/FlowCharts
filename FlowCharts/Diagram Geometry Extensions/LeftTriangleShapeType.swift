//
//  LeftTriangleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class LeftTriangleShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.midY))
        path.addLine(to: Point(rect.maxX, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.maxY))
        path.close()
        return path
    }
}
