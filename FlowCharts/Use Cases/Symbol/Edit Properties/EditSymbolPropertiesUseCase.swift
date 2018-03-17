//
//  EditSymbolPropertiesUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramView
import PresenterKit

class EditSymbolPropertiesUseCase: EditSymbolPropertiesUseCaseProtocol {
    
    var onError: ((Error) -> Void)?
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    init(symbol: FlowChartSymbol,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(symbol: symbol, diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(symbol: symbol)
        
        let presenter = EditSymbolPropertiesPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) -> EditSymbolPropertiesUI {
        
        guard let symbolPresenter = diagramViewController.presenter(for: symbol.dataSource) else {
            fatalError("Edit symbol properties IU requires symbol to be presented")
        }
        
        return EditSymbolPropertiesUI(
            diagramViewController: diagramViewController,
            diagramScrollView: diagramViewController.diagramScrollView,
            symbolView: symbolPresenter.symbolView)
    }
    
    class func loadInteractor(symbol: FlowChartSymbol) -> EditSymbolPropertiesInteractor {
        return EditSymbolPropertiesInteractor(symbol: symbol)
    }
}
