//
//  EditLinkAnchorPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 01/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
import DiagramView

protocol EditLinkAnchorLayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
    var buttonVector: Vector { get }
    var buttonPointerPreset: PointerPreset { get }
    func popoverSourceRect(in view: UIView) -> CGRect
}

protocol EditLinkAnchorUIProtocol: class {
    
    var pointerVector: Vector { get set }
    var selectedPointerPreset: PointerPreset? { get set }
    
    var onButtonPressed: (() -> Void)? { get set }
    var onSelectedPointerPresetChanged: ((PointerPreset) -> Void)? { get set }
    var onPopoverShouldDismiss: (() -> Void)? { get set }
    
    var onPanBegan: (() -> Void)? { get set }
    var onPanMoved: ((CGPoint, UIView) -> Void)? { get set }
    var onPanEnded: (() -> Void)? { get set }
    var onPanCancelled: (() -> Void)? { get set }
    
    var isButtonPresented: Bool { get }
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    var isPropertiesPopoverPresented: Bool { get }
    func preparePropertiesPopoverPresentationTransition() -> Transition
    func preparePropertiesPopoverDismissionTransition() -> Transition
    
    weak var layoutDelegate: EditLinkAnchorLayoutDelegate! { get set }
    func layout()
}

protocol MoveLinkAnchorInteractorProtocol: ContinuousInteractorProtocol {
    
    var isOriginAnchor: Bool { get }
    var anchorLocation: Point { get }
    var anchorVector: Vector { get }
    
    func move(to location: Point)
    var canSave: Bool { get }
}

protocol EditLinkAnchorPropertiesInteractorProtocol: InteractorProtocol {
    var pointerVector: Vector { get }
    var pointerPreset: PointerPreset { get set }
}

protocol EditLinkAnchorUseCasePresenterInteractionsDelegate: class {
    func editLinkAnchorUseCasePresenter(_ presenter: EditLinkAnchorPresenter, didFailWith error: Error)
}

class EditLinkAnchorPresenter: ActivatablePresenter, UseCasePresenterProtocol, EditLinkAnchorLayoutDelegate {

    let ui: EditLinkAnchorUIProtocol
    let moveInteractor: MoveLinkAnchorInteractorProtocol
    let editPropertiesInteractor: EditLinkAnchorPropertiesInteractorProtocol
    let buttonsLayoutManager: LinkButtonsLayoutManagerProtocol
    let coordinatesConverter: DiagramCoordinatesConverter
    
    var onError: ((Error) -> Void)?
    
    weak var interactionsDelegate: EditLinkAnchorUseCasePresenterInteractionsDelegate?
    
    init(ui: EditLinkAnchorUIProtocol,
         moveInteractor: MoveLinkAnchorInteractorProtocol,
         editPropertiesInteractor: EditLinkAnchorPropertiesInteractorProtocol,
         buttonsLayoutManager: LinkButtonsLayoutManagerProtocol,
         coordinatesConverter: DiagramCoordinatesConverter) {
        
        self.ui = ui
        self.moveInteractor = moveInteractor
        self.editPropertiesInteractor = editPropertiesInteractor
        self.buttonsLayoutManager = buttonsLayoutManager
        self.coordinatesConverter = coordinatesConverter
        
        super.init()
        
        self.ui.layoutDelegate = self
        
        self.ui.onButtonPressed = { [unowned self] in self.buttonPressed() }
        self.ui.onSelectedPointerPresetChanged = { [unowned self] in self.selectedPointerPresetChanged($0) }
        self.ui.onPopoverShouldDismiss = { [unowned self] in self.shouldDismissPopover() }
        self.ui.onPanBegan = { [unowned self] in self.panBegan() }
        self.ui.onPanMoved = { [unowned self] in self.panMoved(to: $0, in: $1) }
        self.ui.onPanEnded = { [unowned self] in self.panEnded() }
        self.ui.onPanCancelled = { [unowned self] in self.panCancelled() }
    }
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        ui.prepareForButtonPresentation(withIn: transition)
    }
    
    override var needsFixedDismissionTransition: Bool {
        return ui.isPropertiesPopoverPresented
    }
    
    override func createFixedDismissionTransition() -> Transition {
        return ui.preparePropertiesPopoverDismissionTransition()
    }
    
    override func setUpDismission(withIn transition: Transition) {
        precondition(!moveInteractor.isInteracting)
        super.setUpDismission(withIn: transition)
        if ui.isButtonPresented {
            ui.prepareForButtonDismission(withIn: transition)
        }
    }
    
    // MARK: - Interactions
    
    private func buttonPressed() {
        
        ui.pointerVector = editPropertiesInteractor.pointerVector
        ui.selectedPointerPreset = editPropertiesInteractor.pointerPreset
        
        let activationTransition = ui.preparePropertiesPopoverPresentationTransition()
        ui.prepareForButtonDismission(withIn: activationTransition)
        activate(with: activationTransition)
    }
    
    private func selectedPointerPresetChanged(_ preset: PointerPreset) {
        do {
            editPropertiesInteractor.pointerPreset = preset
            try editPropertiesInteractor.save()
        } catch {
            editPropertiesInteractor.rollback()
            onError?(error)
        }
    }
    
    private func shouldDismissPopover() {
        let deactivationTransition = ui.preparePropertiesPopoverDismissionTransition()
        ui.prepareForButtonPresentation(withIn: deactivationTransition)
        deactivate(with: deactivationTransition)
    }
    
    private func panBegan() {
        activate(with: .defaultChangeover())
        moveInteractor.begin()
    }
    
    private func panMoved(to location: CGPoint, in view: UIView) {
        moveInteractor.move(to: coordinatesConverter.diagramPoint(for: location, in: view))
    }
    
    private func panEnded() {
        if !moveInteractor.canSave {
            moveInteractor.rollback()
            deactivate(with: .defaultChangeover())
        } else {
            do {
                try moveInteractor.save()
                deactivate(with: .defaultChangeover())
            } catch {
                moveInteractor.rollback()
                onError?(error)
            }
        }
    }
    
    private func panCancelled() {
        moveInteractor.rollback()
        deactivate(with: .defaultChangeover())
    }
    
