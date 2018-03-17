//
//  ZigzagLine.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class ZigzagLineType: LineType {
    
    public let shoulder1: Double
    public let shoulder2: Double
    
    public init(shoulder1: Double, shoulder2: Double) {
        self.shoulder1 = shoulder1
        self.shoulder2 = shoulder2
    }
    
    public func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        var shoulder1 = self.shoulder1
        var shoulder2 = self.shoulder2
        
        if direction1.isOpposite(direction2) {
            
            let distance = point1.distance(to: point2)
        
            if distance < 3 * shoulder1 {
                shoulder1 = distance / 3
            }
        
            if distance < 3 * shoulder2 {
                shoulder2 = distance / 3
            }
        }
    
        let originSegmentPoint1 = point1
        let originSegmentTranslation = -shoulder1 * direction1.vector
        let originSegmentPoint2 = originSegmentPoint1.translated(by: originSegmentTranslation)
    
        let endingSegmentPoint1 = point2
        let endingSegmentTranslation = -shoulder2 * direction2.vector
        let endingSegmentPoint2 = endingSegmentPoint1.translated(by: endingSegmentTranslation)
    
        let path = BezierPath()
        path.move(to: originSegmentPoint1)
        path.addLine(to: originSegmentPoint2)
        path.addLine(to: endingSegmentPoint2)
        path.addLine(to: endingSegmentPoint1)
        return path
    }
    
    public func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int {
        return 1
    }
}
