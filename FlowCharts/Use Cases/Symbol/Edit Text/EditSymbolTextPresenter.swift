//
//  EditSymbolTextUseCasePresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol EditSymbolTextInteractorProtocol: ContinuousInteractorProtocol {
    var text: String? { get set }
    var font: UIFont { get }
    var textAreaPath: BezierPath { get }
    var textInsets: Vector { get }
}

class EditSymbolTextPresenter: ActivatablePresenter, UseCasePresenterProtocol, EditTextUILayoutDelegate {
    
    private let ui: EditTextUIProtocol
    private let interactor: EditSymbolTextInteractorProtocol
    private let buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol
    private let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    init(ui: EditTextUIProtocol,
         interactor: EditSymbolTextInteractorProtocol,
         buttonsLayoutManager: SymbolButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.interactor = interactor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
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
        
        transition.addBeginning {
            self.ui.text = self.interactor.text
            self.ui.font = self.interactor.font
            self.ui.textInsets = UIEdgeInsets(
                top: CGFloat(self.interactor.textInsets.y),
                left: CGFloat(self.interactor.textInsets.x),
                bottom: CGFloat(self.interactor.textInsets.y),
                right: CGFloat(self.interactor.textInsets.x))
        }
        
        ui.prepareForButtonDismission(withIn: transition)
        ui.prepareForDoubleTapDismission(withIn: transition)
        ui.prepareForTextViewPresentation(withIn: transition)
        ui.prepareForCancelTapPresentation(withIn: transition)
    }
    
    override func setUpDeactivation(withIn transition: Transition) {
        precondition(!interactor.isInteracting)
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
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        return buttonsLayoutManager.editTextButtonLocation(in: view)
    }
    
    func textViewLocation(in view: UIView) -> CGPoint {
        return textAreaPath(in: view).boundingBoxOfPath.center
    }
    
    func minTextViewWidth(in view: UIView) -> CGFloat {
        return textAreaPath(in: view).boundingBoxOfPath.width
    }
    
    func maxTextViewWidth(in view: UIView) -> CGFloat {
        return textAreaPath(in: view).boundingBoxOfPath.width
    }
    
    private func textAreaPath(in view: UIView) -> CGPath {
        return coordinatesConverter.viewPath(forDiagramPath: interactor.textAreaPath, in: view)
    }

    func layout() {
        ui.layout()
    }
    
    // MARK: - Interactions
    
    private func beginEditing() {
        let transition = Transition.defaultChangeover()
        transition.addCompletion {
            self.interactor.text = nil
        }
        activate(with: transition)
    }
    
    private func endEditing() {
        
        interactor.text = ui.text
        
        do {
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
}
