//
//  Arrow.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreText

public class Arrow {

    public var point1 = Point()
    public var direction1 = Direction.left
    public var pointer1Size = Size()
    public var pointer1Type: PointerType = EmptyPointerType()
    public var minPointer1TailLength: Double = 0
    
    public var point2 = Point()
    public var direction2 = Direction.right
    public var pointer2Size = Size()
    public var pointer2Type: PointerType = EmptyPointerType()
    public var minPointer2TailLength: Double = 0
    
    public var lineType: LineType = StraightLineType()
    
    public var text: NSAttributedString?
    public var maxTextWidth = Double.infinity
    
    public init() {
        
    }
    
    public var center: Point {
        
        let curves = linePathWithoutText.curves
        
        let centerCurveIndex = lineType.centerCurveIndex(
            point1: linePoint1,
            direction1: direction1,
            point2: linePoint2,
            direction2: direction2)
        
        return curves[centerCurveIndex][0.5]
    }
    
    public var path: BezierPath {
        return linePath.appending(path: pointer1Path).appending(path: pointer2Path)
    }
    
    public var linePath: BezierPath {
        
        let path = BezierPath()
        path.move(to: pointer1Tail)
        path.addLine(to: linePoint1)
        
        if text != nil && text!.length > 0 {
            path.append(path: linePathWithText)
        } else {
            path.append(path: linePathWithoutText)
        }
        
        path.addLine(to: pointer2Tail)
        return path
    }
    
    public var pointer1Path: BezierPath {
        return pointer1Type.path(
            withLocation: point1,
            direction: vector1,
            size: pointer1Size)
    }
    
    public var pointer2Path: BezierPath {
        return pointer2Type.path(
            withLocation: point2,
            direction: vector2,
            size: pointer2Size)
    }
    
    public var textRect: Rect? {
        
        guard text != nil && text!.length > 0 else {
            return nil
        }
        
        let linePoint1 = pointer1Type.tail(withLocation: point1, direction: direction1.vector, size: pointer1Size)
        let linePoint2 = pointer2Type.tail(withLocation: point2, direction: direction2.vector, size: pointer2Size)
        
        let linePath = linePathWithoutText
        
        let centerCurveIndex = lineType.centerCurveIndex(
            point1: linePoint1,
            direction1: direction1,
            point2: linePoint2,
            direction2: direction2)
        
        let curves = linePath.curves
        let centerCurve = curves[centerCurveIndex]
        let center = centerCurve.point(at: 0.5)
        
        let framesetter = CTFramesetterCreateWithAttributedString(self.text!)
        let constraints = CGSize(width: CGFloat(maxTextWidth), height: CGFloat.infinity)
        
        var textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(), nil, constraints, nil)
        textSize.width += 5
        textSize.height += 5
        
        let textRect = Rect(
            x: center.x - Double(textSize.width) / 2,
            y: center.y - Double(textSize.height) / 2,
            width: Double(textSize.width),
            height: Double(textSize.height))
        
        return textRect
    }
    
    public var vector1: Vector {
        if lineType is StraightLineType && point1 != point2 {
            return Vector(point1: point2, point2: point1).unit
        } else {
            return direction1.vector
        }
    }
    
    public var vector2: Vector {
        if lineType is StraightLineType && point1 != point2 {
            return Vector(point1: point1, point2: point2).unit
        } else {
            return direction2.vector
        }
    }
    
    private var pointer1Tail: Point {
        return pointer1Type.tail(
            withLocation: point1,
            direction: vector1,
            size: pointer1Size)
    }
    
    private var pointer2Tail: Point {
        return pointer2Type.tail(
            withLocation: point2,
            direction: vector2,
            size: pointer2Size)
    }
    
    private var linePoint1: Point {
        let pointerTailLength = point1.distance(to: pointer1Tail)
        if pointerTailLength < minPointer1TailLength {
            return point1.translated(by: -vector1 * minPointer1TailLength)
        } else {
            return pointer1Tail
        }
    }
    
    private var linePoint2: Point {
        let pointerTailLength = point2.distance(to: pointer2Tail)
        if pointerTailLength < minPointer2TailLength {
            return point2.translated(by: -vector2 * minPointer2TailLength)
        } else {
            return pointer2Tail
        }
    }
    
    private var linePathWithoutText: BezierPath {
        return lineType.path(
            point1: linePoint1,
            direction1: direction1,
            point2: linePoint2,
            direction2: direction2)
    }
    
    private var linePathWithText: BezierPath {
        
        let linePath = linePathWithoutText
        
        let centerCurveIndex = lineType.centerCurveIndex(
            point1: linePoint1,
            direction1: direction1,
            point2: linePoint2,
            direction2: direction2)
        
        let curves = linePath.curves
        let textRect = self.textRect!
        
        var lastOriginCurveIndex: Int?
        var lastOriginCurveT: Double?
        
        var firstEndingCurveIndex: Int?
        var firstOriginCurveT: Double?
        
        let step = 0.005
        
        originLoop: for i in stride(from: centerCurveIndex, through: 0, by: -1) {
            let fromT = i == centerCurveIndex ? 0.5 : 1.0
            for t in stride(from: fromT, to: 0.0, by: -step) {
                let point = curves[i][t]
                if !textRect.contains(point) {
                    lastOriginCurveIndex = i
                    lastOriginCurveT = t
                    break originLoop
                }
            }
        }
        
        if lastOriginCurveIndex == nil {
            lastOriginCurveIndex = 0
            lastOriginCurveT = 0.0
        }
        
        endingLoop: for i in centerCurveIndex..<curves.count {
            let fromT = i == centerCurveIndex ? 0.5 : 0.0
            for t in stride(from: fromT, to: 1.0, by: +step) {
                let point = curves[i][t]
                if !textRect.contains(point) {
                    firstEndingCurveIndex = i
                    firstOriginCurveT = t
                    break endingLoop
                }
            }
        }
        
        if firstEndingCurveIndex == nil {
            firstEndingCurveIndex = curves.count - 1
            firstOriginCurveT = 1.0
        }
        
        let (originLinePath, _) = linePath.split(atCurveWithIndex: lastOriginCurveIndex!, t: lastOriginCurveT!)
        let (_, endingLinePath) = linePath.split(atCurveWithIndex: firstEndingCurveIndex!, t: firstOriginCurveT!)
        
        return originLinePath.appending(path: endingLinePath)
    }
}
