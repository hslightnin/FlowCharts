//
//  UseCasePresenter.swift
//  PresenterKit
//
//  Created by Alexandr Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

open class FlexiblePresenter: Presenter {
    
    // MARK: - Presentatiton
    
    open var needsFixedPresentationTransition: Bool {
        return false
    }
    
    open func createFixedPresentationTransition() -> Transition {
        fatalError("Must be implemented in sublasses")
    }
    
    public final func prepareFixedPresentationTransition() -> Transition {
        
        guard needsFixedDismissionTransition else {
            fatalError("Use case presenter can't be presented with fixed transition")
        }
        
        let transition = createFixedPresentationTransition()
        configurePresentation(withIn: transition)
        return transition
    }
    
    public final func prepareForPresentation(withIn arbitraryTransition: Transition) {
        
        guard !needsFixedDismissionTransition else {
            fatalError("Use case presenter can't be presented with free transition")
        }
        
        configurePresentation(withIn: arbitraryTransition)
    }
    
    // MARK: - Dismission
    
    open var needsFixedDismissionTransition: Bool {
        return false
    }
    
    open func createFixedDismissionTransition() -> Transition {
        fatalError("Must be implemented in sublasses")
    }
    
    public final func prepareFixedDismissionTransition() -> Transition {
        
        guard needsFixedDismissionTransition else {
            fatalError("Use case presenter can't be dismissed with fixed transition")
        }
        
        let transition = createFixedDismissionTransition()
        configureDismission(withIn: transition)
        return transition
    }
    
    public final func prepareForDismission(withIn arbitraryTransition: Transition) {
        
        guard !needsFixedDismissionTransition else {
            fatalError("Use case presenter can't be presented with free transition")
        }
        
        configureDismission(withIn: arbitraryTransition)
    }
}

public extension FlexiblePresenter {
    
    func present(with preferredTransition: @autoclosure () -> Transition) {
        preparePresentationTransition(preferredTransition: preferredTransition).perform()
    }
    
    func preparePresentationTransition(preferredTransition: @autoclosure () -> Transition) -> Transition {
        if needsFixedPresentationTransition {
            return prepareFixedPresentationTransition()
        } else {
            let transition = preferredTransition()
            prepareForPresentation(withIn: transition)
            return transition
        }
    }
    
    func dismiss(with preferredTransition: @autoclosure () -> Transition) {
        prepareDismissionTransition(preferredTransition: preferredTransition).perform()
    }
    
    func prepareDismissionTransition(preferredTransition: @autoclosure () -> Transition) -> Transition {
        if needsFixedDismissionTransition {
            return prepareFixedDismissionTransition()
        } else {
            let transition = preferredTransition()
            prepareForDismission(withIn: transition)
            return transition
        }
    }
}

