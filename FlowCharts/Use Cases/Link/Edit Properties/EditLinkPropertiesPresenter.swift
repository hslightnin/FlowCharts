//
//  EditLinkPropertiesUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol EditLinkPropertiesUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
    func popoverSourceRect(in view: UIView) -> CGRect
}

protocol EditLinkPropertiesUIProtocol: class {
    
    var selectedLineTypePreset: LineTypePreset? { get set }
    var selectedLineDashPatternPreset: LineDashPatternPreset? { get set }
    var onSelectedPresetsChanged: ((LineTypePreset, LineDashPatternPreset) -> Void)? { get set }
    
    var onButtonPressed: (() -> Void)? { get set }
    var onPopoverShouldDismiss: (() -> Void)? { get set }
    
    var isButtonPresented: Bool { get }
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    var isPropertiesPopoverPresented: Bool { get }
    func preparePropertiesPopoverPresentationTransition() -> Transition
    func preparePropertiesPopoverDismissionTransition() -> Transition
    
    weak var layoutDelegate: EditLinkPropertiesUILayoutDelegate! { get set }
    func layout()
}

protocol EditLinkPropertiesInteractorProtocol: InteractorProtocol {
    
    var linkTextRect: Rect? { get }
    var linkCenter: Point { get }
    
    var lineTypePreset: LineTypePreset { get set }
    var lineDashPatternPreset: LineDashPatternPreset { get set }
}

class EditLinkPropertiesPresenter: ActivatablePresenter, UseCasePresenterProtocol, EditLinkPropertiesUILayoutDelegate {
    
    private let ui: EditLinkPropertiesUIProtocol
    private let interactor: EditLinkPropertiesInteractorProtocol
    private let buttonsLayoutManager: LinkButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    init(ui: EditLinkPropertiesUIProtocol,
         interactor: EditLinkPropertiesInteractorProtocol,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onButtonPressed = { [unowned self] in self.buttonPressed() }
        self.ui.onSelectedPresetsChanged = { [unowned self] in self.selectedPresetsChanged($0, $1) }
        self.ui.onPopoverShouldDismiss = { [unowned self] in self.popoverShouldDismiss() }
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
    
    func buttonPressed() {
        ui.selectedLineTypePreset = interactor.lineTypePreset
        ui.selectedLineDashPatternPreset = interactor.lineDashPatternPreset
        activate(with: ui.preparePropertiesPopoverPresentationTransition())
    }
    
    func selectedPresetsChanged(_ lineTypePreset: LineTypePreset, _ lineDashPatternPreset: LineDashPatternPreset) {
        do {
            interactor.lineTypePreset = lineTypePreset
            interactor.lineDashPatternPreset = lineDashPatternPreset
            try interactor.save()
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    func popoverShouldDismiss() {
        deactivate(with: ui.preparePropertiesPopoverDismissionTransition())
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.editPropertiesButtonLocation(in: view)
    }
    
    func popoverSourceRect(in view: UIView) -> CGRect {
        if let linkTextRect = interactor.linkTextRect {
            return coordinatesConverter.viewRect(for: linkTextRect, in: view)
        } else {
            let linkCenterRect = Rect(center: interactor.linkCenter, size: Size(22, 22))
            return coordinatesConverter.viewRect(for: linkCenterRect, in: view)
        }
    }
    
    func layout() {
        ui.layout()
    }
}
