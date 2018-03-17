//
//  EditSymbolTextUseCaseInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class EditSymbolTextInteractor: ContinuousInteractor, EditSymbolTextInteractorProtocol {

    private let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        super.init(managedObjectContext: symbol.flowChartManagedObjectContext)
    }
    
    var text: String? {
        get { return symbol.string }
        set { symbol.string = newValue }
    }
    
    var font: UIFont {
        return symbol.font
    }
    
    var textAreaPath: BezierPath {
        return symbol.shape.textAreaPath
    }
    
    var textInsets: Vector {
        return symbol.textInsets
    }
}
