//
//  SymbolMoveInteractor.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 15/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class MoveSymbolInteractor: ContinuousInteractor, MoveSymbolInteractorProtocol {
    
    private let symbol: FlowChartSymbol
    private var initialLocation: Point = .zero
    private var totalTranslation: Vector = .zero
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        super.init(managedObjectContext: symbol.flowChartManagedObjectContext)
    }
    
    override func begin() {
        super.begin()
        initialLocation = Point(symbol.x, symbol.y)
        totalTranslation = Vector()
    }
    
    func move(by translation: Vector) {
        precondition(isInteracting)
        
        totalTranslation += translation
        
        var newLocation = initialLocation.translated(by: totalTranslation)
        
        let minX = 0.0
        if newLocation.x < minX {
            newLocation.x = minX
        }
        
        let maxX = symbol.diagram.width - symbol.width
        if newLocation.x > maxX {
            newLocation.x = maxX
        }
        
        let minY = 0.0
        if newLocation.y < minY {
            newLocation.y = minY
        }
        
        let maxY = symbol.diagram.height - symbol.height
        if newLocation.y > maxY {
            newLocation.y = maxY
        }
        
        symbol.x = newLocation.x
        symbol.y = newLocation.y
        
        LayoutSymbolAnchorsHelper.layoutAnchors(for: symbol)
    }
}
