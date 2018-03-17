//
//  DiagramCoordinatesConverter.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

public protocol DiagramCoordinatesConverter: class {
    
    func viewRect(for diagramRect: Rect, in view: UIView) -> CGRect
    func diagramRect(for viewRect: CGRect, in view: UIView) -> Rect
    
    func viewPoint(for diagramPoint: Point, in view: UIView) -> CGPoint
    func diagramPoint(for viewPoint: CGPoint, in view: UIView) -> Point
    
    func viewVector(for diagramVector: Vector, in view: UIView) -> CGVector
    func diagramVector(for viewVector: CGVector, in view: UIView) -> Vector
    
    func viewPath(forDiagramPath path: BezierPath, in view: UIView) -> CGPath
    // func diagramPath(forViewPath path: CGPath, in view: UIView) -> CGPath 
}
