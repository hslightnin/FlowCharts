//
//  ActivatableGroupPresenter.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 09/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

open class ActivatableGroupPresenter: ActivatablePresenter, ActivatableUseCasePresenterTransitionsDelegate {
    
    private let presenters: [ActivatablePresenter]
    private var activePresenter: ActivatablePresenter?

    public init(presenters: [ActivatablePresenter]) {
        self.presenters = presenters
        
        super.init()
        
        self.presenters.forEach { presenter in
            
            presenter.onPrepareActivation = { [unowned self] transition in
                self.prepareForPresenterActivation(presenter, withIn: transition)
            }
            
            presenter.onPrepareDeactivation = { [unowned self] transition in
                self.prepareForPresenterDeactivation(presenter, withIn: transition)
            }
            
            presenter.transitionsDelegate = self
        }
    }
    
    open override func setUpPresentation(withIn transition: Transition) {
        for presenter in presenters {
            presenter.prepareForPresentation(withIn: transition)
        }
    }
    
    private var presenterWithFixedDismissionTransition: ActivatablePresenter? {
        return presenters.first { $0.needsFixedDismissionTransition }
    }
    
    open override var needsFixedDismissionTransition: Bool {
        return presenterWithFixedDismissionTransition != nil
    }
    
    open override func createFixedDismissionTransition() -> Transition {
        return presenterWithFixedDismissionTransition!.prepareFixedDismissionTransition()
    }
    
    open override func setUpDismission(withIn transition: Transition) {
        for presenter in presenters where presenter.isOn && !presenter.needsFixedDismissionTransition {
            presenter.prepareForDismission(withIn: transition)
        }
    }
    
    open override func setUpActivation(withIn transition: Transition) {
        for presenter in presenters where presenter !== activePresenter {
            presenter.prepareForDismission(withIn: transition)
        }
    }
    
    open override func setUpDeactivation(withIn transition: Transition) {
        for presenter in presenters where presenter !== activePresenter {
            presenter.prepareForPresentation(withIn: transition)
        }
    }
    
    func prepareForPresenterActivation(_ presenter: ActivatablePresenter, withIn transition: Transition) {
        activePresenter = presenter
        activate(withIn: transition)
    }
    
    func prepareForPresenterDeactivation(_ presenter: ActivatablePresenter, withIn transition: Transition) {
        deactivate(withIn: transition)
        activePresenter = nil
    }
    
    func activatableUseCasePresenter(_ presenter: ActivatablePresenter, willActivateWithIn transition: Transition) {
//        activePresenter = presenter
//        activate(withIn: transition)
    }
    
    func activatableUseCasePresenter(_ presenter: ActivatablePresenter, willDeactivateWithIn transition: Transition) {
//        deactivate(withIn: transition)
//        activePresenter = nil
    }
}
