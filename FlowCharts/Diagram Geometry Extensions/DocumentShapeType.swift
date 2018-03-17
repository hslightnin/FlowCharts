//
//  DocumentShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class DocumentShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        
        let controlPointOffset = 0.3 * rect.height
        
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.maxY - 0.1 * rect.height))
        path.addCubicCurve(
            to: Point(rect.minX, rect.maxY - 0.1 * rect.height),
            control1: Point(rect.minX + 0.66 * rect.width, rect.maxY - 0.1 * rect.height - controlPointOffset),
            control2: Point(rect.minX + 0.33 * rect.width, rect.maxY - 0.1 * rect.height + controlPointOffset))
        path.close()
        
        return path
    }
}
