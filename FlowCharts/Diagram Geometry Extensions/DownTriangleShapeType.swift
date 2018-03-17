//
//  DownTriangleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class DownTriangleShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.midX, rect.maxY))
        path.addLine(to: Point(rect.minX, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.minY))
        path.close()
        return path
    }
}
