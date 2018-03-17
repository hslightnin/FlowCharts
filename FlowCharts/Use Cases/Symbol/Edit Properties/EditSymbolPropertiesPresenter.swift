//
//  EditSymbolPropertiesUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 08/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramView

protocol EditSymbolPropertiesUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
}

protocol EditSymbolPropertiesUIProtocol: class {
    
    var selectedShapePreset: ShapePreset? { get set }
    var selectedColor: UIColor? { get set }
    
    var onShapePresetSelected: ((ShapePreset) -> Void)? { get set }
    var onColorSelected: ((UIColor) -> Void)? { get set }

    var onButtonPressed: (() -> Void)? { get set }
    var onSelectionEnded: (() -> Void)? { get set }
    
    var isButtonPresented: Bool { get }
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    var isPropertiesPopoverPresented: Bool { get }
    func preparePropertiesPopoverPresentationTransition() -> Transition
    func preparePropertiesPopoverDismissionTransition() -> Transition
    
    weak var layoutDelegate: EditSymbolPropertiesUILayoutDelegate! { get set }
    func layout()
}

protocol EditSymbolPropertiesInteractorProtocol: InteractorProtocol {
    var shapePreset: ShapePreset { get set }
    var color: UIColor { get set }
}

class EditSymbolPropertiesPresenter: ActivatablePresenter, UseCasePresenterProtocol, EditSymbolPropertiesUILayoutDelegate {
    
    private let ui: EditSymbolPropertiesUIProtocol
    private let interactor: EditSymbolPropertiesInteractorProtocol
    private let buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    init(ui: EditSymbolPropertiesUIProtocol,
         interactor: EditSymbolPropertiesInteractorProtocol,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onButtonPressed = { [unowned self] in self.buttonTapped() }
        self.ui.onShapePresetSelected = { [unowned self] in self.shapePresetSelected($0) }
        self.ui.onColorSelected = { [unowned self] in self.colorSelected($0) }
        self.ui.onSelectionEnded = { [unowned self] in self.selectionEneded() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }
    
    override func setUpActivation(withIn transition: Transition) {
        super.setUpActivation(withIn: transition)
        ui.prepareForButtonDismission(withIn: transition)
    }
    
    override func setUpDeactivation(withIn transition: Transition) {
        super.setUpDeactivation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }
    
    override var needsFixedDismissionTransition: Bool {
        return ui.isPropertiesPopoverPresented
    }
    
    override func createFixedDismissionTransition() -> Transition {
        return ui.preparePropertiesPopoverDismissionTransition()
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        if ui.isButtonPresented {
            ui.prepareForButtonDismission(withIn: transition)
        }
    }
    
    // MARK: - Interactions
    
    private func buttonTapped() {
        let transition = ui.preparePropertiesPopoverPresentationTransition()
        activate(with: transition)
    }
    
    private func shapePresetSelected(_ preset: ShapePreset) {
        
        interactor.shapePreset = preset
        
        do {
            try interactor.save()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func colorSelected(_ color: UIColor) {
        
        interactor.color = color
        
        do {
            try interactor.save()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func selectionEneded() {
        let transition = ui.preparePropertiesPopoverDismissionTransition()
        deactivate(with: transition)
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.editPropertiesButtonLocation(in: view)
    }
    
    func layout() {
        ui.layout()
    }
}
