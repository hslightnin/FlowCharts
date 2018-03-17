//
//  Shape.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 02/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreText

public class Shape {
    
    public let frame: Rect
    public let type: ShapeType
    public let lineWidth: Double
    public let text: NSAttributedString?
    public let textInsets: Vector?
    
    public let path: BezierPath
    public let textAreaPath: BezierPath
    public let textPath: BezierPath?
    public let visibleText: NSAttributedString?
    
    public init(bounds: Rect,
                type: ShapeType,
                lineWidth: Double,
                text: NSAttributedString? = nil,
                textInsets: Vector? = nil) {
        
        self.frame = bounds
        self.type = type
        self.lineWidth = lineWidth
        self.text = text
        self.textInsets = textInsets
        
        self.path = type.path(within: bounds)
        
        let textBounds = bounds.insetBy(dx: textInsets?.x ?? 0, dy: textInsets?.y ?? 0)
        self.textAreaPath = type.textPath(within: textBounds)
        
        var textPath: BezierPath?
        var visibleText: NSAttributedString? = text
        
        if text == nil {
            textPath = nil
        } else {
            
            textPath = textAreaPath.copy()
            textPath = textPath!.pathByReplacingCurvesWithStraightLines // CoreText does not handle curved paths well
            
            let textPathBounds = CGPath(textPath!).boundingBoxOfPath
            
            let framesetter = CTFramesetterCreateWithAttributedString(text!)
            let textRange = CFRange(location: 0, length: text!.length)
            var frame = CTFramesetterCreateFrame(framesetter, textRange, CGPath(textPath!), nil)
            
            let lines = CTFrameGetLines(frame) as NSArray
            if lines.count == 0 {
                textPath = nil
            } else {
                let lineBounds = CTLineGetBoundsWithOptions(lines[0] as! CTLine, CTLineBoundsOptions(rawValue: 0))
                
                // We need to add 0.1 because later we will add this path to CALayer context and flip context (CoreText works with not flipped coordinates). This will add calculation error, so we need to create a bit larger path to compensate this error.
                // TODO: Better soluion will be to flip path itself before adding it to context.
                let lineHeight = ceil(Double(lineBounds.height)) + 0.1
                
                var numberOfLines = floor(Double(textPathBounds.height) / lineHeight)
                textPath = textPath!.centerPath(height: lineHeight * numberOfLines)
                frame = CTFramesetterCreateFrame(framesetter, textRange, CGPath(textPath!), nil)
                var visibleRange = CTFrameGetVisibleStringRange(frame)
                
                while numberOfLines > 1 && visibleRange.length == text!.length {
                    numberOfLines -= 1
                    let shrinkedTextPath = textPath!.centerPath(height: lineHeight * numberOfLines)
                    let shrinkedFrame = CTFramesetterCreateFrame(framesetter, textRange, CGPath(shrinkedTextPath), nil)
                    let shrinkedVisibleRange = CTFrameGetVisibleStringRange(shrinkedFrame)
                    if (shrinkedVisibleRange.length == text!.length) {
                        textPath = shrinkedTextPath
                        frame = shrinkedFrame
                        visibleRange = shrinkedVisibleRange
                    }
                }
                
                // TODO: Need more effective truncation
                if visibleRange.length != text!.length {
                    
                    let attributes = text!.attributes(at: text!.length - 1, effectiveRange: nil)
                    let truncatedText = text!.mutableCopy() as! NSMutableAttributedString
                    truncatedText.append(NSAttributedString(string: "...", attributes: attributes))
                    var truncatedVisibleRange = visibleRange
                    
                    while truncatedVisibleRange.length != truncatedText.length && truncatedText.length > 3 {
                        truncatedText.deleteCharacters(in: NSMakeRange(truncatedText.length - 4, 1))
                        let truncatedFramesetter = CTFramesetterCreateWithAttributedString(truncatedText)
                        let truncatedFrame = CTFramesetterCreateFrame(truncatedFramesetter, CFRange(), CGPath(textPath!), nil)
                        truncatedVisibleRange = CTFrameGetVisibleStringRange(truncatedFrame)
                    }
                    
                    visibleText = truncatedText
                }
            }
        }
        
        self.textPath = textPath
        self.visibleText = visibleText
    }
}

fileprivate extension BezierCurve {
    
    func split(by line: Line) -> [BezierCurve] {
        var remainder: BezierCurve = self
        var curves = [BezierCurve]()
        for t in self.intersections(with: line, extended: false) {
            let (curve1, curve2) = remainder.split(at: t)
            curves.append(curve1)
            remainder = curve2
        }
        curves.append(remainder)
        return curves
    }
}

fileprivate extension BezierPath {
    
    func centerPath(height: Double) -> BezierPath {
        let pathBounds = CGPath(self).boundingBoxOfPath
        let minY = Double(pathBounds.midY) - height / 2
        let maxY = Double(pathBounds.midY) + height / 2
        return self.path(below: maxY, above: minY)
    }
    
    func path(below maxY: Double, above minY: Double) -> BezierPath {
        
        let maxLine = Line(a: 0, b: 1, c: -maxY)
        let minLine = Line(a: 0, b: 1, c: -minY)
        
        let splitCurves = self.curves
            .flatMap { $0.split(by: maxLine) }
            .flatMap { $0.split(by: minLine) }
        
        var shrinkedCurves = [BezierCurve]()
        var prevInnerCurve: BezierCurve?
        for curve in splitCurves {
            let y = curve.point(at: 0.5).y
            if y > minY && y < maxY {
                if prevInnerCurve != nil {
                    shrinkedCurves.append(LinearBezierCurve(point1: prevInnerCurve!.point2, point2: curve.point1))
                    prevInnerCurve = nil
                }
                shrinkedCurves.append(curve)
            } else if prevInnerCurve == nil && shrinkedCurves.count > 0 {
                prevInnerCurve = shrinkedCurves.last
            }
        }
        
        if prevInnerCurve != nil && shrinkedCurves.count > 0 {
            shrinkedCurves.append(LinearBezierCurve(point1: prevInnerCurve!.point2, point2: shrinkedCurves[0].point1))
        }
        
        return BezierPath(curves: shrinkedCurves)
    }
    
    var pathByReplacingCurvesWithStraightLines: BezierPath {
        
        let path = BezierPath()
        
        let step = 0.05
        
        var currentPoint: Point!
        var currentSubPathOrigin: Point!
        
        self.elements.forEach { element in
            switch element {
            case .move(let point):
                path.move(to: point)
                currentPoint = point
                currentSubPathOrigin = point
            case .addLine(let point):
                path.addLine(to: point)
                currentPoint = point
            case .addQuadCurve(let point, let control):
                let curve = QuadraticBezierCurve(
                    point1: currentPoint,
                    controlPoint: control,
                    point2: point)
                for t in stride(from: step, through: 1.0, by: step) {
                    path.addLine(to: curve[t])
                }
                currentPoint = point
            case .addCubucCurve(let point, let control1, let control2):
                let curve = CubicBezierCurve(
                    point1: currentPoint,
                    controlPoint1: control1,
                    controlPoint2: control2,
                    point2: point)
                for t in stride(from: step, through: 1.0, by: step) {
                    path.addLine(to: curve[t])
                }
                currentPoint = point
            case .close:
                path.close()
                currentPoint = currentSubPathOrigin
            }
        }
        
        return path
    }
}
