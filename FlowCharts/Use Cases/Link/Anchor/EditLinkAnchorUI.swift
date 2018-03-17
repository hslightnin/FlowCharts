//
//  EditLinkAnchorUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 09/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
import PresenterKit

class EditLinkAnchorUI: EditLinkAnchorUIProtocol {
    
    var onButtonPressed: (() -> Void)?
    var onSelectedPointerPresetChanged: ((PointerPreset) -> Void)?
    var onPopoverShouldDismiss: (() -> Void)?
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    private let diagramViewController: UIViewController
    private let diagramScrollView: UIScrollView
    
    init(diagramViewController: UIViewController,
         diagramScrollView: UIScrollView) {
        
        self.diagramViewController = diagramViewController
        self.diagramScrollView = diagramScrollView
    }
    
    // MARK: - Properties
    
    var pointerVector: Vector {
        get {
            loadPopoverPresenterIfNeeded()
            return popoverPresenter!.pointerDirection
        }
        set {
            loadPopoverPresenterIfNeeded()
            popoverPresenter!.pointerDirection = newValue
        }
    }
    
    var selectedPointerPreset: PointerPreset? {
        get {
            loadPopoverPresenterIfNeeded()
            return popoverPresenter!.selectedPointerPreset
        }
        set {
            loadPopoverPresenterIfNeeded()
            popoverPresenter!.selectedPointerPreset = newValue
        }
    }
    
    // MARK: - Presented items
    
    private lazy var buttonPresenter: EditLinkAnchorButtonPresenter = {
        let presentingView = self.diagramScrollView
        let presenter = EditLinkAnchorButtonPresenter(presentingView: presentingView)
        presenter.onPressed = { [unowned self] in self.onButtonPressed?() }
        presenter.onPanBegan = { [unowned self] in self.onPanBegan?() }
        presenter.onPanMoved = { [unowned self] in self.onPanMoved?($0, $1) }
        presenter.onPanEnded = { [unowned self] in self.onPanEnded?() }
        presenter.onPanCancelled = { [unowned self] in self.onPanCancelled?() }
        return presenter
    }()
    
    private var popoverPresenter: EditLinkAnchorPopoverPresenter?
    
    private func loadPopoverPresenterIfNeeded() {
        if popoverPresenter == nil {
            let presenter = EditLinkAnchorPopoverPresenter(
                presentingController: diagramViewController)
            presenter.sourceView = diagramScrollView
            presenter.preferredArrowDirections = [.up, .down]
            presenter.pointerPresets = PointerPreset.all
            presenter.onSelectedPresetChanged = { [unowned self] in self.onSelectedPointerPresetChanged?($0) }
            presenter.onShouldDismiss = { [unowned self] in self.onPopoverShouldDismiss?() }
            popoverPresenter = presenter
        }
    }
    
    // MARK: - Presentation
    
    var isButtonPresented: Bool {
        return buttonPresenter.isOn
    }
    
    func prepareForButtonPresentation(withIn transition: Transition) {
        buttonPresenter.prepareForPresentation(withIn: transition)
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        buttonPresenter.prepareForDismission(withIn: transition)
    }
    
    var isPropertiesPopoverPresented: Bool {
        return popoverPresenter?.isOn ?? false
    }
    
    func preparePropertiesPopoverPresentationTransition() -> Transition {
        loadPopoverPresenterIfNeeded()
        popoverPresenter!.sourceRect = layoutDelegate.popoverSourceRect(in: popoverPresenter!.sourceView)
        return popoverPresenter!.preparePresentationTransition()
    }
    
    func preparePropertiesPopoverDismissionTransition() -> Transition {
        return popoverPresenter!.prepareDismissionTransition()
    }
    
    var layoutDelegate: EditLinkAnchorLayoutDelegate!
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
        buttonPresenter.pointerPreset = layoutDelegate.buttonPointerPreset
        buttonPresenter.pointerVector = layoutDelegate.buttonVector
    }
}
