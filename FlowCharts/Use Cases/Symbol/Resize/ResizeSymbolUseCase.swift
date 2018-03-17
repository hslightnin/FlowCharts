//
//  ResizeSymbolUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramView
import PresenterKit

class ResizeSymbolUseCase: ResizeSymbolUseCaseProtocol {
    
    var onError: ((Error) -> Void)?
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    init(symbol: FlowChartSymbol,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(symbol: symbol)
        
        let presenter = ResizeSymbolPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(diagramViewController: DiagramViewController) -> ResizeSymbolUI {
        return ResizeSymbolUI(diagramScrollView: diagramViewController.diagramScrollView)
    }
    
    class func loadInteractor(symbol: FlowChartSymbol) -> ResizeSymbolInteractor {
        return ResizeSymbolInteractor(symbol: symbol)
    }
}
