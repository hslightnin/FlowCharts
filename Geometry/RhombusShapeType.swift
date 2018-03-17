//
//  RhombusShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class RhombusShapeType: ShapeType {
    
    public init() {
        
    }
    
    public func path(within rect: Rect) -> BezierPath {
        
        let minX = rect.minX
        let midX = rect.midX
        let maxX = rect.maxX
        let minY = rect.minY
        let midY = rect.midY
        let maxY = rect.maxY
        
        let path = BezierPath()
        path.move(to: Point(minX, midY))
        path.addLine(to: Point(midX, minY))
        path.addLine(to: Point(maxX, midY))
        path.addLine(to: Point(midX, maxY))
        path.close()
        
        return path
    }
}
