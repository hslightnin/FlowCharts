//
//  BuildLinkUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol BuildLinkUILayoutDelegate: class {
    
    func buttonLocation(in view: UIView) -> CGPoint
    var buttonDirection: Direction { get }
    
    func highlightedPath(in view: UIView) -> CGPath
    func popoverSourceRect(in view: UIView) -> CGRect
    var popoverPreferredArrowDirections: UIPopoverArrowDirection { get }
}

protocol BuildLinkUIProtocol: class {
    
    var onPanBegan: (() -> Void)? { get set }
    var onPanMoved: ((CGPoint, UIView) -> Void)? { get set }
    var onPanCancelled: (() -> Void)? { get set }
    var onPanEnded: (() -> Void)? { get set }

    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)? { get set }
    var onPresetsSelectionCancelled: (() -> Void)? { get set }

    var isButtonPresented: Bool { get }
    func prepareForButtonPresentaion(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)

    var isDirectionZonesControlPresented: Bool { get }
    func prepareForDirectionZonesPresentation(withIn transition: Transition)
    func prepareForDirectionZonesDismission(withIn transition: Transition)

    var isSymbolPresetsPopoverPresented: Bool { get }
    func prepateSymbolPresetsPopoverPresentationTransition() -> Transition
    func prepateSymbolPresetsPopoverDismissionTransition() -> Transition

    weak var layoutDelegate: BuildLinkUILayoutDelegate! { get set }
    func layout()
}

protocol BuildLinkInteractorProtocol: InteractorProtocol {
    
    func begin()
    func moveLinkEnding(to location: Point)
    func end()
    func setSymbolShapePreset(_ preset: ShapePreset)
    func setSymbolColor(_ color: UIColor)
    
    var hasAddedSymbol: Bool { get }
    var hasAddedLink: Bool { get }
    var canSave: Bool { get }
    
    var manipulatedAnchorDirection: Direction { get }
    var addedLinkEndingLocation: Point? { get }
    var addedLinkEndingDirection: Direction? { get }
    var addedSymbolFrame: Rect? { get }
    
    var directZonePath: BezierPath { get }
    var oppositeZonePath: BezierPath { get }
    var rotatedClockwiseZonePath: BezierPath { get }
    var rotatedCounterClockwiseZonePath: BezierPath { get }
}

class BuildLinkPresenter: ActivatablePresenter, UseCasePresenterProtocol, BuildLinkUILayoutDelegate {
    
