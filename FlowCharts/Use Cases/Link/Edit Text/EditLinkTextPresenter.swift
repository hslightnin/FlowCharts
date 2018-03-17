//
//  EditLinkTextUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol EditLinkTextInteractorProtocol: ContinuousInteractorProtocol {
    var text: String? { get set }
    var font: UIFont { get }
    var textInsets: Vector { get }
    var maxTextWidth: Double { get }
    var linkCenter: Point { get }
}

class EditLinkTextPresenter: ActivatablePresenter, UseCasePresenterProtocol, EditTextUILayoutDelegate {
    
    private let ui: EditTextUIProtocol
    private let interactor: EditLinkTextInteractorProtocol
    private let buttonsLayoutManager: LinkButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?

    init(ui: EditTextUIProtocol,
         interactor: EditLinkTextInteractorProtocol,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.textInsets = UIEdgeInsetsMake(2, 6, 2, 6)
        
        self.ui.onButtonPressed = { [unowned self] in self.beginEditing() }
        self.ui.onDoubleTapRecognized = { [unowned self] in self.beginEditing() }
        self.ui.onCancelTapRecognized = { [unowned self] in self.endEditing() }
        self.ui.onTextViewEndedEditing = { [unowned self] in self.endEditing()  }
        self.ui.onTextViewCancelledEditing = { [unowned self] in self.cancelEditing() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
        ui.prepareForDoubleTapPresentation(withIn: transition)
    }
    
    override func setUpActivation(withIn transition: Transition) {
        super.setUpActivation(withIn: transition)
        ui.prepareForButtonDismission(withIn: transition)
        ui.prepareForDoubleTapDismission(withIn: transition)
        ui.prepareForTextViewPresentation(withIn: transition)
        ui.prepareForCancelTapPresentation(withIn: transition)
    }
    
    override func setUpDeactivation(withIn transition: Transition) {
        super.setUpDeactivation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
        ui.prepareForDoubleTapPresentation(withIn: transition)
        ui.prepareForTextViewDismission(withIn: transition)
        ui.prepareForCancelTapDismission(withIn: transition)
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        if ui.isButtonPresented {
            ui.prepareForButtonDismission(withIn: transition)
        }
        if ui.isDoubleTapPresented {
            ui.prepareForDoubleTapDismission(withIn: transition)
        }
        if ui.isTextViewPresented {
            ui.prepareForTextViewDismission(withIn: transition)
        }
        if ui.isCancelTapPresented {
            ui.prepareForCancelTapDismission(withIn: transition)
        }
    }
    
    // MARK: - Interactions
    
    private func beginEditing() {
        
        ui.text = interactor.text
        ui.font = interactor.font
        
        let activationTransition = Transition.defaultChangeover()
        activationTransition.addCompletion {
            self.interactor.begin()
            self.interactor.text = nil
        }
        activate(with: activationTransition)
    }
    
    private func endEditing() {
        do {
            interactor.text = ui.text
            try interactor.save()
            deactivate(with: .defaultChangeover())
        } catch {
            interactor.rollback()
            onError?(error)
        }
    }
    
    private func cancelEditing() {
        interactor.rollback()
        deactivate(with: .defaultChangeover())
    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.editTextButtonLocation(in: view)
    }
    
    func textViewLocation(in view: UIView) -> CGPoint {
        return coordinatesConverter.viewPoint(for: interactor.linkCenter, in: view)
    }
    
    func minTextViewWidth(in view: UIView) -> CGFloat {
        return 10
    }
    
    func maxTextViewWidth(in view: UIView) -> CGFloat {
        return CGFloat(interactor.maxTextWidth + 2 * interactor.textInsets.x)
    }
    
    func layout() {
        ui.layout()
    }
}
