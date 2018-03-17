//
//  BuildSymbolUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 26/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry
import DiagramView

protocol BuildSymbolUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
    func popoverSourceRect(in view: UIView) -> CGRect
}

protocol BuildSymbolUIProtocol: class {
    
    var onButtonPressed: (() -> Void)? { get set }
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)? { get set }
    var onPresetsSelectionCancelled: (() -> Void)? { get set }
    
    var isButtonPresented: Bool { get }
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    var isPresetsPopoverPresented: Bool { get }
    func preparePresetsPopoverPresentationTransition() -> Transition
    func preparePresetsPopoverDismissionTransition() -> Transition
    
    weak var layoutDelegate: BuildSymbolUILayoutDelegate! { get set }
    func layout()
}

protocol BuildSymbolInteractorProtocol: InteractorProtocol {
    
    var symbolCenter: Point { get }
    var symbolFrame: Rect { get }
    
    func createPlaceholder()
    func setShapePreset(_ preset: ShapePreset)
    func setColor(_ color: UIColor)
}

class BuildSymbolPresenter: FlexiblePresenter, UseCasePresenterProtocol, BuildSymbolUILayoutDelegate {
    
    private let ui: BuildSymbolUIProtocol
    private let interactor: BuildSymbolInteractorProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onEnded: (() -> Void)?
    var onCancelled: (() -> Void)?
    var onError: ((Error) -> Void)?
    
    init(ui: BuildSymbolUIProtocol,
         interactor: BuildSymbolInteractorProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        self.ui.onButtonPressed = { [unowned self] in self.buttonTapped() }
        self.ui.onPresetsSelected = { [unowned self] in self.presetsSelected($0, $1) }
        self.ui.onPresetsSelectionCancelled = { [unowned self] in self.presetsSelectionCancelled() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }
    
    override var needsFixedDismissionTransition: Bool {
        return ui.isPresetsPopoverPresented
    }
    
    override func createFixedDismissionTransition() -> Transition {
        return ui.preparePresetsPopoverDismissionTransition()
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        
        if ui.isButtonPresented {
            ui.prepareForButtonDismission(withIn: transition)
        }
        
        if !interactor.isFinished {
            interactor.rollback(withIn: transition)
        }
    }
    
    // MARK: - Interactions
    
    private func buttonTapped() {
        
        interactor.createPlaceholder()
        
        let instantTransition = Transition.instant()
        ui.prepareForButtonDismission(withIn: instantTransition)
        instantTransition.perform()
        
        let transition = ui.preparePresetsPopoverPresentationTransition()
        interactor.processPendingChanges(withIn: transition)
        transition.perform()
    }
    
    private func presetsSelected(_ shapePreset: ShapePreset, _ color: UIColor) {

        do {
            interactor.setShapePreset(shapePreset)
            interactor.setColor(color)
            try interactor.save()
            onEnded?()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func presetsSelectionCancelled() {
        onCancelled?()
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return coordinatesConverter.viewPoint(for: interactor.symbolCenter, in: view)
    }
    
    func popoverSourceRect(in view: UIView) -> CGRect {
        return coordinatesConverter.viewRect(for: interactor.symbolFrame, in: view).insetBy(dx: -5, dy: -5)
    }
    
    func layout() {
        ui.layout()
    }
}
