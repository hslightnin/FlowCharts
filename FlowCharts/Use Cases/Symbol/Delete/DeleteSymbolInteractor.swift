//
//  DeleteSymbolInteractor.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 09/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

class DeleteSymbolInteractor: Interactor, DeleteSymbolInteractorProtocol {
    
    private let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        super.init(managedObjectContext: symbol.flowChartManagedObjectContext)
    }
    
    func delete() {
        DeleteSymbolHelper.delete(symbol: symbol)
    }
}
