//
//  StubContinuousInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
@testable import FlowCharts

class StubContinuousInteractor: StubInteractor, ContinuousInteractorProtocol {
    
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
