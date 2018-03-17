//
//  CircleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class CircleShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.midY))
        path.addQuadCurve(to: Point(rect.midX, rect.minY), control: Point(rect.minX, rect.minY))
        path.addQuadCurve(to: Point(rect.maxX, rect.midY), control: Point(rect.maxX, rect.minY))
        path.addQuadCurve(to: Point(rect.midX, rect.maxY), control: Point(rect.maxX, rect.maxY))
        path.addQuadCurve(to: Point(rect.minX, rect.midY), control: Point(rect.minX, rect.maxY))
        return path
    }
}
