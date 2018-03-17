//
//  EditLinkTextUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

class EditLinkTextUseCase: EditLinkTextUseCaseProtocol {
    
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    var onError: ((Error) -> Void)?
    
    init(link: FlowChartLink,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(link: link, diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(link: link)
        
        let presenter = EditLinkTextPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(link: FlowChartLink, diagramViewController: DiagramViewController) -> EditTextUI {
            
        guard let diagramContentView = diagramViewController.diagramContentView else {
            fatalError("Edit link text IU requires diagram to be presented")
        }
        
        guard let linkPresenter = diagramViewController.presenter(for: link.dataSource) else {
            fatalError("Edit link text IU requires link to be presented")
        }
        
        return EditTextUI(
            diagramScrollView: diagramViewController.diagramScrollView,
            diagramContentView: diagramContentView,
            itemView: linkPresenter.linkView)
    }
    
    class func loadInteractor(link: FlowChartLink) -> EditLinkTextInteractor {
        return EditLinkTextInteractor(link: link)
    }
}
