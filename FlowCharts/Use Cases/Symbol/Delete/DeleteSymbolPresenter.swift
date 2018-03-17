//
//  DeleteSymbolUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol DeleteSymbolInteractorProtocol: InteractorProtocol {
    func delete()
}

class DeleteSymbolPresenter: ActivatablePresenter, UseCasePresenterProtocol, DeleteUILayoutDelegate {
    
    private let ui: DeleteUIProtocol
    private let interactor: DeleteSymbolInteractorProtocol
    private let buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol
    
    var onDeleted: ((Transition) -> ())?
    var onError: ((Error) -> Void)?

    init(ui: DeleteUIProtocol,
         interactor: DeleteSymbolInteractorProtocol,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onButtonPressed = { [unowned self] in self.buttonTapped() }
    }
    
    // MARK: - Lifecycle

    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }

    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        ui.prepareForButtonDismission(withIn: transition)
    }

    // MARK: - Interactions
    
    func buttonTapped() {
        do {
            interactor.delete()
            let transition = Transition.defaultChangeover()
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
