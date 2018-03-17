//
//  ThinArrowPointerType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class ThinArrowPointerType: PointerType {
    
    public init() {
    }
    
    public func path(withLocation location: Point, direction: Vector, size: Size) -> BezierPath {
        
        let tail = location.translated(by: -direction.unit * size.width)
        
        let sideTranslation = direction.rotated(by: Double.pi / 2).unit * (size.height / 2)
        let side1Point = tail.translated(by: +sideTranslation)
        let side2Point = tail.translated(by: -sideTranslation)
        
        let path = BezierPath()
        
        path.move(to: location)
        path.addLine(to: side1Point)
        path.move(to: location)
        path.addLine(to: side2Point)
        return path
    }
    
    public func tail(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location
    }
    
    public func head(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location
    }
}
