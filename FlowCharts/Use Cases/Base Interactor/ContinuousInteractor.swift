//
//  ContinuousInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit

protocol ContinuousInteractorProtocol: InteractorProtocol {
    var isInteracting: Bool { get }
    func begin()
}

extension ContinuousInteractorProtocol {
    
    func save(with transition: Transition = .instant()) throws {
        try save(withIn: transition)
        transition.perform()
    }
    
    func rollback(with transition: Transition = .instant()) {
        rollback(withIn: transition)
        transition.perform()
    }
}


class ContinuousInteractor: Interactor, ContinuousInteractorProtocol {
    
    private(set) var isInteracting = false
    
    func begin() {
        isInteracting = true
    }
    
    override func save(withIn transition: Transition) throws {
        isInteracting = false
        try super.save(withIn: transition)
    }
    
    override func rollback(withIn transition: Transition) {
        isInteracting = false
        super.rollback(withIn: transition)
    }
}
