//
//  MoveLinkAnchorInteractor.swift
//  FlowCharts
//
//  Created by alex on 15/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class MoveLinkAnchorInteractor: ContinuousInteractor, MoveLinkAnchorInteractorProtocol {
    
    private let anchor: FlowChartLinkAnchor
    private var initialSymbolAnchor: FlowChartSymbolAnchor?
    
    var snapDistace = 20.0
    
    init(anchor: FlowChartLinkAnchor) {
        self.anchor = anchor
        super.init(managedObjectContext: anchor.flowChartManagedObjectContext)
    }
    
    var isOriginAnchor: Bool {
        return anchor.isOrigin
    }
    
    var anchorLocation: Point {
        return anchor.location
    }
    
    var anchorVector: Vector {
        if isOriginAnchor {
            return anchor.link.arrow.vector1
        } else {
            return anchor.link.arrow.vector2
        }
    }
    
    override func begin() {
        self.initialSymbolAnchor = anchor.symbolAnchor!
        super.begin()
    }
    
    func move(to location: Point) {
        
        anchor.symbolAnchor = nil
        anchor.location = location
        anchor.direction = LinkDirectionZonesHelper.linkAnchorDirection(at: location, for: sourceSymbolAnchor)
        
        let symbols = anchor.link.diagram!.flowChartSymbols!.array as! [FlowChartSymbol]
        let symbolAnchors = symbols.flatMap { Array($0.anchors) }
        
        for symbolAnchor in symbolAnchors {
            if symbolAnchor.location.distance(to: anchor.location) < snapDistace {
                anchor.symbolAnchor = symbolAnchor
                anchor.location = symbolAnchor.location
                anchor.direction = symbolAnchor.direction.opposite
                break
            }
        }
    }
    
    var canSave: Bool {
        return anchor.symbolAnchor != nil
    }
//    
//    var canEnd: Bool {
//        return anchor.symbolAnchor != nil
//    }
    
    private var sourceSymbolAnchor: FlowChartSymbolAnchor {
        return self.anchor.oppositeAnchor.symbolAnchor
    }
    
//    private lazy var directZone: Polygon = {
//        return LinkDirectionZonesHelper.directZone(for: self.sourceSymbolAnchor)
//    }()
//
//    private lazy var oppositeZone: Polygon = {
//        return LinkDirectionZonesHelper.oppositeZone(for: self.sourceSymbolAnchor)
//    }()
//
//    private lazy var rotatedClockwiseZone: Polygon = {
//        return LinkDirectionZonesHelper.rotatedClockwiseZone(for: self.sourceSymbolAnchor)
//    }()
//
//    private lazy var rotatedCounterClockwiseZone: Polygon = {
//        return LinkDirectionZonesHelper.rotatedCounterClockwiseZone(for: self.sourceSymbolAnchor)
//    }()
}

