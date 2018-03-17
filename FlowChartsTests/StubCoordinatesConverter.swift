//
//  StubDiagramCoordinatesConverter.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
import DiagramView

class StubCoordinatesConverter: DiagramCoordinatesConverter {
    
    var diagramVector: Vector?
    
    init() {
        
    }
    
    func viewRect(for diagramRect: Rect, in view: UIView) -> CGRect {
        return CGRect(diagramRect)
    }
    
    func diagramRect(for viewRect: CGRect, in view: UIView) -> Rect {
        return Rect(viewRect)
    }
    
    func viewPoint(for diagramPoint: Point, in view: UIView) -> CGPoint {
        return CGPoint(diagramPoint)
    }
    
    var onDiagramPoint: ((CGPoint, UIView) -> Point)?
    
    func diagramPoint(for viewPoint: CGPoint, in view: UIView) -> Point {
        if let onDiagramPoint = onDiagramPoint {
            return onDiagramPoint(viewPoint, view)
        }
        return Point(viewPoint)
    }
    
    func viewVector(for diagramVector: Vector, in view: UIView) -> CGVector {
        return CGVector(diagramVector)
    }
    
    func diagramVector(for viewVector: CGVector, in view: UIView) -> Vector {
        return diagramVector ?? Vector(viewVector)
    }
    
    func viewPath(forDiagramPath path: BezierPath, in view: UIView) -> CGPath {
        return CGPath(path)
    }
}
