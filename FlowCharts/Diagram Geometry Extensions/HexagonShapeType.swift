//
//  HexagonShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 18/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import DiagramGeometry

class HexagonShapeType: ShapeType {
    
    init() {
        
    }
    
    func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: Point(rect.minX, rect.midY))
        path.addLine(to: Point(rect.minX + 0.1 * rect.width, rect.minY))
        path.addLine(to: Point(rect.maxX - 0.1 * rect.width, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.midY))
        path.addLine(to: Point(rect.maxX - 0.1 * rect.width, rect.maxY))
        path.addLine(to: Point(rect.minX + 0.1 * rect.width, rect.maxY))
        path.close()
        return path
    }
}
