//
//  LinkDirectionZonesHelper.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 11/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry

class LinkDirectionZonesHelper {
    
    static func directZone(for anchor: FlowChartSymbolAnchor) -> Polygon {
        let diagramSize = anchor.symbol!.diagram!.size
        let rect = Rect(origin: .zero, size: diagramSize)
        let location = anchor.location
        let direction = anchor.direction
        let vector = direction.vector
        let side1Vector = vector.rotated(by: -.pi / 6)
        let side2Vector = vector.rotated(by: +.pi / 6)
        return LinkDirectionZonesHelper.zone(
            withLocation: location,
            side1Vector: side1Vector,
            side2Vector: side2Vector,
            inRect: rect)
    }
    
    static func oppositeZone(for anchor: FlowChartSymbolAnchor) -> Polygon {
        let diagramSize = anchor.symbol!.diagram!.size
        let rect = Rect(origin: .zero, size: diagramSize)
        let location = anchor.location
        let direction = anchor.direction
        let vector = direction.vector
        let side1Vector = vector.rotated(by: +2 * .pi / 3)
        let side2Vector = vector.rotated(by: -2 * .pi / 3)
        return LinkDirectionZonesHelper.zone(
            withLocation: location,
            side1Vector: side1Vector,
            side2Vector: side2Vector,
            inRect: rect)
    }
    
    static func rotatedClockwiseZone(for anchor: FlowChartSymbolAnchor) -> Polygon {
        let diagramSize = anchor.symbol!.diagram!.size
        let rect = Rect(origin: .zero, size: diagramSize)
        let location = anchor.location
        let direction = anchor.direction
        let vector = direction.vector
        let side1Vector = vector.rotated(by: +1 * .pi / 6)
        let side2Vector = vector.rotated(by: +2 * .pi / 3)
        return LinkDirectionZonesHelper.zone(
            withLocation: location,
            side1Vector: side1Vector,
            side2Vector: side2Vector,
            inRect: rect)
    }
    
    static func rotatedCounterClockwiseZone(for anchor: FlowChartSymbolAnchor) -> Polygon {
        let diagramSize = anchor.symbol!.diagram!.size
        let rect = Rect(origin: .zero, size: diagramSize)
        let location = anchor.location
        let direction = anchor.direction
        let vector = direction.vector
        let side1Vector = vector.rotated(by: -2 * .pi / 3)
        let side2Vector = vector.rotated(by: -1 * .pi / 6)
        return LinkDirectionZonesHelper.zone(
            withLocation: location,
            side1Vector: side1Vector,
            side2Vector: side2Vector,
            inRect: rect)
    }
    
    static func linkAnchorDirection(at location: Point, for symbolAnchor: FlowChartSymbolAnchor) -> Direction {
        let directDirection = symbolAnchor.direction
        if directZone(for: symbolAnchor).contains(point: location) {
            return directDirection
        } else if oppositeZone(for: symbolAnchor).contains(point: location) {
            return directDirection.opposite
        } else if rotatedClockwiseZone(for: symbolAnchor).contains(point: location) {
            return directDirection.rotatedClockwise
        } else {
            return directDirection.rotatedCounterClockwise
        }
    }
    
    static private func zone(
        withLocation location: Point,
        side1Vector: Vector,
        side2Vector: Vector,
        inRect rect: Rect) -> Polygon {
        
        let side1Curve = LinearBezierCurve(point1: location, point2: location.translated(by: side1Vector))
        let side2Curve = LinearBezierCurve(point1: location, point2: location.translated(by: side2Vector))
        
        let rectPoints = [
            rect.topLeftPoint,
            rect.topRightPoint,
            rect.bottomRightPoint,
            rect.bottomLeftPoint
        ]
        
        let rectLines = [
            Line(point1: rect.topLeftPoint, point2: rect.topRightPoint)!,
            Line(point1: rect.topRightPoint, point2: rect.bottomRightPoint)!,
            Line(point1: rect.bottomLeftPoint, point2: rect.bottomRightPoint)!,
            Line(point1: rect.topLeftPoint, point2: rect.bottomLeftPoint)!
        ]
        
        let side1RectIntersection = rectLines.enumerated()
            .map { (index: $0.offset, t: side1Curve.intersections(with: $0.element, extended: true).first!) }
            .filter { $0.t > 0 }
            .sorted { $0.t < $1.t }
            .first!
        
        let side2RectIntersection = rectLines.enumerated()
            .map { (index: $0.offset, t: side2Curve.intersections(with: $0.element, extended: true).first!) }
            .filter { $0.t > 0 }
            .sorted { $0.t < $1.t }
            .first!
        
        var points = [Point]()
        points.append(location)
        points.append(side1Curve.point(at: side1RectIntersection.t))
        if side1RectIntersection.index < side2RectIntersection.index {
            for index in side1RectIntersection.index..<side2RectIntersection.index {
                points.append(rectPoints[index + 1])
            }
        } else if side1RectIntersection.index > side2RectIntersection.index {
            let cornerIndex1 = min(side1RectIntersection.index + 1, rectPoints.count - 1)
            points.append(rectPoints[cornerIndex1])
            let cornerIndex2 = max(side2RectIntersection.index - 1, 0)
            if cornerIndex2 != cornerIndex1 {
                points.append(rectPoints[cornerIndex2])
            }
        }
        points.append(side2Curve.point(at: side2RectIntersection.t))
        
        return Polygon(points)
    }
}


