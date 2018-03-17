//
//  StoredDataShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class StoredDataShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        
        let cornerOffset = 0.16 * rect.width
        let controlPointOffset = 0.2 * rect.width
        
        let path = BezierPath()
        path.move(to: Point(rect.maxX - cornerOffset, rect.minY))
        path.addCubicCurve(
            to: Point(rect.maxX - cornerOffset, rect.maxY),
            control1: Point(rect.maxX - cornerOffset - controlPointOffset, rect.minY + 0.1 * rect.height),
            control2: Point(rect.maxX - cornerOffset - controlPointOffset, rect.minY + 0.9 * rect.height))
        path.addLine(to: Point(rect.minX + cornerOffset, rect.maxY))
        path.addCubicCurve(
            to: Point(rect.minX + cornerOffset, rect.minY),
            control1: Point(rect.minX + cornerOffset - controlPointOffset, rect.minY + 0.9 * rect.height),
            control2: Point(rect.minX + cornerOffset - controlPointOffset, rect.minY + 0.1 * rect.height))
        path.close()

        path.move(to: Point(rect.maxX - cornerOffset, rect.minY))
        path.addCubicCurve(
            to: Point(rect.maxX - cornerOffset, rect.maxY),
            control1: Point(rect.maxX - cornerOffset - controlPointOffset, rect.minY + 0.1 * rect.height),
            control2: Point(rect.maxX - cornerOffset - controlPointOffset, rect.minY + 0.9 * rect.height))
        path.addCubicCurve(
            to: Point(rect.maxX - cornerOffset, rect.minY),
            control1: Point(rect.maxX - cornerOffset + controlPointOffset, rect.minY + 0.9 * rect.height),
            control2: Point(rect.maxX - cornerOffset + controlPointOffset, rect.minY + 0.1 * rect.height))
        path.close()
        
        return path
    }
    
    func textPath(within rect: Rect) -> BezierPath {
        
        let cornerOffset = 0.16 * rect.width
        let controlPointOffset = 0.2 * rect.width
        
        let path = BezierPath()
        path.move(to: Point(rect.minX + cornerOffset, rect.minY))
        path.addLine(to: Point(rect.maxX - cornerOffset - controlPointOffset, rect.minY))
        path.addLine(to: Point(rect.maxX - cornerOffset - controlPointOffset, rect.maxY))
        path.addLine(to: Point(rect.minX + cornerOffset, rect.maxY))
        path.close()
        
        return path
    }
}
