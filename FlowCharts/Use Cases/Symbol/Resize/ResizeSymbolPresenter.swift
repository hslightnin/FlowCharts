//
//  ResizeSymbolUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

enum SymbolResizingMode {
    case fromCenter
    case fromOrigin
}

protocol ResizeSymbolUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
}

protocol ResizeSymbolUIProtocol: class {
    
    var onBeganChoosingMode: ((Transition) -> Void)? { get set }
    var onEndedChoosingMode: ((Transition) -> Void)? { get set }
    
    var onPanBegan: ((SymbolResizingMode) -> Void)? { get set }
    var onPanMoved: ((CGPoint, UIView) -> Void)? { get set }
    var onPanEnded: (() -> Void)? { get set }
    var onPanCancelled: (() -> Void)? { get set }
    
    func prepareForResizeControlPresentation(withIn transition: Transition)
    func prepareForResizeControlDismission(withIn transition: Transition)
 
    weak var layoutDelegate: ResizeSymbolUILayoutDelegate! { get set }
    func layout()
}

protocol ResizeSymbolInteractorProtocol: ContinuousInteractorProtocol {
    var mode: SymbolResizingMode { get set }
    func moveRightBottomCorner(to location: Point)
}

class ResizeSymbolPresenter: ActivatablePresenter, UseCasePresenterProtocol, ResizeSymbolUILayoutDelegate {
    
    private let ui: ResizeSymbolUIProtocol
    private let interactor: ResizeSymbolInteractorProtocol
    private let buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    init(ui: ResizeSymbolUIProtocol,
         interactor: ResizeSymbolInteractorProtocol,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onBeganChoosingMode = { [unowned self] in self.beginChoosingMode(withIn: $0) }
        self.ui.onEndedChoosingMode = { [unowned self] in self.enededChoosingMode(withIn: $0) }
        self.ui.onPanBegan = { [unowned self] in self.panBegan($0) }
        self.ui.onPanMoved = { [unowned self] in self.panMoved(to: $0, in: $1) }
        self.ui.onPanEnded = { [unowned self] in self.panEnded() }
        self.ui.onPanCancelled = { [unowned self] in self.panCancelled() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForResizeControlPresentation(withIn: transition)
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        ui.prepareForResizeControlDismission(withIn: transition)
    }
    
    // MARK: - Interactions
    
    private func beginChoosingMode(withIn transition: Transition) {
        activate(withIn: transition)
    }
    
    private func enededChoosingMode(withIn transition: Transition) {
        deactivate(withIn: transition)
    }
    
    private func panBegan(_ mode: SymbolResizingMode) {
        activate(with: .defaultChangeover())
        interactor.mode = mode
        interactor.begin()
    }
    
    private func panMoved(to location: CGPoint, in view: UIView) {
        interactor.moveRightBottomCorner(to: coordinatesConverter.diagramPoint(for: location, in: view))
    }
    
    private func panEnded() {
        do {
            try interactor.save()
            deactivate(with: .defaultChangeover())
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func panCancelled() {
        interactor.rollback()
        deactivate(with: .defaultChangeover())
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.resizeButtonLocation(in: view)
    }
    
    func layout() {
        ui.layout()
    }
}