//    func editLinkAnchorButtonPresenterWillBeginMovingButton(_ presenter: EditLinkAnchorButtonPresenter) {
//        activate(with: .defaultChangeover())
//        moveInteractor = MoveLinkAnchorInteractor(anchor: anchor)
//    }
//
//    func editLinkAnchorButtonPresenter(_ presenter: EditLinkAnchorButtonPresenter, didMoveButtonTo location: CGPoint) {
//        moveInteractor!.move(to: diagramViewController.diagramPoint(for: location, in: presenter.presentingView))
//    }
//
//    func editLinkAnchorButtonPresenterDidEndMovingButton(_ presenter: EditLinkAnchorButtonPresenter) {
//
//        if !moveInteractor!.canEnd {
//            moveInteractor!.rollback()
//            deactivate(with: .defaultChangeover())
//        } else {
//            do {
//                if UserDefaults.standard.simlateMoveLinkAnchorErrorsEnabled {
//                    throw DebugError()
//                }
//                try moveInteractor!.save()
//                deactivate(with: .defaultChangeover())
//            } catch (let error) {
//                moveInteractor!.rollback()
//                interactionsDelegate?.editLinkAnchorUseCasePresenter(self, didFailWith: error)
//            }
//        }
//
//        moveInteractor = nil
//    }
//
//    func editLinkAnchorButtonPresenterDidCancelMovingButton(_ presenter: EditLinkAnchorButtonPresenter) {
//
//        moveInteractor!.rollback()
//        moveInteractor = nil
//
//        deactivate(with: .defaultChangeover())
//    }
//
//    func editLinkAnchorButtonPresenterDidPressButton(_ presenter: EditLinkAnchorButtonPresenter) {
//
//        loadPopoverPresenterIfNeeded()
//
//        let sourcePointOnDiagram = anchor.location
//        let sourceSizeOnDiagram = Size(22, 22)
//        let sourceRectOnDiagram = Rect(center: sourcePointOnDiagram, size: sourceSizeOnDiagram)
//
//        let sourceView = diagramViewController.diagramContentView!
//        let sourceRect = diagramViewController.viewRect(for: sourceRectOnDiagram, in: sourceView)
//
//        popoverPresenter!.sourceView = sourceView
//        popoverPresenter!.sourceRect = sourceRect
//        popoverPresenter!.pointerDirection = anchor.direction.vector
//        popoverPresenter!.selectedPointerPreset = anchor.pointerPreset
//
//        let activationTransition = popoverPresenter!.preparePresentationTransition()
//        buttonPresenter.prepareForDismission(withIn: activationTransition)
//        activate(with: activationTransition)
//    }
//
//    // MARK: EditLinkAnchorPopoverPresenterInteractionsDelegate
//
//    func editLinkAnchorPopoverPresenter(_ presenter: EditLinkAnchorPopoverPresenter, didSelect preset: PointerPreset) {
//
//        let interactor = EditLinkAnchorInteractor(anchor: anchor)
//        interactor.setPointPreset(preset)
//
//        do {
//            if UserDefaults.standard.simulateEditLinkPointerErrorsEnabled {
//                throw DebugError()
//            }
//            try interactor.save()
//        } catch let error {
//            interactor.rollback()
//            interactionsDelegate?.editLinkAnchorUseCasePresenter(self, didFailWith: error)
//        }
//    }
//
//    func editLinkAnchorPopoverPresenterDidEndEditing(_ presenter: EditLinkAnchorPopoverPresenter) {
//        let deactivationTransition = presenter.prepareDismissionTransition()
//        buttonPresenter.prepareForPresentation(withIn: deactivationTransition)
//        deactivate(with: deactivationTransition)
//    }
    
    // MARK: - Layout
    
    func buttonLocation(in view: UIView) -> CGPoint {
        if moveInteractor.isOriginAnchor {
            return buttonsLayoutManager.originButtonLocation(in: view)
        } else {
            return buttonsLayoutManager.endingButtonLocation(in: view)
        }
    }
    
    var buttonVector: Vector {
        return moveInteractor.anchorVector
    }
    
    var buttonPointerPreset: PointerPreset {
        return editPropertiesInteractor.pointerPreset
    }
    
    func popoverSourceRect(in view: UIView) -> CGRect {
        let sourcePointOnDiagram = moveInteractor.anchorLocation
        let sourceSizeOnDiagram = Size(22, 22)
        let sourceRectOnDiagram = Rect(center: sourcePointOnDiagram, size: sourceSizeOnDiagram)
        return coordinatesConverter.viewRect(for: sourceRectOnDiagram, in: view)
    }
    
    func layout() {
        ui.layout()
    }
}
