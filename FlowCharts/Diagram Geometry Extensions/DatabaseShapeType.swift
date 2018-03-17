//
//  DatabaseShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class DatabaseShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        
        let cornerOffset = 0.16 * rect.height
        let controlPointOffset =  0.2 * rect.height

        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.minY + cornerOffset))
        path.addCubicCurve(
            to: Point(rect.maxX, rect.minY + cornerOffset),
            control1: Point(rect.minX + 0.1 * rect.width, rect.minY + cornerOffset + controlPointOffset),
            control2: Point(rect.minX + 0.9 * rect.width, rect.minY + cornerOffset + controlPointOffset))
        path.addLine(to: Point(rect.maxX, rect.maxY - cornerOffset))
        path.addCubicCurve(
            to: Point(rect.minX, rect.maxY - cornerOffset),
            control1: Point(rect.minX + 0.9 * rect.width, rect.maxY - cornerOffset + controlPointOffset),
            control2: Point(rect.minX + 0.1 * rect.width, rect.maxY - cornerOffset + controlPointOffset))
        path.close()

        path.move(to: Point(rect.minX, rect.minY + cornerOffset))
        path.addCubicCurve(
            to: Point(rect.maxX, rect.minY + cornerOffset),
            control1: Point(rect.minX + 0.1 * rect.width, rect.minY + cornerOffset - controlPointOffset),
            control2: Point(rect.minX + 0.9 * rect.width, rect.minY + cornerOffset - controlPointOffset))
        path.addCubicCurve(
            to: Point(rect.minX, rect.minY + cornerOffset),
            control1: Point(rect.minX + 0.9 * rect.width, rect.minY + cornerOffset + controlPointOffset),
            control2: Point(rect.minX + 0.1 * rect.width, rect.minY + cornerOffset + controlPointOffset))
        path.close()

        return path
    }
    
    func textPath(within rect: Rect) -> BezierPath {
        
        let cornerOffset = 0.16 * rect.height
        let controlPointOffset =  0.2 * rect.height
        
        let path = BezierPath()
        
        path.move(to: Point(rect.minX, rect.minY + cornerOffset + controlPointOffset))
        path.addLine(to: Point(rect.maxX, rect.minY + cornerOffset + controlPointOffset))
        path.addLine(to: Point(rect.maxX, rect.maxY - cornerOffset))
        path.addLine(to: Point(rect.minX, rect.maxY - cornerOffset))
        
//        path.move(to: Point(rect.minX, rect.minY + cornerOffset + controlPointOffset))
//        path.addLine(to: Point(rect.maxX, rect.minY + cornerOffset + controlPointOffset))
//        path.addLine(to: Point(rect.maxX, rect.maxY - cornerOffset - controlPointOffset))
//        path.addLine(to: Point(rect.minX, rect.maxY - cornerOffset - controlPointOffset))
        
        path.close()
        
        return path
    }
}
