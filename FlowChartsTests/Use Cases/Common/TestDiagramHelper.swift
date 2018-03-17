//
//  TestDiagramHelper.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import CoreData
import DiagramGeometry
@testable import FlowCharts

class TestDiagramHelper {
    
    let contextManager: FlowChartManagedObjectContextManager
    let context: FlowChartManagedObjectContext
    let diagram: FlowChartDiagram
    
    init() {
        
        let modelBundle = Bundle(for: MoveSymbolInteractor.self)
        let modelURL = modelBundle.url(forResource: "FlowCharts", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! coordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let persistentContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        persistentContext.persistentStoreCoordinator = coordinator
        
        let persistentContextDiagram = NSEntityDescription.insertNewObject(
            forEntityName: "Diagram",
            into: persistentContext) as! FlowChartDiagram
        persistentContextDiagram.width = 1000
        persistentContextDiagram.height = 1000
        try! persistentContext.save()
        
        contextManager = try! FlowChartManagedObjectContextManager(persistentManagedObjectContext: persistentContext)
        context = contextManager.liveManagedObjectContext
        diagram = contextManager.diagram
    }
    
    func save() {
        try! context.save()
    }
    
    @discardableResult
    func createSymbol(x: Double = 0.0, y: Double = 0.0, width: Double = 0.0, height: Double = 0.0) -> FlowChartSymbol {
        let symbol = NSEntityDescription.insertNewObject(
            forEntityName: "Symbol",
            into: context) as! FlowChartSymbol
        symbol.x = x
        symbol.y = y
        symbol.width = width
        symbol.height = height
        symbol.shapePreset = .rect
        symbol.color = .white
        createAnchor(for: symbol, direction: .up)
        createAnchor(for: symbol, direction: .down)
        createAnchor(for: symbol, direction: .right)
        createAnchor(for: symbol, direction: .left)
        LayoutSymbolAnchorsHelper.layoutAnchors(for: symbol)
        symbol.diagram = diagram
        return symbol
    }
    
    @discardableResult
    private func createAnchor(for symbol: FlowChartSymbol, direction: Direction) -> FlowChartSymbolAnchor {
        let anchor = NSEntityDescription.insertNewObject(
            forEntityName: "SymbolAnchor",
            into: symbol.managedObjectContext!) as! FlowChartSymbolAnchor
        anchor.direction = direction
        anchor.symbol = symbol
        return anchor
    }
}
