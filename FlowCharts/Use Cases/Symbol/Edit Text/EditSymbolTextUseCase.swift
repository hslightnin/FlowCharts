//
//  EditSymbolTextUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry
import DiagramView

class EditSymbolTextUseCase: EditSymbolTextUseCaseProtocol {
    
    var onError: ((Error) -> Void)?
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    init(symbol: FlowChartSymbol,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(symbol: symbol, diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(symbol: symbol)
        
        let presenter = EditSymbolTextPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) -> EditTextUI {
        
        guard let diagramContentView = diagramViewController.diagramContentView else {
            fatalError("Edit symbol text UI diagram must be presented")
        }
        
        guard let symbolPresenter = diagramViewController.presenter(for: symbol.dataSource) else {
            fatalError("Edit symbol text UI symbol must be presented")
        }
        
        return EditTextUI(
            diagramScrollView: diagramViewController.diagramScrollView,
            diagramContentView: diagramContentView,
            itemView: symbolPresenter.symbolView)
    }
    
    class func loadInteractor(symbol: FlowChartSymbol) -> EditSymbolTextInteractor {
        return EditSymbolTextInteractor(symbol: symbol)
    }
}
