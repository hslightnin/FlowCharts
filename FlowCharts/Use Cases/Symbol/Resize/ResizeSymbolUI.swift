//
//  ResizeSymbolUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class ResizeSymbolUI: ResizeSymbolUIProtocol {
    
    private let diagramScrollView: UIScrollView
    
    var onBeganChoosingMode: ((Transition) -> Void)?
    var onEndedChoosingMode: ((Transition) -> Void)?
    var onPanBegan: ((SymbolResizingMode) -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    weak var layoutDelegate: ResizeSymbolUILayoutDelegate!
    
    init(diagramScrollView: UIScrollView) {
        self.diagramScrollView = diagramScrollView
    }
    
    // MARK: - Presented items
    
    private lazy var buttonsPresenter: ResizeSymbolControlPresenter = {
        let presenter = ResizeSymbolControlPresenter(presentingView: self.diagramScrollView)
        presenter.onBeginChoosingMode = { [unowned self] in self.onBeganChoosingMode?($0) }
        presenter.onEndChoosingMode = { [unowned self] in self.onEndedChoosingMode?($0) }
        presenter.onPanBegan = { [unowned self] in self.onPanBegan?($0) }
        presenter.onPanMoved = { [unowned self] in self.onPanMoved?($0, $1) }
        presenter.onPanEnded = { [unowned self] in self.onPanEnded?() }
        presenter.onPanCancelled = { [unowned self] in self.onPanCancelled?() }
        return presenter
    }()
    
    // MARK: - Presentation
    
    func prepareForResizeControlPresentation(withIn transition: Transition) {
        buttonsPresenter.prepareForPresentation(withIn: transition)
        transition.addBeginning {
            self.layout()
        }
    }
    
    func prepareForResizeControlDismission(withIn transition: Transition) {
        buttonsPresenter.prepareForDismission(withIn: transition)
    }
    
    func layout() {
        buttonsPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonsPresenter.presentingView)
    }
}
