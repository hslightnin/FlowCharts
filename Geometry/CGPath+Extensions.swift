//
//  CGPath+Extensions.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 11/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import CoreGraphics

fileprivate enum PathElement {
    
    case move(toPoint: CGPoint)
    case addLine(toPoint: CGPoint)
    case addQuadCurve(toPoint: CGPoint, control: CGPoint)
    case addCubucCurve(toPoint: CGPoint, control1: CGPoint, control2: CGPoint)
    case close
    
    init(_ element: CGPathElement) {
        switch element.type {
        case .moveToPoint:
            self = .move(toPoint: element.points[0])
        case .addLineToPoint:
            self = .addLine(toPoint: element.points[0])
        case .addQuadCurveToPoint:
            self = .addQuadCurve(toPoint: element.points[0], control: element.points[1])
        case .addCurveToPoint:
            self = .addCubucCurve(toPoint: element.points[0], control1: element.points[1], control2: element.points[2])
        case .closeSubpath:
            self = .close
        }
    }
}

public extension CGPath {
    
    private var elements: [PathElement] {
        var elements = [PathElement]()
        withUnsafeMutablePointer(to: &elements) { elementsPtr in
            let rawElementsPtr = UnsafeMutableRawPointer(elementsPtr)
            apply(info: rawElementsPtr) { infoPtr, elementPtr in
                let elementsPtr = infoPtr?.assumingMemoryBound(to: [PathElement].self)
                elementsPtr?.pointee.append(PathElement(elementPtr.pointee))
            }
        }
        return elements
    }
    
    var origin: CGPoint {
        if let firstElement = elements.first {
            switch firstElement {
            case .move(let point):
                return point
            default:
                return .zero
            }
        } else {
            return currentPoint
        }
    }
    
    var ending: CGPoint {
        return currentPoint
    }
}
