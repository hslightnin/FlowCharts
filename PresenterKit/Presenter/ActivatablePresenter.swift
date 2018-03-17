//
//  ActivatableUseCasePresenter.swift
//  PresenterKit
//
//  Created by Alexander Kozlov on 27/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

protocol ActivatableUseCasePresenterTransitionsDelegate: class {
    func activatableUseCasePresenter(_ presenter: ActivatablePresenter, willActivateWithIn transition: Transition)
    func activatableUseCasePresenter(_ presenter: ActivatablePresenter, willDeactivateWithIn transition: Transition)
}

open class ActivatablePresenter: FlexiblePresenter {
    
    public private(set) var isActivated = false
    public var isDeactivated: Bool { return !isActivated }
    
    weak var transitionsDelegate: ActivatableUseCasePresenterTransitionsDelegate?
    
    var onPrepareActivation: ((Transition) -> Void)?
    var onPrepareDeactivation: ((Transition) -> Void)?
    
    open func setUpActivation(withIn transition: Transition) {
    
    }
    
    open func setUpDeactivation(withIn transition: Transition) {
        
    }
    
    public final func activate(withIn transition: Transition) {
        
        configure(transition)
        setUpActivation(withIn: transition)
        
        transitionsDelegate?.activatableUseCasePresenter(self, willActivateWithIn: transition)
        onPrepareActivation?(transition)
        
        transition.addBeginning {
            self.isActivated = true
        }
    }
    
    public final func activate(with transition: Transition) {
        activate(withIn: transition)
        transition.perform()
    }
    
    public final func deactivate(withIn transition: Transition) {
        
        configure(transition)
        setUpDeactivation(withIn: transition)
        
        transitionsDelegate?.activatableUseCasePresenter(self, willDeactivateWithIn: transition)
        onPrepareDeactivation?(transition)
        
        transition.addBeginning {
            self.isActivated = false
        }
    }
    
    public final func deactivate(with transition: Transition) {
        deactivate(withIn: transition)
        transition.perform()
    }
}
