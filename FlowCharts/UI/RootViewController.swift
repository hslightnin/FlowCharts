//
//  RootViewController.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 11/06/16.
//  Copyright © 2016 Brown Coats. All rights reserved.
//

import UIKit
import CoreData
import DiagramGeometry
import DiagramView

class RootViewController: UIViewController {
    
    private var diagramViewController: DiagramViewController!
    private var contextManager: FlowChartManagedObjectContextManager!
    private var missionControl: MissionControl!
    
    @IBOutlet var undoBarButtonItem: UIBarButtonItem!
    @IBOutlet var redoBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let modelURL = Bundle.main.url(forResource: "FlowCharts", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! storeCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        managedObjectContext.undoManager = UndoManager()
        let diagram = NSEntityDescription.insertNewObject(forEntityName: "Diagram", into: managedObjectContext) as! FlowChartDiagram
        diagram.width = 600
        diagram.height = 500
        
        let symbol1 = BuildSymbolHelper.buildSymbol(
            in: diagram,
            center: Point(200, 100),
            shapePreset: .roundedCorderRect,
            color: SymbolColorPresets.snow)
        
        let symbol2 = BuildSymbolHelper.buildSymbol(
            in: diagram,
            center: Point(400, 150),
            shapePreset: .roundedCorderRect,
            color: SymbolColorPresets.snow)
        
        let link = BuildLinkHelper.buildLink(
            in: diagram,
            from: symbol1.rightAnchor,
            to: symbol2.leftAnchor)
        link.origin.pointerPreset = .strokedCircle
        link.text = "Test"
        
        do {
            try managedObjectContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
        
        contextManager = try! FlowChartManagedObjectContextManager(persistentManagedObjectContext: managedObjectContext)
        
        let mission = DebugFlowChartMission(
            diagram: contextManager.diagram,
            diagramViewController: diagramViewController)
        
        missionControl = MissionControl(
            mission: mission,
            contextManager: contextManager,
            diagramViewController: diagramViewController)
        
        addChildViewController(diagramViewController)
        view.addSubview(diagramViewController.view)
        diagramViewController.didMove(toParentViewController: self)
        
        diagramViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: diagramViewController.view,
            attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: diagramViewController.view,
            attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: diagramViewController.view,
            attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: diagramViewController.view,
            attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let diagramViewController = segue.destination as? DiagramViewController {
            self.diagramViewController = diagramViewController
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        missionControl.commence()
    }
    
//    @IBAction func undo() {
//        contextManager.undo()
//    }

//    @IBAction func redo() {
//        contextManager.redo()
//    }
    
    // MARK: - MissionControlInteractionsDelegate
    
//    func missionControlWillBeginInteractions(_ missionControl: MissionControl) {
//        undoBarButtonItem.isEnabled = false
//        redoBarButtonItem.isEnabled = false
//    }
    
//    func missionControlDidEndInteractions(_ missionControl: MissionControl) {
//        undoBarButtonItem.isEnabled = true
//        redoBarButtonItem.isEnabled = true
//    }
}

