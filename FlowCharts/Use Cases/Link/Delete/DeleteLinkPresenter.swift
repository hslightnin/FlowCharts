//
//  DeleteLinkUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 31/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit

protocol DeleteLinkInteractorProtocol: InteractorProtocol {
    func deleteLink()
}

class DeleteLinkPresenter: ActivatablePresenter, UseCasePresenterProtocol, DeleteUILayoutDelegate {

    private let ui: DeleteUIProtocol
    private let interactor: DeleteLinkInteractorProtocol
    private let buttonsLayoutManager: LinkButtonsLayoutManagerProtocol
    
    var onError: ((Error) -> Void)?
    var onDeleted: ((Transition) -> Void)?
    
    init(ui: DeleteUIProtocol,
         interactor: DeleteLinkInteractorProtocol,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onButtonPressed = { [unowned self] in self.buttonPressed() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonDismission(withIn: transition)
    }
    
    // MARK: - Interactions
    
    private func buttonPressed() {
        do {
            interactor.deleteLink()
            let transition = Transition.defaultDismission()
            try interactor.save(withIn: transition)
            onDeleted?(transition)
            transition.perform()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.deleteButtonLocation(in: view)
    }
    
    func layout() {
        ui.layout()
    }
}
