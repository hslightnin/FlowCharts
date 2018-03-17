
//  MissionControl.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 12/06/16.
//  Copyright © 2016 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry
import DiagramView

protocol MissionControlInteractionsDelegate: class {
    func missionControlWillBeginInteractions(_ missionControl: MissionControl)
    func missionControlDidEndInteractions(_ missionControl: MissionControl)
}

class MissionControl: NSObject {

    private let context: FlowChartMissionProtocol
    private let contextManager: FlowChartManagedObjectContextManager
    private let diagramViewController: DiagramViewController
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var diagramViewControllerDidZoomObserver: NSObjectProtocol?
    
    private var buildSymbolUseCase: BuildSymbolUseCaseProtocol?
    private var symbolMission: SymbolMissionProtocol?
    private var linkMission: LinkMissionProtocol?
    
    weak var interactionsDelegate: MissionControlInteractionsDelegate?
    
    init(mission: FlowChartMissionProtocol,
         contextManager: FlowChartManagedObjectContextManager,
         diagramViewController: DiagramViewController) {
        
        self.context = mission
        self.contextManager = contextManager
        self.diagramViewController = diagramViewController
    }
    
    func commence() {
        
        diagramViewController.diagram = contextManager.diagram.dataSource
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        diagramViewController.diagramContentView!.addGestureRecognizer(self.tapGestureRecognizer)
        contextManager.startObservingContext()
        
        diagramViewControllerDidZoomObserver = NotificationCenter.default.addObserver(
            forName: .diagramViewControllerDidZoom,
            object: diagramViewController,
            queue: nil) { _ in
                self.buildSymbolUseCase?.presenter.layout()
        }
    }
    
    func abort() {
        diagramViewController.diagramContentView!.removeGestureRecognizer(self.tapGestureRecognizer)
        tapGestureRecognizer = nil
        diagramViewController.diagram = nil
        contextManager.stopObservingContext()
        
        NotificationCenter.default.removeObserver(diagramViewControllerDidZoomObserver!)
        diagramViewControllerDidZoomObserver = nil
    }
    
    func tap(_ gesture: UITapGestureRecognizer) {
        
        if gesture.state == .recognized {
            
            guard let hitItemDataSource = self.diagramViewController.hitTest(gesture) else {
                return
            }
            
            if hitItemDataSource === symbolMission?.symbol.dataSource {
                return
            }
            
            if hitItemDataSource === linkMission?.link.dataSource {
                return
            }
            
            if symbolMission?.presenter.isActivated ?? false {
                return
            }
            
            if linkMission?.presenter.isActivated ?? false {
                return
            }
            
            if buildSymbolUseCase != nil {
                dismissBuildSymbolUseCase()
            } else if symbolMission != nil {
                abortSymbolMission()
            } else if linkMission != nil {
                abortLinkMission()
            } else {
                switch hitItemDataSource {
                    
                case _ as DiagramDataSource:
                    let locationInView = gesture.location(in: gesture.view!)
                    let locationOnDiagram = diagramViewController.diagramPoint(for: locationInView, in: gesture.view!)
                    presentBuildSymbolUseCase(at: locationOnDiagram)
                    
                case let linkDataSource as FlowChartLinkDataSource:
                    commenceMission(for: linkDataSource.link)
                    
                case let symbolDataSource as FlowChartSymbolDataSource:
                    commenceMission(for: symbolDataSource.symbol)
                    
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Build symbol use case
    
    private func presentBuildSymbolUseCase(at location: Point) {
        
        let useCase = context.createBuildSybolUseCase(location: location)
        
        useCase.onEnded = { [unowned self] symbol in
            self.dismissBuildSymbolUseCase {
                self.commenceMission(for: symbol)
            }
        }
        
        useCase.onCancelled = { [unowned self] in
            self.dismissBuildSymbolUseCase()
        }
        
        useCase.onError = { [unowned self] error in
            self.dismissBuildSymbolUseCase {
                self.present(error: error)
            }
        }
        
        useCase.presenter.present(with: .defaultPresentation())
        
        buildSymbolUseCase = useCase
    }
    
    private func dismissBuildSymbolUseCase(completion: (() -> Void)? = nil) {
        let presenter = buildSymbolUseCase!.presenter
        let transition = presenter.prepareDismissionTransition(preferredTransition: .defaultDismission())
        transition.add(completion: completion)
        transition.perform()
        buildSymbolUseCase = nil
    }
    
    // MARK: - Symbol mission
    
    private func commenceMission(for symbol: FlowChartSymbol, with transition: Transition = .defaultPresentation()) {
        
        let mission = context.createMission(for: symbol)
        
        mission.onError = { [unowned mission] error in
            let transition = mission.presenter.prepareDismissionTransition(preferredTransition: .defaultDismission())
            transition.addBeginning { [unowned self] in
                self.symbolMission = nil
            }
            transition.addCompletion { [unowned self] in
                self.present(error: error)
            }
            transition.perform()
        }
        
        mission.onDeleted = { [unowned mission] transition in
            mission.presenter.prepareForDismission(withIn: transition)
            transition.addBeginning { [unowned self] in
                self.symbolMission = nil
            }
        }
        
        mission.onAdded = { [unowned self] addedLink, addedSymbol in
            
            let missionPresenter = self.symbolMission!.presenter
            
            let transition = missionPresenter.prepareDismissionTransition(preferredTransition: .defaultChangeover())
            transition.addBeginning { [unowned self] in
                self.symbolMission = nil
            }
            
            if addedSymbol != nil {
                self.commenceMission(for: addedSymbol!, with: transition)
            } else {
                self.commenceMission(for: addedLink, with: transition)
            }
        }
        
        mission.presenter.present(with: transition)
        
        symbolMission = mission
    }
    
    private func abortSymbolMission(with transition: Transition = .defaultDismission()) {
        transition.addBeginning { [unowned self] in
            self.symbolMission = nil
        }
        symbolMission!.presenter.dismiss(with: transition)
    }
    
    // MARK: - Link mission
    
    private func commenceMission(for link: FlowChartLink, with transition: Transition = .defaultPresentation()) {
        
        let mission = context.createMission(for: link)
        
        mission.onError = { [unowned mission] error in
            let transition = mission.presenter.prepareDismissionTransition(preferredTransition: .defaultDismission())
            transition.addBeginning { [unowned self] in
                self.linkMission = nil
            }
            transition.addCompletion { [unowned self] in
                self.present(error: error)
            }
            transition.perform()
        }
        
        mission.onDeleted = { [unowned mission] transition in
            mission.presenter.prepareForDismission(withIn: transition)
        }
        
        mission.presenter.present(with: .defaultPresentation())
        
        linkMission = mission
    }
    
    private func abortLinkMission() {
        linkMission!.presenter.dismiss(with: .defaultDismission())
        linkMission = nil
    }
    
    // MARK: - Error
    
    private func present(error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        diagramViewController.present(alertController, animated: true, completion: nil)
    }
}
