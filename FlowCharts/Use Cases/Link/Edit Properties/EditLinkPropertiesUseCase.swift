//
//  EditLinkPropertiesUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

class EditLinkPropertiesUseCase: EditLinkPropertiesUseCaseProtocol {
    
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    var onError: ((Error) -> Void)?
    
    init(link: FlowChartLink,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(link: link, diagramViewController: diagramViewController)
        let interactor = type(of: self).loadInteractor(link: link)
        
        let presenter = EditLinkPropertiesPresenter(
            ui: ui,
            interactor: interactor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(
        link: FlowChartLink,
        diagramViewController: DiagramViewController)
        -> EditLinkPropertiesUI {
        
        guard let linkPresenter = diagramViewController.presenter(for: link.dataSource) else {
            fatalError("Edit link properties IU requires link to be presented")
        }
        
        return EditLinkPropertiesUI(
            diagramViewController: diagramViewController,
            diagramScrollView: diagramViewController.diagramScrollView,
            linkView: linkPresenter.linkView)
    }
    
    class func loadInteractor(link: FlowChartLink)
        -> EditLinkPropertiesInteractor {
            
        return EditLinkPropertiesInteractor(link: link)
    }
}
