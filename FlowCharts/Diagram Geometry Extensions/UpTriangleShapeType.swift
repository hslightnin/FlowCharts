//
//  UpTriangleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class UpTriangleShapeType: ShapeType {
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.midX, rect.minY))
        path.addLine(to: Point(rect.minX, rect.maxY))
        path.addLine(to: Point(rect.maxX, rect.maxY))
        path.close()
        return path
    }
    
    func textPath(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        
//        path.move(to: Point(rect.midX, rect.minY + 3))
//        path.addLine(to: Point(rect.minX + 3, rect.maxY))
//        path.addLine(to: Point(rect.maxX - 3, rect.maxY))
        
        path.move(to: Point(rect.minX + 0.33 * rect.width + 5, rect.minY + rect.height * 0.33))
        path.addLine(to: Point(rect.maxX - 0.33 * rect.width - 5, rect.minY + rect.height * 0.33))
        path.addLine(to: Point(rect.maxX - 5, rect.maxY))
        path.addLine(to: Point(rect.minX + 5, rect.maxY))
        
        path.close()
        return path
    }
}
