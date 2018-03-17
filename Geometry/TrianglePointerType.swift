
//
//  TrianglePointerType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class TrianglePointerType: PointerType {
    
    public init() {
        
    }
    
    public func path(withLocation location: Point, direction: Vector, size: Size) -> BezierPath {
        
        let tail = self.tail(withLocation: location, direction: direction, size: size)
        
        let sideTranslation = direction.rotated(by: Double.pi / 2).unit * (size.height / 2)
        let side1Point = tail.translated(by: +sideTranslation)
        let side2Point = tail.translated(by: -sideTranslation)
        
        let path = BezierPath()
        path.move(to: side1Point)
        path.addLine(to: location)
        path.addLine(to: side2Point)
        path.close()
        return path
    }
    
    public func tail(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location.translated(by: -direction.unit * size.width)
    }
    
    public func head(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location
    }
}
