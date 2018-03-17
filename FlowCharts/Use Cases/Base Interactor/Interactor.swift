//
//  ManagedObjectContextInteractor.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 09/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import CoreData
import PresenterKit

protocol InteractorProtocol: class {
    var isFinished: Bool { get }
    func processPendingChanges(withIn transition: Transition)
    func save(withIn transition: Transition) throws
    func rollback(withIn transition: Transition)
}

extension InteractorProtocol {
    
    func processPendingChanges(with transition: Transition) {
        processPendingChanges(withIn: transition)
        transition.perform()
    }
    
    func save(with transition: Transition = .instant()) throws {
        try save(withIn: transition)
        transition.perform()
    }
    
    func rollback(with transition: Transition = .instant()) {
        rollback(withIn: transition)
        transition.perform()
    }
}

class Interactor: InteractorProtocol {
    
    let managedObjectContext: FlowChartManagedObjectContext
    
    private(set) var isFinished = false
    
    init(managedObjectContext: FlowChartManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    func save(withIn transition: Transition) throws {
        try managedObjectContext.manager.save(withIn: transition)
        isFinished = true
    }
    
    func rollback(withIn transition: Transition) {
        managedObjectContext.manager.rollback(withIn: transition)
        isFinished = true
    }
    
    final func processPendingChanges(withIn transition: Transition) {
        managedObjectContext.manager.processPendingChanges(withIn: transition)
    }
}
