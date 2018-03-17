//
//  EmptyPointerType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class EmptyPointerType: PointerType {
    
    public init() {
        
    }
    
    public func path(withLocation location: Point, direction: Vector, size: Size) -> BezierPath {
        let path = BezierPath()
        path.move(to: tail(withLocation: location, direction: direction, size: size))
        path.addLine(to: location)
        return path
    }
    
    public func tail(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location.translated(by: -direction.unit * size.width)
    }
    
    public func head(withLocation location: Point, direction: Vector, size: Size) -> Point {
        return location
    }
}
