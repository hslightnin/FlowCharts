//
//  BuildLinkUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

class BuildLinkUseCase: BuildLinkUseCaseProtocol {
    
    var onEnded: ((FlowChartLink, FlowChartSymbol?) -> Void)?
    var onError: ((Error) -> Void)?
    let presenter: ActivatablePresenter & UseCasePresenterProtocol

    init(anchor: FlowChartSymbolAnchor,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(anchor: anchor)
        
        let presenter = BuildLinkPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        ui.layoutDelegate = presenter
        
        self.presenter = presenter
        
        presenter.onEnded = { [unowned self] in self.onEnded?(interactor.addedLink!, interactor.addedSymbol) }
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(diagramViewController: DiagramViewController) -> BuildLinkUI {
        
        guard let diagramPresenter = diagramViewController.diagramPresenter else {
            fatalError("Build link UI requires diagram to be presented")
        }
        
        return BuildLinkUI(
            diagramViewController: diagramViewController,
            diagramBackgroundView: diagramPresenter.backgroundView,
            diagramScrollView: diagramViewController.diagramScrollView,
            diagramContentView: diagramPresenter.diagramView)
    }
    
    class func loadInteractor(anchor: FlowChartSymbolAnchor) -> BuildLinkInteractor {
        return BuildLinkInteractor(anchor: anchor)
    }
}
