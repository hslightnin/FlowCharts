//
//  BuildLinkInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 08/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreData
import PresenterKit
import DiagramGeometry

class BuildLinkInteractor: ContinuousInteractor, BuildLinkInteractorProtocol {
    
    let manipulatedAnchor: FlowChartSymbolAnchor
    private(set) var addedLink: FlowChartLink?
    private(set) var addedSymbol: FlowChartSymbol?
    
    var snapDistance = 20.0
    var createSymbolDistance = 100.0
    
    init(anchor: FlowChartSymbolAnchor) {
        self.manipulatedAnchor = anchor
        super.init(managedObjectContext: anchor.flowChartManagedObjectContext)
    }

    override func begin() {
        let diagram = manipulatedAnchor.symbol.diagram!
        addedLink = BuildLinkHelper.buildLink(in: diagram, from: manipulatedAnchor)
    }
    
    func moveLinkEnding(to location: Point) {
        
        var nearestAnchor: FlowChartSymbolAnchor?
        var distanceToNearestAnchor = Double.infinity
        for symbol in manipulatedAnchor.symbol!.diagram!.flowChartSymbols!.array as! [FlowChartSymbol] {
            if symbol !== addedSymbol {
                for anchor in symbol.anchors {
                    if anchor != manipulatedAnchor {
                        let anchorLocation = anchor.location
                        let distanceToAnchor = location.distance(to: anchorLocation)
                        if distanceToAnchor < distanceToNearestAnchor {
                            distanceToNearestAnchor = distanceToAnchor
                            nearestAnchor = anchor
                        }
                    }
                }
            }
        }
        
        if distanceToNearestAnchor < snapDistance {
            
            if addedSymbol != nil {
                deletePlaceholderSymbol()
            }
            
            addedLink!.ending!.x = nearestAnchor!.x
            addedLink!.ending!.y = nearestAnchor!.y
            addedLink!.ending!.direction = nearestAnchor!.direction.opposite
            addedLink!.ending!.symbolAnchor = nearestAnchor
            
        } else {
            
            var linkLocation = location
            
            if linkLocation.x < ShapePreset.placeholder.defaultSize.width / 2 {
                linkLocation.x = ShapePreset.placeholder.defaultSize.width / 2
            }
            
            if linkLocation.y < ShapePreset.placeholder.defaultSize.height / 2 {
                linkLocation.y = ShapePreset.placeholder.defaultSize.height / 2
            }
            
            let canCreateLink = addedLink!.origin!.location.distance(to: linkLocation) > createSymbolDistance
            
            addedLink!.ending!.symbolAnchor = nil
            
            if canCreateLink {
                
                if addedSymbol == nil {
                    createPlaceholderSymbol()
                }
                movePlaceholderSymbol(to: location)
                
            } else {
                
                if addedSymbol != nil {
                    deletePlaceholderSymbol()
                }
                
                var anchorLocation = location
                
                if anchorLocation.x < 0 {
                    anchorLocation.x = 0
                }
                
                if anchorLocation.y < 0 {
                    anchorLocation.y = 0
                }
                
                addedLink!.ending!.x = location.x
                addedLink!.ending!.y = location.y
                addedLink!.ending!.direction = linkAnchorDirection(for: location)
            }
        }
        
        if canSave {
            addedLink!.dataSource.setStrokeColor(FlowChartLink.normalStrokeColor)
        } else {
            addedLink!.dataSource.setStrokeColor(FlowChartLink.normalStrokeColor.withAlphaComponent(0.2))
        }
    }
    
    func end() {
        addedSymbol?.lineWidth = 1.0
    }
    
    func setSymbolShapePreset(_ preset: ShapePreset) {
        addedSymbol?.shapePreset = preset
    }
    
    func setSymbolColor(_ color: UIColor) {
        addedSymbol?.color = color
    }
    
    var hasAddedSymbol: Bool {
        return addedSymbol != nil
    }
    
    var hasAddedLink: Bool {
        return addedLink != nil
    }
    
    var canSave: Bool {
        return addedLink!.ending!.symbolAnchor != nil
    }
    
    // MARK: - Placeholder symbol
    
