//
//  StubInteractor.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
@testable import FlowCharts

class StubInteractor: InteractorProtocol {
    
    var isFinished: Bool = false
    
    func processPendingChanges(withIn transition: Transition) {
        
    }
    
    var saveFails = false
    var saveSucceeds: Bool {
        get { return !saveFails }
        set { saveFails = !newValue }
    }
    
    var hasSaved = false
    
    func save(withIn transition: Transition) throws {
        self.hasSaved = true
        if saveFails {
            throw DebugError()
        }
        self.isFinished = true
    }
    
    var hasRolledBack = false
    
    func rollback(withIn transition: Transition) {
        self.hasRolledBack = true
        self.isFinished = true
    }
}
