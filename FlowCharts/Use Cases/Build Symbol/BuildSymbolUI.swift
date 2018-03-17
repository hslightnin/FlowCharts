//
//  BuildSymbolUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit

class BuildSymbolUI: BuildSymbolUIProtocol {
    
    private let diagramViewController: UIViewController
    private let diagramScrollView: UIScrollView
    
    weak var layoutDelegate: BuildSymbolUILayoutDelegate!
    
    var onButtonPressed: (() -> Void)?
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)?
    var onPresetsSelectionCancelled: (() -> Void)?
    
    init(diagramViewController: UIViewController, diagramScrollView: UIScrollView) {
        self.diagramViewController = diagramViewController
        self.diagramScrollView = diagramScrollView
    }
    
    // MARK: - Pressented items
    
    private lazy var buttonPresenter: DiagramButtonPresenter = {
        let presentingView = self.diagramScrollView
        let presenter = DiagramButtonPresenter(presentingView: presentingView)
        presenter.buttonIcon = .plus
        presenter.buttonBackground = .green
        presenter.buttonLocation = self.layoutDelegate.buttonLocation(in: presentingView)
        presenter.onPressed = { [unowned self] in self.onButtonPressed?() }
        return presenter
    }()
    
    private var popoverPresenter: BuildSymbolPropertiesPopoverPresenter?
    
    private func loadPopoverPresenterIfNeeded() {
        if popoverPresenter == nil {
            let presenter = BuildSymbolPropertiesPopoverPresenter(
                presentingController: self.diagramViewController)
            presenter.sourceView = self.diagramScrollView
            presenter.sourceRect = layoutDelegate.popoverSourceRect(in: self.diagramScrollView)
            presenter.preferredArrowDirections = [.left, .right]
            presenter.onPresetsSelected = { [unowned self] in self.onPresetsSelected?($0, $1) }
            presenter.onShouldDismiss = { [unowned self] in self.onPresetsSelectionCancelled?() }
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
    
    var isPresetsPopoverPresented: Bool {
        return popoverPresenter?.isOn ?? false
    }
    
    func preparePresetsPopoverPresentationTransition() -> Transition {
        loadPopoverPresenterIfNeeded()
        return popoverPresenter!.preparePresentationTransition()
    }
    
    func preparePresetsPopoverDismissionTransition() -> Transition {
        return popoverPresenter!.prepareDismissionTransition()
    }
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
    }
}
