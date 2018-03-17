//
//  BuildLinkUIPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import DiagramGeometry
import PresenterKit

class BuildLinkUI: BuildLinkUIProtocol {
    
    private let diagramViewController: UIViewController
    private let diagramBackgroundView: UIView
    private let diagramScrollView: UIScrollView
    private let diagramContentView: UIView
    
    weak var layoutDelegate: BuildLinkUILayoutDelegate!
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanCancelled: (() -> Void)?
    var onPanEnded: (() -> Void)?
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)?
    var onPresetsSelectionCancelled: (() -> Void)?
    
    init(diagramViewController: UIViewController,
         diagramBackgroundView: UIView,
         diagramScrollView: UIScrollView,
         diagramContentView: UIView) {
        
        self.diagramViewController = diagramViewController
        self.diagramBackgroundView = diagramBackgroundView
        self.diagramScrollView = diagramScrollView
        self.diagramContentView = diagramContentView
    }
    
    // MARK: - Presented items
    
    private lazy var buttonPresenter: BuildLinkButtonPresenter = {
        let presenter = BuildLinkButtonPresenter(
            presentingView: self.diagramScrollView)
        presenter.onPanBegan = { [unowned self] in self.onPanBegan?() }
        presenter.onPanMoved = { [unowned self] in self.onPanMoved?($0, $1) }
        presenter.onPanEnded = { [unowned self] in self.onPanEnded?() }
        presenter.onPanCancelled = { [unowned self] in self.onPanCancelled?() }
        return presenter
    }()
    
    private var directionZonesPresenter: BuildLinkDirectionZonesPresenter?
    
    private func loadDirectionZonesPresenterIfNeeded() {
        if directionZonesPresenter == nil {
            let presentingView = diagramBackgroundView
            let highlightedPath = layoutDelegate.highlightedPath(in: presentingView)
            directionZonesPresenter =  BuildLinkDirectionZonesPresenter(
                presentingView: presentingView,
                highlightedPath: highlightedPath)
        }
    }
    
    private var popoverPresenter: BuildSymbolPropertiesPopoverPresenter?
    
    private func loadPopoverPresenterIfNeeded() {
        if popoverPresenter == nil {
            let presenter = BuildSymbolPropertiesPopoverPresenter(
                presentingController: self.diagramViewController)
            presenter.sourceView = self.diagramContentView
            presenter.onPresetsSelected = { [unowned self] in self.onPresetsSelected?($0, $1) }
            presenter.onShouldDismiss = { [unowned self] in self.onPresetsSelectionCancelled?() }
            popoverPresenter = presenter
        }
    }
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
        buttonPresenter.buttonIcon = .direction(direction: layoutDelegate.buttonDirection)
    }
    
    // MARK: - Presentation
    
    var isButtonPresented: Bool {
        return buttonPresenter.isOn
    }
    
    func prepareForButtonPresentaion(withIn transition: Transition) {
        buttonPresenter.prepareForPresentation(withIn: transition)
        transition.addBeginning {
            self.layout()
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        buttonPresenter.prepareForDismission(withIn: transition)
    }
    
    var isDirectionZonesControlPresented: Bool {
        return directionZonesPresenter?.isOn ?? false
    }
    
    func prepareForDirectionZonesPresentation(withIn transition: Transition) {
        loadDirectionZonesPresenterIfNeeded()
        directionZonesPresenter!.prepareForPresentation(withIn: transition)
    }
    
    func prepareForDirectionZonesDismission(withIn transition: Transition) {
        guard let directionZonesPresenter = directionZonesPresenter else {
            fatalError("Direction zones presenter was not presented")
        }
        directionZonesPresenter.prepareForDismission(withIn: transition)
    }
    
    var isSymbolPresetsPopoverPresented: Bool {
        return popoverPresenter?.isOn ?? false
    }
    
    func prepateSymbolPresetsPopoverPresentationTransition() -> Transition {
        loadPopoverPresenterIfNeeded()
        popoverPresenter!.sourceRect = layoutDelegate.popoverSourceRect(in: popoverPresenter!.sourceView)
        return popoverPresenter!.preparePresentationTransition()
    }
    
    func prepateSymbolPresetsPopoverDismissionTransition() -> Transition {
        guard let popoverPresenter = popoverPresenter else {
            fatalError("Popover presenter was not presented")
        }
        return popoverPresenter.prepareDismissionTransition()
    }
}
