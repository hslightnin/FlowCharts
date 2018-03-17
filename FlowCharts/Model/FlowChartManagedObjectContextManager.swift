//
//  FlowChart.swift
//  FlowCharts
//
//  Created by alex on 04/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData
import PresenterKit

enum FlowChartManagedObjectContextError: Error {
    case fetchError(Error)
    case contextDoesNotHaveDiagram
}

class FlowChartManagedObjectContextManager {

    let persistentManagedObjectContext: NSManagedObjectContext
    private(set) var liveManagedObjectContext: FlowChartManagedObjectContext!
    private(set) var diagram: FlowChartDiagram!
    
    private var needsRefresh = false

    init(persistentManagedObjectContext: NSManagedObjectContext) throws {
        
        self.persistentManagedObjectContext = persistentManagedObjectContext
        self.liveManagedObjectContext = FlowChartManagedObjectContext(
            concurrencyType: .mainQueueConcurrencyType,
            manager: self)
        self.liveManagedObjectContext.parent = self.persistentManagedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Diagram")
        do {
            let diagrams = try self.liveManagedObjectContext.fetch(fetchRequest)
            if diagrams.count != 1 {
                throw FlowChartManagedObjectContextError.contextDoesNotHaveDiagram
            } else {
                self.diagram = diagrams[0] as! FlowChartDiagram
            }
        } catch let error {
            throw FlowChartManagedObjectContextError.fetchError(error)
        }
    }
    
    func startObservingContext() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(liveManagedObjectContextObjectsDidChange(_:)),
            name: .NSManagedObjectContextObjectsDidChange,
            object: liveManagedObjectContext)
    }
    
    func stopObservingContext() {
        NotificationCenter.default.removeObserver(
            self, name: .NSManagedObjectContextObjectsDidChange,
            object: liveManagedObjectContext)
    }
    
//    func undo() {
//
////        liveManagedObjectContext.undo()
////        try! liveManagedObjectContext.save()
//
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(self.persistentManagedObjectContextObjectsDidChange(_:)),
//            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
//            object: self.persistentManagedObjectContext)
//
//        self.persistentManagedObjectContext.undo()
//
//        NotificationCenter.default.removeObserver(self,
//            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
//            object: self.persistentManagedObjectContext)
//    }
//
//    func redo() {
//
////        liveManagedObjectContext.redo()
////        try! liveManagedObjectContext.save()
//
//        NotificationCenter.default.addObserver(self,
//            selector: #selector(self.persistentManagedObjectContextObjectsDidChange(_:)),
//            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
//            object: self.persistentManagedObjectContext)
//
////        let can = self.persistentManagedObjectContext.undoManager?.canRedo
//        self.persistentManagedObjectContext.redo()
//
//        NotificationCenter.default.removeObserver(self,
//            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
//            object: self.persistentManagedObjectContext)
//    }
//
//    @objc func persistentManagedObjectContextObjectsDidChange(_ notification: Notification) {
//        needsRefresh = true
//        liveManagedObjectContext.mergeChanges(fromContextDidSave: notification)
//    }
    
    var currentTransition: Transition?
    
    // NSManagedObjectContextObjectsDidChange can be fired twice while rollback
    // Seems like a bug: https://forums.developer.apple.com/thread/28972
    // Saving previous notificatio so we can skip if it is fired again
    var prevNotification: Notification?
    
    func save(withIn transition: Transition) throws {
        currentTransition = transition
        try liveManagedObjectContext.save()
        currentTransition = nil
    }
    
    func rollback(withIn transition: Transition) {
        currentTransition = transition
        liveManagedObjectContext.rollback()
        currentTransition = nil
    }
    
    func processPendingChanges(withIn transition: Transition) {
        currentTransition = transition
        liveManagedObjectContext.processPendingChanges()
        currentTransition = nil
    }
    
    @objc func liveManagedObjectContextObjectsDidChange(_ notification: Notification) {
        if let transition = currentTransition {
            // See comment for notificationHandled
            let isTheSame = prevNotification == notification
            prevNotification = notification
            if !isTheSame {
                diagram.noteManagedObjectContextDidChange(notification: notification, withIn: transition)
            }
        } else {
            let transition = Transition.instant()
            diagram.noteManagedObjectContextDidChange(notification: notification, withIn: transition)
            transition.perform()
        }
    }
}
