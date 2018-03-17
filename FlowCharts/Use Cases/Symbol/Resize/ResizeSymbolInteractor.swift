//
//  ResizeSymbolInteractor.swift
//  FlowCharts

//
//  Created by Alexander Kozlov on 29/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry

class ResizeSymbolInteractor: ContinuousInteractor, ResizeSymbolInteractorProtocol {
    
    private let symbol: FlowChartSymbol
    
    var mode: SymbolResizingMode = .fromOrigin
    var minSize = Size(20, 20)
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        super.init(managedObjectContext: symbol.flowChartManagedObjectContext)
    }
    
    func moveRightBottomCorner(to location: Point) {
        
        switch mode {
            
        case .fromOrigin:
            
            var newSize = Size(location.x - symbol.x, location.y - symbol.y)
            
            let maxWidth = symbol.diagram.size.width - symbol.x
            if newSize.width > maxWidth {
                newSize.width = maxWidth
            }
            
            if newSize.width < minSize.width {
                newSize.width = minSize.width
            }
            
            let maxHeight = symbol.diagram.size.height - symbol.y
            if newSize.height > maxHeight {
                newSize.height = maxHeight
            }
            
            if newSize.height < minSize.height {
                newSize.height = minSize.height
            }
            
            newSize = symbol.shapePreset.requiredSize(withConstraints: newSize)
            
            symbol.width = newSize.width
            symbol.height = newSize.height
            
        case .fromCenter:
            
            var newSize = Size((location.x - symbol.center.x) * 2, (location.y - symbol.center.y) * 2)
            
            let maxWidth = min((symbol.diagram.size.width - symbol.center.x) * 2, symbol.center.x * 2)
            if newSize.width > maxWidth {
                newSize.width = maxWidth
            }
            
            if newSize.width < minSize.width {
                newSize.width = minSize.width
            }
    
            let maxHeight = min((symbol.diagram.size.height - symbol.center.y) * 2, symbol.center.y * 2)
            if newSize.height > maxHeight {
                newSize.height = maxHeight
            }
            
            if newSize.height < minSize.height {
                newSize.height = minSize.height
            }
            
            newSize = symbol.shapePreset.requiredSize(withConstraints: newSize)
            
            let newX = symbol.center.x - newSize.width / 2
            let newY = symbol.center.y - newSize.height / 2
            
            symbol.x = newX
            symbol.y = newY
            symbol.width = newSize.width
            symbol.height = newSize.height
        }
        
        LayoutSymbolAnchorsHelper.layoutAnchors(for: symbol)
    }
}

