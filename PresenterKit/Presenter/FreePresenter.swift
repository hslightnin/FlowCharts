//
//  TransitionalPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

open class FreePresenter: Presenter {
    
    public final func prepareForPresentation(withIn transition: Transition) {
        configurePresentation(withIn: transition)
    }
    
    public final func prepareForDismission(withIn transition: Transition) {
        configureDismission(withIn: transition)
    }
}

public extension FreePresenter {
    
    public func present(with transition: Transition) {
        prepareForPresentation(withIn: transition)
        transition.perform()
    }
    
    public func dismiss(with transition: Transition) {
        prepareForDismission(withIn: transition)
        transition.perform()
    }
}
