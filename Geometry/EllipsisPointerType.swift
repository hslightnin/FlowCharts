//
//  EllipsisPointerType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class EllipsisPointerType: PointerType {
    
    public init() {
        
    }
    
    public func path(withLocation location: Point, direction: Vector, size: Size) -> BezierPath {
        
        let sideTranslation = direction.rotated(by: Double.pi / 2).unit * (size.height / 2)
        let directionTranslation = direction.unit * (size.width / 2)
        
        let path = BezierPath()

        let destination0 = location.translated(by: -directionTranslation)
        path.move(to: destination0)
        
        let destination1 = location.translated(by: sideTranslation)
        path.addCubicCurve(to: destination1,
                           control1: destination0.translated(by: .kappa * sideTranslation),
                           control2: destination1.translated(by: -.kappa * directionTranslation))
        
        let destination2 = location.translated(by: directionTranslation)
        path.addCubicCurve(to: destination2,
                           control1: destination1.translated(by: .kappa * directionTranslation),
                           control2: destination2.translated(by: .kappa * sideTranslation))

        let destination3 = location.translated(by: -sideTranslation)
        path.addCubicCurve(to: destination3,
                           control1: destination2.translated(by: -.kappa * sideTranslation),
                           control2: destination3.translated(by: .kappa * directionTranslation))

        path.addCubicCurve(to: destination0,
                           control1: destination3.translated(by: -.kappa * directionTranslation),
                           control2: destination0.translated(by: -.kappa * sideTranslation))
        return path
    }
    
    public func tail(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location.translated(by: -0.5 * direction.unit * size.width)
    }
    
    public func head(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location.translated(by: +0.5 * direction.unit * size.width)
    }
}
