//
//  EditLinkAnchorUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 09/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

class EditLinkAnchorUseCase: EditLinkAnchorUseCaseProtocol {
    
    let presenter: ActivatablePresenter & UseCasePresenterProtocol
    
    var onError: ((Error) -> Void)?
    
    init(anchor: FlowChartLinkAnchor,
         diagramViewController: DiagramViewController,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol) {
        
        let ui = type(of: self).loadUI(anchor: anchor, diagramViewController: diagramViewController)
        let moveInteractor = type(of: self).loadMoveInteractor(anchor: anchor)
        let editPropertiesInteractor = type(of: self).loadEditPropertiesInteractor(anchor: anchor)
        
        let presenter = EditLinkAnchorPresenter(
            ui: ui,
            moveInteractor: moveInteractor,
            editPropertiesInteractor: editPropertiesInteractor,
            buttonsLayoutManager: buttonsLayoutManager,
            coordinatesConverter: diagramViewController)
        
        self.presenter = presenter
        
        presenter.onError = { [unowned self] in self.onError?($0) }
    }
    
    class func loadUI(anchor: FlowChartLinkAnchor, diagramViewController: DiagramViewController) -> EditLinkAnchorUI {
        return EditLinkAnchorUI(
            diagramViewController: diagramViewController,
            diagramScrollView: diagramViewController.diagramScrollView)
    }
    
    class func loadMoveInteractor(anchor: FlowChartLinkAnchor) -> MoveLinkAnchorInteractor {
        return MoveLinkAnchorInteractor(anchor: anchor)
    }
    
    class func loadEditPropertiesInteractor(anchor: FlowChartLinkAnchor) -> EditLinkAnchorPropertiesInteractor {
        return EditLinkAnchorPropertiesInteractor(anchor: anchor)
    }
}
