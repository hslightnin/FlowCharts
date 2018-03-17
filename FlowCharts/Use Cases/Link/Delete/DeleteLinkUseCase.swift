//
//  DeleteLinkUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

class DeleteLinkUseCase: DeleteLinkUseCaseProtocol {
    
    var presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    var onDeleted: ((Transition) -> Void)?
    var onError: ((Error) -> Void)?
    
    init(link: FlowChartLink,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(link: link, diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(link: link)
        
        let presenter = DeleteLinkPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager)
        
        self.presenter = presenter
        
        presenter.onDeleted = { [unowned self] in self.onDeleted?($0) }
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(link: FlowChartLink, diagramViewController: DiagramViewController) -> DeleteUI {
        return DeleteUI(diagramScrollView: diagramViewController.diagramScrollView)
    }
    
    class func loadInteractor(link: FlowChartLink) -> DeleteLinkInteractor {
        return DeleteLinkInteractor(link: link)
    }
}
