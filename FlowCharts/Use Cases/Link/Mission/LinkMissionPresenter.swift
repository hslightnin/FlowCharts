//
//  LinkMissionContext.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

protocol LinkMissionInteractorProtocol: class {
    func focusLink(withIn transition: Transition)
    func unfocusLink(withIn transition: Transition)
}

protocol LinkLayoutObserverProtocol: class {
    var onLayoutChanged: (() -> Void)? { get set }
    func beginObservingLayout()
    func endObservingLayout()
}

class LinkMissionPresenter: ActivatableGroupPresenter {
    
    private let presenters: [UseCasePresenterProtocol]
    private let interactor: LinkMissionInteractorProtocol
    private let layoutObserver: LinkLayoutObserverProtocol
    
    init(presenters: [ActivatablePresenter & UseCasePresenterProtocol],
         interactor: LinkMissionInteractorProtocol,
         layoutObserver: LinkLayoutObserverProtocol) {
        
        self.presenters = presenters
        self.interactor = interactor
        self.layoutObserver = layoutObserver
        
        super.init(presenters: presenters)
        
        self.layoutObserver.onLayoutChanged = { [unowned self] in self.layout() }
    }
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        
        interactor.focusLink(withIn: transition)
        
        transition.addBeginning {
            self.layout()
            self.layoutObserver.beginObservingLayout()
        }
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        interactor.unfocusLink(withIn: transition)
        
        transition.addCompletion {
            self.layoutObserver.endObservingLayout()
        }
    }
    
    private func layout() {
        presenters.forEach { $0.layout() }
    }
}
