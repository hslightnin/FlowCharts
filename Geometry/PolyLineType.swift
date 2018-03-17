//
//  PolyLineType.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

public class PolyLineType: LineType {
    
    let minShoulder: Double
    
    public init(minShoulder: Double) {
        self.minShoulder = minShoulder
    }
    
    public func path(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        if direction1 == direction2 {
            return pathForEqualDirections(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
        } else if direction1 == direction2.opposite {
            return pathForOppositeDirections(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
        } else {
            return pathForOrthogonalDirections(point1: point1, direction1: direction1, point2: point2, direction2: direction2)
        }
    }
    
    private func pathForEqualDirections(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        let originOffset = point1.translated(by: -minShoulder * direction1.vector.unit)
        let endingOffset = point2.translated(by: -minShoulder * direction2.vector.unit)
        
        let bezierPath = BezierPath()
        bezierPath.move(to: point1)
        
        switch direction1 {
        case .right:
            let minX = min(originOffset.x, endingOffset.x)
            bezierPath.addLine(to: Point(minX, point1.y))
            bezierPath.addLine(to: Point(minX, point2.y))
        case .left:
            let maxX = max(originOffset.x, endingOffset.x)
            bezierPath.addLine(to: Point(maxX, point1.y))
            bezierPath.addLine(to: Point(maxX, point2.y))
        case .up:
            let minY = max(originOffset.y, endingOffset.y)
            bezierPath.addLine(to: Point(point1.x, minY))
            bezierPath.addLine(to: Point(point2.x, minY))
        case .down:
            let maxY = min(originOffset.y, endingOffset.y)
            bezierPath.addLine(to: Point(point1.x, maxY))
            bezierPath.addLine(to: Point(point2.x, maxY))
        }
    
        bezierPath.addLine(to: point2)
        return bezierPath
    }
    
    private func pathForOppositeDirections(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        let bezierPath = BezierPath()
        bezierPath.move(to: point1)
        
        if (direction1 == .left && point2.x > point1.x + 2 * minShoulder) ||
            (direction1 == .right && point1.x > point2.x + 2 * minShoulder) ||
            (direction1 == .down && point1.y > point2.y + 2 * minShoulder) ||
            (direction1 == .up && point2.y > point1.y + 2 * minShoulder) {
            
            if direction1.isHorizontal {
                let midX = (point2.x + point1.x) / 2
                bezierPath.addLine(to: Point(midX, point1.y))
                bezierPath.addLine(to: Point(midX, point2.y))
            } else {
                let midY = (point2.y + point1.y) / 2;
                bezierPath.addLine(to: Point(point1.x, midY))
                bezierPath.addLine(to: Point(point2.x, midY))
            }
            
        } else {
            
            let originOffset = point1.translated(by: -minShoulder * direction1.vector.unit)
            let endingOffset = point2.translated(by: -minShoulder * direction2.vector.unit)
            
            bezierPath.addLine(to: originOffset)
    
            if direction1.isHorizontal {
                let midY = (endingOffset.y + originOffset.y) / 2
                bezierPath.addLine(to: Point(originOffset.x, midY))
                bezierPath.addLine(to: Point(endingOffset.x, midY))
            } else {
                let midX = (endingOffset.x + originOffset.x) / 2
                bezierPath.addLine(to: Point(midX, originOffset.y))
                bezierPath.addLine(to: Point(midX, endingOffset.y))
            }
            
            bezierPath.addLine(to: endingOffset)
        }
        
        bezierPath.addLine(to: point2)
        return bezierPath
    }
    
    private func pathForOrthogonalDirections(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> BezierPath {
        
        let (midPointX, midPointY) = direction1.isHorizontal ? (point2.x, point1.y) : (point1.x, point2.y)
        
        let opposeOrigin = (direction1 == .up && midPointY < point1.y + minShoulder) ||
            (direction1 == .down && midPointY > point1.y - minShoulder) ||
            (direction1 == .right && midPointX > point1.x - minShoulder) ||
            (direction1 == .left && midPointX < point1.x + minShoulder)
        
        
        let opposeEnding = (direction2 == .up && midPointY < point2.y + minShoulder) ||
            (direction2 == .down && midPointY > point2.y - minShoulder) ||
            (direction2 == .right && midPointX > point2.x - minShoulder) ||
            (direction2 == .left && midPointX < point2.x + minShoulder)
        
        let bezierPath = BezierPath()
        bezierPath.move(to: point1)
        
        if !opposeOrigin && !opposeEnding {
            
            bezierPath.addLine(to: Point(midPointX, midPointY))
            
        } else if opposeOrigin && opposeEnding {
            
            let originOffset = point1.translated(by: -minShoulder * direction1.vector.unit)
            let endingOffset = point2.translated(by: -minShoulder * direction2.vector.unit)
            
            bezierPath.addLine(to: originOffset)
            
            if direction1.isHorizontal {
                bezierPath.addLine(to: Point(originOffset.x, endingOffset.y))
            } else {
                bezierPath.addLine(to: Point(endingOffset.x, originOffset.y))
            }
            
            bezierPath.addLine(to: endingOffset)
            
        } else if opposeOrigin {
            
            let originOffset = point1.translated(by: -minShoulder * direction1.vector.unit)
            let endingOffset = point2.translated(by: -minShoulder * direction2.vector.unit)
         
            bezierPath.addLine(to: originOffset)
            
            if direction1.isVertical {
                
                var midX = (point1.x + point2.x) / 2
                
                if direction2 == .right && midX > endingOffset.x || direction2 == .left && midX < endingOffset.x {
                    midX = endingOffset.x
                }
                
                bezierPath.addLine(to: Point(midX, originOffset.y))
                bezierPath.addLine(to: Point(midX, point2.y))
                
            } else {
                
                var midY = (point1.y + point2.y) / 2;
                
                if direction2 == .up && midY > endingOffset.y || direction2 == .down && midY < endingOffset.y {
                    midY = endingOffset.y
                }
                
                bezierPath.addLine(to: Point(originOffset.x, midY))
                bezierPath.addLine(to: Point(point2.x, midY))
            }
            
        } else {
            
            let originOffset = point1.translated(by: -minShoulder * direction1.vector.unit)
            let endingOffset = point2.translated(by: -minShoulder * direction2.vector.unit)
            
            if direction2.isVertical {
                
                var midX = (point1.x + point2.x) / 2
                
                if direction1 == .right && midX > originOffset.x || direction1 == .left && midX < originOffset.x {
                    midX = originOffset.x
                }
                
                bezierPath.addLine(to: Point(midX, point1.y))
                bezierPath.addLine(to: Point(midX, endingOffset.y))
                
            } else {
                
                var midY = (point1.y + point2.y) / 2
                
                if direction1 == .up && midY > originOffset.y || direction1 == .down && midY < originOffset.y {
                    midY = originOffset.y
                }
                
                bezierPath.addLine(to: Point(point1.x, midY))
                bezierPath.addLine(to: Point(endingOffset.x, midY))
            }
            
            bezierPath.addLine(to: endingOffset)
        }
        
        bezierPath.addLine(to: point2)
        return bezierPath
    }
    
    public func centerCurveIndex(point1: Point, direction1: Direction, point2: Point, direction2: Direction) -> Int {
        let curves = path(point1: point1, direction1: direction1, point2: point2, direction2: direction2).curves
        switch curves.count {
        case 5:
            return 2
        case 2:
            let curve1Length = curves[0].point1.distance(to: curves[0].point2)
            let curve2Length = curves[1].point1.distance(to: curves[1].point2)
            return curve1Length > curve2Length ? 0 : 1
        default:
            return 1
        }
    }
}
