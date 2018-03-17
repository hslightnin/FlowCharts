//
//  BeveledTopCornerRectShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class BeveledTopCornerRectShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        
        let cornerOffset = min(0.2 * rect.height, 8)
        
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.minY + cornerOffset))
        path.addLine(to: Point(rect.minX + cornerOffset, rect.minY))
        path.addLine(to: Point(rect.maxX - cornerOffset, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.minY + cornerOffset))
        path.addLine(to: Point(rect.maxX, rect.maxY))
        path.addLine(to: Point(rect.minX, rect.maxY))
        path.close()
        return path
    }
}
