//
//  SmoothedLineType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 14/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class SmoothedLineType: LineType {
    
    private let lineType: LineType
    private let cornerRadius: Double
    
    public init(lineType: LineType, cornerRadius: Double) {
        self.lineType = lineType
        self.cornerRadius = cornerRadius
    }
    
    public func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        let notSmoothPath: BezierPath = self.lineType.path(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
        
        let smoothedPath = BezierPath()
        
        let curves = notSmoothPath.curves
        for (idx, curve) in curves.enumerated() {
            if idx == 0 {
                smoothedPath.move(to: curve.point1)
            } else {
                
                let prevCurve = curves[idx - 1]
                
                var radius = self.cornerRadius
                
                if prevCurve is LinearBezierCurve && curve is LinearBezierCurve {
                    
                    if prevCurve.point1.distance(to: prevCurve.point2) / 2 < radius {
                        radius = prevCurve.point1.distance(to: prevCurve.point2) / 2
                    }
                    
                    if curve.point1.distance(to: curve.point2) / 2 < radius {
                        radius = curve.point1.distance(to: curve.point2) / 2
                    }
                    
                    if prevCurve.point1.distance(to: prevCurve.point2) < 0.001 || curve.point1.distance(to: curve.point2) < 0.001 {
                        smoothedPath.move(to: curve.point1)
                    } else {
                    
                        let prevLineVector = Vector(point1: prevCurve.point2, point2: prevCurve.point1).unit * radius
                        let nextLineVector = Vector(point1: curve.point1, point2: curve.point2).unit * radius

                        let p1 = curve.point1.translated(by: prevLineVector)
                        let p2 = curve.point1.translated(by: nextLineVector)
                        
                        smoothedPath.addLine(to: p1)
                        smoothedPath.addQuadCurve(to: p2, control: curve.point1)
                    }
                } else {
                    smoothedPath.move(to: curve.point1)
                }
            }
            
            if idx == curves.count - 1 {
                smoothedPath.addLine(to: curve.point2)
            }
        }
        
        return smoothedPath
    }
    
    public func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int {
        let idx = lineType.centerCurveIndex(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
        return 2 * idx
    }
}