    private func createPlaceholderSymbol() {
        let size = ShapePreset.placeholder.defaultSize
        addedSymbol = BuildSymbolHelper.buildSymbol(
            in: addedLink!.diagram!,
            frame: Rect(origin: .zero, size: size),
            shapePreset: .placeholder,
            color: SymbolColorPresets.snow)
        addedLink!.ending.symbolAnchor = addedSymbol!.anchor(withDirection: manipulatedAnchor.direction.opposite)
        
        manipulatedAnchor.symbol.dataSource.unfocus()
        addedSymbol!.dataSource.focus()
        addedSymbol!.lineWidth = 0.5
    }
    
    private func movePlaceholderSymbol(to location: Point) {
        
        let symbolSize = addedSymbol!.size
        
        let linkAnchorDirection = self.linkAnchorDirection(for: location)
        let symbolAnchorDirecton = linkAnchorDirection.opposite
        
        var symbolLocation = Point()
        switch symbolAnchorDirecton {
        case .up:
            symbolLocation = Point(location.x - symbolSize.width / 2, location.y - symbolSize.height / 2)
        case .down:
            symbolLocation = Point(location.x - symbolSize.width / 2, location.y - symbolSize.height / 2)
        case .right:
            symbolLocation = Point(location.x - symbolSize.width / 2, location.y - symbolSize.height / 2)
        case .left:
            symbolLocation = Point(location.x - symbolSize.width / 2, location.y - symbolSize.height / 2)
        }
        
        addedSymbol!.x = symbolLocation.x
        addedSymbol!.y = symbolLocation.y
        addedSymbol!.width = symbolSize.width
        addedSymbol!.height = symbolSize.height
        
        addedLink!.ending!.symbolAnchor = addedSymbol!.anchor(withDirection: symbolAnchorDirecton)
        LayoutSymbolAnchorsHelper.layoutAnchors(for: addedSymbol!)
    }
    
    private func deletePlaceholderSymbol() {
        
        addedSymbol!.managedObjectContext!.delete(addedSymbol!)
        addedSymbol = nil
        
        manipulatedAnchor.symbol.dataSource.focus()
    }
    
    // MARK: - Direction zones
    
    lazy var directZone: Polygon = {
        return LinkDirectionZonesHelper.directZone(for: self.manipulatedAnchor)
    }()
    
    lazy var oppositeZone: Polygon = {
        return LinkDirectionZonesHelper.oppositeZone(for: self.manipulatedAnchor)
    }()
    
    lazy var rotatedClockwiseZone: Polygon = {
        return LinkDirectionZonesHelper.rotatedClockwiseZone(for: self.manipulatedAnchor)
    }()
    
    lazy var rotatedCounterClockwiseZone: Polygon = {
        return LinkDirectionZonesHelper.rotatedCounterClockwiseZone(for: self.manipulatedAnchor)
    }()
    
    private func linkAnchorDirection(for location: Point) -> Direction {
        let directDirection = manipulatedAnchor.direction
        if directZone.contains(point: location) {
            return directDirection
        } else if oppositeZone.contains(point: location) {
            return directDirection.opposite
        } else if rotatedClockwiseZone.contains(point: location) {
            return directDirection.rotatedClockwise
        } else {
            return directDirection.rotatedCounterClockwise
        }
    }
    
    override func rollback(withIn transition: Transition) {
        addedSymbol = nil
        addedLink = nil
        super.rollback(withIn: transition)
    }
    
    // MARK: - BuileLinkLayoutInteractorProtocol
    
    var manipulatedAnchorDirection: Direction {
        return manipulatedAnchor.direction
    }
    
    var addedLinkEndingLocation: Point? {
        return addedLink?.ending.location
    }
    
    var addedLinkEndingDirection: Direction? {
        return addedLink?.ending.direction
    }
    
    var addedSymbolFrame: Rect? {
        return addedSymbol?.frame
    }
    
    lazy var directZonePath: BezierPath = {
        return BezierPath(self.directZone)
    }()
    
    lazy var oppositeZonePath: BezierPath = {
        return BezierPath(self.oppositeZone)
    }()
    
    lazy var rotatedClockwiseZonePath: BezierPath = {
        return BezierPath(self.rotatedClockwiseZone)
    }()
    
    lazy var rotatedCounterClockwiseZonePath: BezierPath = {
        return BezierPath(self.rotatedCounterClockwiseZone)
    }()
}
