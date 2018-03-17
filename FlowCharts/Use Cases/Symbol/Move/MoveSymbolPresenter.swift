//
//  MoveSymbolUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol MoveSymbolInteractorProtocol: ContinuousInteractorProtocol {
    func move(by translation: Vector)
}

protocol MoveSymbolUIProtocol: class {
    
    var onPanBegan: (() -> Void)? { get set }
    var onPanMoved: ((CGVector, UIView) -> Void)? { get set }
    var onPanEnded: (() -> Void)? { get set }
    var onPanCancelled: (() -> Void)? { get set }
    
    func prepareForPanPresentation(withIn transition: Transition)
    func prepareForPanDismission(withIn transition: Transition)
}

class MoveSymbolPresenter: ActivatablePresenter, UseCasePresenterProtocol {
    
    private let ui: MoveSymbolUIProtocol
    private let interactor: MoveSymbolInteractorProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    init(ui: MoveSymbolUIProtocol,
         interactor: MoveSymbolInteractorProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.onPanBegan = { [unowned self] in self.beginMoving() }
        self.ui.onPanMoved = { [unowned self] in self.move(by: $0, in: $1) }
        self.ui.onPanEnded = { [unowned self] in self.endMoving() }
        self.ui.onPanCancelled = { [unowned self] in self.cancelMoving() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForPanPresentation(withIn: transition)
    }
    
    override func setUpDismission(withIn transition: Transition) {
        precondition(!interactor.isInteracting)
        super.setUpDismission(withIn: transition)
        ui.prepareForPanDismission(withIn: transition)
    }
    
    // MARK: - Interactions
    
    private func beginMoving() {
        interactor.begin()
        activate(with: .defaultChangeover())
    }
    
    private func move(by translation: CGVector, in view: UIView) {
        interactor.move(by: coordinatesConverter.diagramVector(for: translation, in: view))
    }
    
    private func endMoving() {
        do {
            try interactor.save()
            deactivate(with: .defaultChangeover())
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func cancelMoving() {
        interactor.rollback()
        deactivate(with: .defaultChangeover())
    }
    
    // MARK: - Layout
    
    func layout() {
        
    }
}
