//
//  RigidPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

open class FixedPresenter: Presenter {
    
    // MARK: - Presentation
    
    open func createPresentationTransition() -> Transition {
        fatalError("Must be implemented in subclasses")
    }
    
    public final func preparePresentationTransition() -> Transition {
        let transition = createPresentationTransition()
        configurePresentation(withIn: transition)
        return transition
    }
    
    public final func present() {
        let transition = preparePresentationTransition()
        transition.perform()
    }
    
    // MARK: - Dismission
    
    open func createDismissionTransition() -> Transition {
        fatalError("Must be implemented in subclasses")
    }
    
    public final func prepareDismissionTransition() -> Transition {
        let transition = createDismissionTransition()
        configureDismission(withIn: transition)
        return transition
    }
    
    public final func dismiss() {
        let transition = prepareDismissionTransition()
        transition.perform()
    }
}
