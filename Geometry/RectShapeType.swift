//
//  RectangleShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class RectShapeType: ShapeType {
    
    public init() {
        
    }
    
    public func path(within rect: Rect) -> BezierPath {
        let path = BezierPath()
        path.move(to: rect.origin)
        path.addLine(to: Point(rect.maxX, rect.minY))
        path.addLine(to: Point(rect.maxX, rect.maxY))
        path.addLine(to: Point(rect.minX, rect.maxY))
        path.close()
        return path
    }
}
