//
//  RoundedSideRectShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class RoundedSideRectShapeType: ShapeType {
    
    public init() {
        
    }
    
    public func path(within rect: Rect) -> BezierPath {
        
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
        let r = min(rect.height, rect.width) / 2
        
        let path = BezierPath()
        path.move(to: Point(minX, minY + r))
        path.addQuadCurve(to: Point(minX + r, minY), control: Point(minX, minY))
        path.addLine(to: Point(maxX - r, minY))
        path.addQuadCurve(to: Point(maxX, minY + r), control: Point(maxX, minY))
        path.addLine(to: Point(maxX, maxY - r))
        path.addQuadCurve(to: Point(maxX - r, maxY), control: Point(maxX, maxY))
        path.addLine(to: Point(minX + r, maxY))
        path.addQuadCurve(to: Point(minX, maxY - r), control: Point(minX, maxY))
        path.close()
        
        return path
    }
}
