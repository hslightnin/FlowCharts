//
//  StubBuildLinkInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
import PresenterKit
@testable import FlowCharts

class StubBuildLinkInteractor: StubContinuousInteractor, BuildLinkInteractorProtocol {
    
    var hasAddedSymbol = false
    var hasAddedLink = false
    var canSave = false
    var manipulatedAnchorDirection = Direction.right
    var addedLinkEndingLocation: Point?
    var addedLinkEndingDirection: Direction?
    var addedSymbolFrame: Rect?
    var directZonePath = BezierPath()
    var oppositeZonePath = BezierPath()
    var rotatedClockwiseZonePath = BezierPath()
    var rotatedCounterClockwiseZonePath = BezierPath()
    
    func moveLinkEnding(to location: Point) {
        addedLinkEndingLocation = location
        addedLinkEndingDirection = .right
    }
    
    func end() {
        
    }
    
    private(set) var addedSymbolShapePreset: ShapePreset?
    
    func setSymbolShapePreset(_ preset: ShapePreset) {
        addedSymbolShapePreset = preset
    }
    
    private(set) var addedSymbolColor: UIColor?
    
    func setSymbolColor(_ color: UIColor) {
        addedSymbolColor = color
    }
}

