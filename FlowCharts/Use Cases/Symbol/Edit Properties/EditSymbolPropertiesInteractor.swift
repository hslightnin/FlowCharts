//
//  EditSymbolPropertiesUseCaseInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class EditSymbolPropertiesInteractor: Interactor, EditSymbolPropertiesInteractorProtocol {
    
    private let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        super.init(managedObjectContext: symbol.flowChartManagedObjectContext)
    }
    
    var shapePreset: ShapePreset {
        get { return symbol.shapePreset }
        set { symbol.shapePreset = newValue }
    }
    
    var color: UIColor {
        get { return symbol.color }
        set { symbol.color = newValue }
    }
}

