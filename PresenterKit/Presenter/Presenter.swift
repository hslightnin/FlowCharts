//
//  Presenter.swift
//  PresenterKit
//
//  Created by Alexandr Kozlov on 22/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation

public enum PresenterState {
    case dismissed
    case dismissing
    case presented
    case presenting
}

open class Presenter: NSObject {
    
    public private(set) var currentTransition: Transition?
    public private(set) var state: PresenterState = .dismissed
    
    public var isOn: Bool {
        return state == .presented || state == .presenting
    }
    
    public var isOff: Bool {
        return !isOn
    }
    
    open func setUpPresentation(withIn transition: Transition) {
        
    }
    
    open func setUpDismission(withIn transition: Transition) {
        
    }
    
    internal func configurePresentation(withIn transition: Transition) {
        
        configure(transition)
        setUpPresentation(withIn: transition)
        
        transition.add(beginning: {
            guard self.state == .dismissed else {
                fatalError("Presenter must be in dismissed state before presentation")
            }
            self.state = .presenting
        }, completion: {
            self.state = .presented
        })
    }
    
    internal func configureDismission(withIn transition: Transition) {
        
        configure(transition)
        setUpDismission(withIn: transition)
        
        transition.add(beginning: {
            guard self.state == .presented else {
                fatalError("Presenter must be in presented state before dismission")
            }
            self.state = .dismissing
        }, completion: {
            self.state = .dismissed
        })
    }
    
    final func configure(_ transition: Transition) {
        transition.add(beginning: {
            self.currentTransition?.end()
            self.currentTransition = transition
        }, completion: {
            self.currentTransition = nil
        })
    }
}
