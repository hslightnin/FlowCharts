//
//  BuildSymbolUseCase.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
import DiagramGeometry
import DiagramView

class BuildSymbolUseCase: BuildSymbolUseCaseProtocol {
    
    let diagram: FlowChartDiagram
    let location: Point
    let diagramViewController: DiagramViewController
    
    var onEnded: ((FlowChartSymbol) -> Void)?
    var onCancelled: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    required init(diagram: FlowChartDiagram,
         location: Point,
         diagramViewController: DiagramViewController) {
        
        self.diagram = diagram
        self.location = location
        self.diagramViewController = diagramViewController
    }
    
    var presenter: FlexiblePresenter & UseCasePresenterProtocol {
        return buildLinkPresenter
    }
    
    func layout() {
        self.buildLinkPresenter.layout()
    }
    
    lazy var buildLinkPresenter: BuildSymbolPresenter = {
        
        let presenter = BuildSymbolPresenter(
            ui: self.ui,
            interactor: self.interactor,
            coordinatesConverter: self.diagramViewController)
        
        presenter.onEnded = { [unowned self] in self.onEnded?(self.interactor.addedSymbol!) }
        presenter.onCancelled = { [unowned self] in self.onCancelled?() }
        presenter.onError = { [unowned self] in self.onError?($0) }
        
        return presenter
    }()
    
    lazy var ui: BuildSymbolUI = {
        return BuildSymbolUI(
            diagramViewController: self.diagramViewController,
            diagramScrollView: self.diagramViewController.diagramScrollView)
    }()
    
    lazy var interactor: BuildSymbolInteractor = {
        return BuildSymbolInteractor(
            diagram: self.diagram,
            location: self.location)
    }()
}
