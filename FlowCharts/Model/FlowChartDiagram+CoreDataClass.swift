//
//  FlowChartDiagram+CoreDataClass.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation
import CoreData
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartDiagram: FlowChartManagedObject {
    
    var size: Size {
        return Size(width, height)
    }
    
    var symbolDataSources: [FlowChartSymbolDataSource] {
        return flowChartSymbols.array
            .map { $0 as! FlowChartSymbol }
            .map { $0.dataSource }
    }
    
    var linkDataSources: [FlowChartLinkDataSource] {
        return flowChartLinks.array
            .map { $0 as! FlowChartLink }
            .map { $0.dataSource }
    }
    
    lazy var dataSource: FlowChartDiagramDataSource = {
        return FlowChartDiagramDataSource(diagram: self)
    }()
    
    func noteManagedObjectContextDidChange(notification: Notification, withIn transition: Transition) {
        
        let changedKeys = changedValuesForCurrentEvent().keys
        
        if changedKeys.contains("width") ||
            changedKeys.contains("height") {
            
            dataSource.updateSize(withIn: transition)
        }
        
        let userInfo = notification.userInfo!
        let insertedObjects = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>
        let deletedObjects = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>
        let changedObjects = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>

        let insertedSymbols = insertedObjects?.flatMap { $0 as? FlowChartSymbol }
        insertedSymbols?.forEach { $0.noteObjectInserted(withIn: transition) }
        
        let insertedSymbolDataSources = insertedSymbols?.map { $0.dataSource }
        
        if insertedSymbolDataSources != nil && !insertedSymbolDataSources!.isEmpty {
            dataSource.addSymbolDataSources(insertedSymbolDataSources!, withIn: transition)
        }
        
        let deletedSymbolDataSources = deletedObjects?
            .flatMap { $0 as? FlowChartSymbol }
            .map { $0.dataSource }
        
        if deletedSymbolDataSources != nil && !deletedSymbolDataSources!.isEmpty {
            dataSource.removeSymbolDataSources(deletedSymbolDataSources!, withIn: transition)
        }
        
        changedObjects?
            .flatMap { $0 as? FlowChartSymbol }
            .forEach { $0.noteObjectDidChange(withIn: transition) }
        
        let insertedLinkDataSources = insertedObjects?
            .flatMap { $0 as? FlowChartLink }
            .map { $0.dataSource }
        
        if insertedLinkDataSources != nil && !insertedLinkDataSources!.isEmpty {
            dataSource.addLinkDataSources(insertedLinkDataSources!, withIn: transition)
        }
        
        let deletedLinkDataSources = deletedObjects?
            .flatMap { $0 as? FlowChartLink }
            .map { $0.dataSource }
        
        if deletedLinkDataSources != nil && !deletedLinkDataSources!.isEmpty {
            dataSource.removeLinkDataSources(deletedLinkDataSources!, withIn: transition)
        }
        
        var changedLinks = Set<FlowChartLink>()
        changedLinks.formUnion(changedObjects?
            .flatMap { $0 as? FlowChartLink } ?? [])
        changedLinks.formUnion(changedObjects?
            .flatMap { $0 as? FlowChartLinkAnchor }
            .map { $0.link } ?? [])
        
        changedLinks.forEach { $0.noteObjectDidChange(withIn: transition) }
    }
}
