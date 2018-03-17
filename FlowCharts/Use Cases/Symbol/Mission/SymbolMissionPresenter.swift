//
//  SymbolMissionPresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 13/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import DiagramGeometry
import DiagramView
import PresenterKit

protocol SymbolMissionInteractorProtocol: class {
    func focusSymbol(withIn transition: Transition)
    func unfocusSymbol(withIn transition: Transition)
}

protocol SymbolLayoutObserverProtocol: class {
    var onLayoutChanged: (() -> Void)? { get set }
    func beginObservingLayout()
    func endObservingLayout()
}

class SymbolMissionPresenter: ActivatableGroupPresenter {
    
    private let presenters: [UseCasePresenterProtocol]
    private let interactor: SymbolMissionInteractorProtocol
    private let layoutObserver: SymbolLayoutObserverProtocol
    
    init(presenters: [ActivatablePresenter & UseCasePresenterProtocol],
         interactor: SymbolMissionInteractorProtocol,
         layoutObserver: SymbolLayoutObserverProtocol) {
        
        self.presenters = presenters
        self.interactor = interactor
        self.layoutObserver = layoutObserver
        
        super.init(presenters: presenters)
        
        self.layoutObserver.onLayoutChanged = { [unowned self] in self.layout() }
    }
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        interactor.focusSymbol(withIn: transition)
        
        transition.addBeginning {
            self.layout()
            self.layoutObserver.beginObservingLayout()
        }
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        interactor.unfocusSymbol(withIn: transition)
        
        transition.addCompletion {
            self.layoutObserver.endObservingLayout()
        }
    }
    
    private func layout() {
        presenters.forEach { $0.layout() }
    }
}
