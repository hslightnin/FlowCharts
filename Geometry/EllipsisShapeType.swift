//
//  Ellipsis ShapeType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class EllipsisShapeType: ShapeType {
    
    public init() {
        
    }
    
    public func path(within rect: Rect) -> BezierPath {
        
        let minX = rect.minX
        let midX = rect.midX
        let maxX = rect.maxX
        let minY = rect.minY
        let midY = rect.midY
        let maxY = rect.maxY
        let width = rect.width
        let height = rect.height

        let xOffset = (width / 2) * Double.kappa
        let yOffset = (height / 2) * Double.kappa

        let path = BezierPath()
        path.move(to: Point(minX, midY))
        path.addCubicCurve(to:Point(midX, minY) , control1: Point(minX, midY - yOffset), control2: Point(midX - xOffset, minY))
        path.addCubicCurve(to: Point(maxX, midY), control1: Point(midX + xOffset, minY), control2: Point(maxX, midY - yOffset))
        path.addCubicCurve(to: Point(midX, maxY), control1: Point(maxX, midY + yOffset), control2: Point(midX + xOffset, maxY))
        path.addCubicCurve(to:Point(minX, midY) , control1: Point(midX - xOffset, maxY), control2: Point(minX, midY + yOffset))
        return path
    }
}
