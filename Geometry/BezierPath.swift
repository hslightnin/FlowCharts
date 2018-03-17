//
//  BezierPath.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreGraphics

enum BezierPathElement {
    case move(toPoint: Point)
    case addLine(toPoint: Point)
    case addQuadCurve(toPoint: Point, control: Point)
    case addCubucCurve(toPoint: Point, control1: Point, control2: Point)
    case close
}

public class BezierPath {
    
    private(set) var elements = [BezierPathElement]()
    
    public init() {
        
    }
    
    public init(curves: [BezierCurve]) {
        
        var currentPoint = Point()
        for curve in curves {
            
            if (curve.point1 != currentPoint) {
                move(to: curve.point1)
            }
            
            switch curve {
            case let linearCurve as LinearBezierCurve:
                addLine(to: linearCurve.point2)
            case let quadCurve as QuadraticBezierCurve:
                addQuadCurve(to: quadCurve.point2, control: quadCurve.controlPoint)
            case let cubicCurve as CubicBezierCurve:
                addCubicCurve(to: cubicCurve.point2, control1: cubicCurve.controlPoint1, control2: cubicCurve.controlPoint2)
            default:
                break
            }
            
            currentPoint = curve.point2
        }
    }
    
    public func copy() -> BezierPath {
        let copyPath = BezierPath()
        copyPath.elements = elements
        return copyPath
    }
    
    public func move(to point: Point) {
        elements.append(.move(toPoint: point))
    }
    
    public func addLine(to point: Point) {
        elements.append(.addLine(toPoint: point))
    }
    
    public func addQuadCurve(to point: Point, control: Point) {
        elements.append(.addQuadCurve(toPoint: point, control: control))
    }
    
    public func addCubicCurve(to point: Point, control1: Point, control2: Point) {
        elements.append(.addCubucCurve(toPoint: point, control1: control1, control2: control2))
    }
    
    public func close() {
        elements.append(.close)
    }
    
    public func append(path: BezierPath) {
        for curve in path.curves {
            append(curve: curve)
        }
    }
    
    public func appending(path: BezierPath) -> BezierPath {
        let newPath = BezierPath()
        newPath.elements += elements
        newPath.elements += path.elements
        return newPath
    }
    
    public var curves: [BezierCurve] {
        
        var curvers = [BezierCurve]()
        
        var currentPoint = Point()
        var currentSubPathOrigin = Point()
        
        self.elements.forEach { element in
            switch element {
            case .move(let point):
                currentPoint = point
                currentSubPathOrigin = point
            case .addLine(let point):
                curvers.append(LinearBezierCurve(point1: currentPoint, point2: point))
                currentPoint = point
            case .addQuadCurve(let point, let control):
                curvers.append(QuadraticBezierCurve(point1: currentPoint, controlPoint: control, point2: point))
                currentPoint = point
            case .addCubucCurve(let point, let control1, let control2):
                curvers.append(CubicBezierCurve(point1: currentPoint, controlPoint1: control1, controlPoint2: control2, point2: point))
                currentPoint = point
            case .close:
                curvers.append(LinearBezierCurve(point1: currentPoint, point2: currentSubPathOrigin))
                currentPoint = currentSubPathOrigin
            }
        }
        
        return curvers
    }
    
    public var origin: Point {
        return curves.first?.point1 ?? Point(0, 0)
    }
    
    public var ending: Point {
        return curves.last?.point2 ?? Point(0, 0)
    }
    
    public func split(atCurveWithIndex curveIndex: Int, t: Double) -> (BezierPath, BezierPath) {
        
        let path1 = BezierPath()
        let path2 = BezierPath()
        
        for (idx, curve) in curves.enumerated() {
            if idx < curveIndex {
                path1.append(curve: curve)
            } else if idx == curveIndex {
                let (curve1, curve2) = curve.split(at: t)
                path1.append(curve: curve1)
                path2.append(curve: curve2)
            } else {
                path2.append(curve: curve)
            }
        }
        
        return (path1, path2)
    }
    
    public func append(curve: BezierCurve) {
        
        if (curve.point1 != ending) {
            move(to: curve.point1)
        }
        
        switch curve {
        case let linearCurve as LinearBezierCurve:
            addLine(to: linearCurve.point2)
        case let quadCurve as QuadraticBezierCurve:
            addQuadCurve(to: quadCurve.point2, control: quadCurve.controlPoint)
        case let cubicCurve as CubicBezierCurve:
            addCubicCurve(to: cubicCurve.point2, control1: cubicCurve.controlPoint1, control2: cubicCurve.controlPoint2)
        default:
            break
        }
    }
}

public func CGPath(_ path: BezierPath) -> CGPath {
    
    let cgPath = CGMutablePath()
    for element in path.elements {
        switch element {
            
        case .move(let point):
            cgPath.move(to: CGPoint(point))
            
        case .addLine(let point):
            cgPath.addLine(to: CGPoint(point))
            
        case .addQuadCurve(let point, let control):
            cgPath.addQuadCurve(to: CGPoint(point), control: CGPoint(control))
            
        case .addCubucCurve(let point, let control1, let control2):
            cgPath.addCurve(to: CGPoint(point), control1: CGPoint(control1), control2: CGPoint(control2))
            
        case .close:
            cgPath.closeSubpath()
        }
    }
    return cgPath
}
