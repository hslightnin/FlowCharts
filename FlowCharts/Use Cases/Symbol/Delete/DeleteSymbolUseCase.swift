//
//  DeleteSymbolUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramView
import PresenterKit

class DeleteSymbolUseCase: DeleteSymbolUseCaseProtocol {
    
    var onDeleted: ((Transition) -> Void)?
    var onError: ((Error) -> Void)?
    private(set) var presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    init(symbol: FlowChartSymbol,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(symbol: symbol)
        
        let presenter = DeleteSymbolPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager)
        
        ui.layoutDelegate = presenter
        
        self.presenter = presenter
        
        presenter.onDeleted = { [unowned self] in self.onDeleted?($0) }
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(diagramViewController: DiagramViewController) -> DeleteUI {
        return DeleteUI(diagramScrollView: diagramViewController.diagramScrollView)
    }
    
    class func loadInteractor(symbol: FlowChartSymbol) -> DeleteSymbolInteractor {
        return DeleteSymbolInteractor(symbol: symbol)
    }
}
