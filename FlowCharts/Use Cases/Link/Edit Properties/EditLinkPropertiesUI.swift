//
//  EditLinkPropertiesUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class EditLinkPropertiesUI: EditLinkPropertiesUIProtocol {
    
    private let diagramViewController: UIViewController
    private let diagramScrollView: UIScrollView
    private let linkView: UIView
    
    var onSelectedPresetsChanged: ((LineTypePreset, LineDashPatternPreset) -> Void)?
    var onButtonPressed: (() -> Void)?
    var onPopoverShouldDismiss: (() -> Void)?
    
    init(diagramViewController: UIViewController,
         diagramScrollView: UIScrollView,
         linkView: UIView) {
        
        self.diagramViewController = diagramViewController
        self.diagramScrollView = diagramScrollView
        self.linkView = linkView
    }
    
    var selectedLineTypePreset: LineTypePreset? {
        get {
            loadPopoverPresenterIfNeeded()
            return popoverPresenter!.selectedLineTypePreset
        }
        set {
            loadPopoverPresenterIfNeeded()
            popoverPresenter!.selectedLineTypePreset = newValue
        }
    }
    
    var selectedLineDashPatternPreset: LineDashPatternPreset? {
        get {
            loadPopoverPresenterIfNeeded()
            return popoverPresenter!.selectedLineDashPatternPreset
        }
        set {
            loadPopoverPresenterIfNeeded()
            popoverPresenter!.selectedLineDashPatternPreset = newValue
        }
    }
    
    // MARK: - Presented items
    
    private lazy var buttonPresenter: DiagramButtonPresenter = {
        let presentingView = self.diagramScrollView
        let presenter = DiagramButtonPresenter(presentingView: presentingView)
        presenter.buttonIcon = .gear
        presenter.buttonBackground = .blue
        presenter.onPressed = { [unowned self] in self.onButtonPressed?() }
        return presenter
    }()
    
    private var popoverPresenter: EditLinkPropertiesPopoverPresenter?
    
    private func loadPopoverPresenterIfNeeded() {
        if popoverPresenter == nil {
            let presenter = EditLinkPropertiesPopoverPresenter(
                presentingController: self.diagramViewController)
            presenter.sourceView = self.linkView
            presenter.sourceRect = self.linkView.bounds
            presenter.onSelectedPresetsChanged = { [unowned self] in self.onSelectedPresetsChanged?($0, $1) }
            presenter.onShouldDismiss = { [unowned self] in self.onPopoverShouldDismiss?() }
            popoverPresenter = presenter
        }
    }
    
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
        popoverPresenter!.sourceRect = linkView.bounds
        return popoverPresenter!.preparePresentationTransition()
    }
    
    func preparePropertiesPopoverDismissionTransition() -> Transition {
        return popoverPresenter!.prepareDismissionTransition()
    }
    
    var layoutDelegate: EditLinkPropertiesUILayoutDelegate!
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
    }
}