    private let ui: BuildLinkUIProtocol
    private let interactor: BuildLinkInteractorProtocol
    private let buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onEnded: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(ui: BuildLinkUIProtocol,
         interactor: BuildLinkInteractorProtocol,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onPanBegan = { [unowned self] in self.panBegan() }
        self.ui.onPanMoved = { [unowned self] in self.panMoved(to: $0, in: $1) }
        self.ui.onPanCancelled = { [unowned self] in self.panCancelled() }
        self.ui.onPanEnded = { [unowned self] in self.panEnded() }
        self.ui.onPresetsSelected = { [unowned self] in self.presetsSelected(shapePreset: $0, color: $1) }
        self.ui.onPresetsSelectionCancelled = { [unowned self] in self.propertiesSelectionCancelled() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentaion(withIn: transition)
    }

    override func setUpActivation(withIn transition: Transition) {
        super.setUpActivation(withIn: transition)
        ui.prepareForDirectionZonesPresentation(withIn: transition)
    }

    override func setUpDeactivation(withIn transition: Transition) {
        super.setUpDeactivation(withIn: transition)
        if ui.isDirectionZonesControlPresented {
            ui.prepareForDirectionZonesDismission(withIn: transition)
        }
    }

    override var needsFixedDismissionTransition: Bool {
        return ui.isSymbolPresetsPopoverPresented
    }

    override func createFixedDismissionTransition() -> Transition {
        return ui.prepateSymbolPresetsPopoverDismissionTransition()
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        if ui.isButtonPresented {
            ui.prepareForButtonDismission(withIn: transition)
        }
        if ui.isDirectionZonesControlPresented {
            ui.prepareForDirectionZonesDismission(withIn: transition)
        }
    }
    
    // MARK: - Interactions
    
    private func panBegan() {
        interactor.begin()
        activate(with: .defaultChangeover())
    }
    
    private func panMoved(to location: CGPoint, in view: UIView) {
        interactor.moveLinkEnding(to: coordinatesConverter.diagramPoint(for: location, in: view))
        ui.layout()
    }
    
    private func panEnded() {
        
        if interactor.hasAddedSymbol {
            
            let transition = ui.prepateSymbolPresetsPopoverPresentationTransition()
            ui.prepareForDirectionZonesDismission(withIn: transition)
            transition.perform()
            
        } else if interactor.canSave {
            
            do {
                try interactor.save()
                onEnded?()
            } catch {
                interactor.rollback()
                onError?(error)
            }
            
        } else {
            
            interactor.rollback()
            ui.layout()
            deactivate(with: .defaultChangeover())
        }
    }
    
    private func panCancelled() {
        interactor.rollback()
        ui.layout()
        deactivate(with: .defaultChangeover())
    }
    
    private func presetsSelected(shapePreset: ShapePreset, color: UIColor) {
        
        interactor.end()
        interactor.setSymbolShapePreset(shapePreset)
        interactor.setSymbolColor(color)
        
        do {
            try interactor.save()
            
            let instantTransition = Transition.instant()
            ui.prepareForButtonDismission(withIn: instantTransition)
            instantTransition.perform()

            onEnded?()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func propertiesSelectionCancelled() {
        
        let transition = ui.prepateSymbolPresetsPopoverDismissionTransition()
        interactor.rollback(withIn: transition)
        
        let instantTransition = Transition.instant()
        ui.prepareForButtonDismission(withIn: instantTransition)
        instantTransition.perform()
        
        ui.layout()
        ui.prepareForButtonPresentaion(withIn:transition)

        deactivate(with: transition)
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        if let location = interactor.addedLinkEndingLocation {
            return coordinatesConverter.viewPoint(for: location, in: view)
        } else {
            switch interactor.manipulatedAnchorDirection {
            case .up:
                return buttonsLayoutManager.buildTopLinkButtonLocation(in: view)
            case .down:
                return buttonsLayoutManager.buildBottomLinkButtonLocation(in: view)
            case .right:
                return buttonsLayoutManager.buildRightLinkButtonLocation(in: view)
            case .left:
                return buttonsLayoutManager.buildLeftLinkButtonLocation(in: view)
            }
        }
    }
    
    var buttonDirection: Direction {
        if let direction = interactor.addedLinkEndingDirection {
            return direction
        } else {
            return interactor.manipulatedAnchorDirection
        }
    }
    
    func highlightedPath(in view: UIView) -> CGPath {
        let rotatedClockwisePath = interactor.rotatedClockwiseZonePath
        let rotatedCounterClockwisePath = interactor.rotatedCounterClockwiseZonePath
        let pathOnDiagram = rotatedClockwisePath.appending(path: rotatedCounterClockwisePath)
        return coordinatesConverter.viewPath(forDiagramPath: pathOnDiagram, in: view)
    }
    
    func popoverSourceRect(in view: UIView) -> CGRect {
        
        guard let frame = interactor.addedSymbolFrame else {
            return .zero
        }
        
        return coordinatesConverter.viewRect(for: frame, in: view)
    }
    
    var popoverPreferredArrowDirections: UIPopoverArrowDirection {
        
        guard let direction = interactor.addedLinkEndingDirection else {
            return .any
        }
        
        switch direction {
        case .up:
            return .down
        case .down:
            return .up
        case .left:
            return .right
        case .right:
            return .left
        }
    }
    
    func layout() {
        ui.layout()
    }
}
