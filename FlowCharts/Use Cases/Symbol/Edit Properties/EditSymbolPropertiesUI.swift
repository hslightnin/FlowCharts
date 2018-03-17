//
//  EditSymbolPropertiesUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class EditSymbolPropertiesUI: EditSymbolPropertiesUIProtocol {
    
    private let diagramViewController: UIViewController
    private let diagramScrollView: UIScrollView
    private let symbolView: UIView
    
    var selectedShapePreset: ShapePreset? {
        didSet { popoverPresenter?.selectedShapePreset = selectedShapePreset }
    }
    
    var selectedColor: UIColor? {
        didSet { popoverPresenter?.selectedColor = selectedColor }
    }
    
    var onButtonPressed: (() -> Void)?
    var onShapePresetSelected: ((ShapePreset) -> Void)?
    var onColorSelected: ((UIColor) -> Void)?
    var onSelectionEnded: (() -> Void)?
    
    init(diagramViewController: UIViewController,
         diagramScrollView: UIScrollView,
         symbolView: UIView) {
        
        self.diagramViewController = diagramViewController
        self.diagramScrollView = diagramScrollView
        self.symbolView = symbolView
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
    
    private var popoverPresenter: EditSymbolPropertiesPopoverPresenter?
    
    private func loadPopoverPresenterIfNeeded() {
        if popoverPresenter == nil {
            let presenter = EditSymbolPropertiesPopoverPresenter(
                presentingController: self.diagramViewController)
            presenter.sourceView = self.symbolView
            presenter.preferredArrowDirections = [.left, .right]
            presenter.shapePresets = ShapePreset.all
            presenter.colors = SymbolColorPresets.all
            presenter.selectedShapePreset = self.selectedShapePreset
            presenter.selectedColor = self.selectedColor
            presenter.onSelectedColorChanged = { [unowned self] in self.onColorSelected?($0) }
            presenter.onSelectedShapePresetChanged = { [unowned self] in self.onShapePresetSelected?($0) }
            presenter.onShouldDismiss = { [unowned self] in self.onSelectionEnded?() }
            popoverPresenter = presenter
        }
    }
    
    // MARK: - Presentation
    
    var isButtonPresented: Bool {
        return buttonPresenter.isOn
    }
    
    func prepareForButtonPresentation(withIn transition: Transition) {
        buttonPresenter.prepareForPresentation(withIn: transition)
        transition.addBeginning {
            self.layout()
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        buttonPresenter.prepareForDismission(withIn: transition)
    }
    
    var isPropertiesPopoverPresented: Bool {
        return popoverPresenter?.isOn ?? false
    }
    
    func preparePropertiesPopoverPresentationTransition() -> Transition {
        loadPopoverPresenterIfNeeded()
        popoverPresenter!.sourceRect = symbolView.bounds
        return popoverPresenter!.preparePresentationTransition()
    }
    
    func preparePropertiesPopoverDismissionTransition() -> Transition {
        return popoverPresenter!.prepareDismissionTransition()
    }
    
    var layoutDelegate: EditSymbolPropertiesUILayoutDelegate!
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
    }
}
