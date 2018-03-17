//
//  MoveSymbolUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramView
import PresenterKit

class MoveSymbolUseCase: MoveSymbolUseCaseProtocol {
    
    var onError: ((Error) -> Void)?
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    init(symbol: FlowChartSymbol, diagramViewConroller: DiagramViewController) {
        
        let ui = type(of: self).loadUI(symbol: symbol, diagramViewConroller: diagramViewConroller)
        let interactor = type(of: self).loadInteractor(symbol: symbol)
        
        let presenter = MoveSymbolPresenter(
            ui: ui,
            interactor: interactor,
            coordinatesConverter: diagramViewConroller)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(symbol: FlowChartSymbol, diagramViewConroller: DiagramViewController) -> MoveSymbolUI {
        
        guard let symbolPresenter = diagramViewConroller.presenter(for: symbol.dataSource) else {
            fatalError("Move symbol UI requires symbol must be presented")
        }
        
        return MoveSymbolUI(symbolView: symbolPresenter.symbolView)
    }
    
    class func loadInteractor(symbol: FlowChartSymbol) -> MoveSymbolInteractor {
        return MoveSymbolInteractor(symbol: symbol)
    }
}
