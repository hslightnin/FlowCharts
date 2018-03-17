//
//  SymbolMissionInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

class SymbolMissionInteractor: SymbolMissionInteractorProtocol {
    
    private let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
    }
    
    func focusSymbol(withIn transition: Transition) {
        symbol.dataSource.focus(withIn: transition)
    }
    
    func unfocusSymbol(withIn transition: Transition) {
        symbol.dataSource.unfocus(withIn: transition)
    }
}
