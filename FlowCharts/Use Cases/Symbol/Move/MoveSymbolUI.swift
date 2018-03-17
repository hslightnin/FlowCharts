//
//  MoveSymbolUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class MoveSymbolUI: MoveSymbolUIProtocol {
    
    private let symbolView: UIView
    
    init(symbolView: UIView) {
        self.symbolView = symbolView
    }
    
    // MARK: - MoveSymbolUIProtocol
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGVector, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    func prepareForPanPresentation(withIn transition: Transition) {
        moveGesturePresenter.shouldBeRequiredToFailByOtherGestureRecognizers = true
        moveGesturePresenter.prepareForPresentation(withIn: transition)
    }
    
    func prepareForPanDismission(withIn transition: Transition) {
        moveGesturePresenter.prepareForDismission(withIn: transition)
    }
    
    // MARK: - Presented items
    
    private lazy var moveGesturePresenter: PanGestureRecognizerPresenter = {
        let presenter = PanGestureRecognizerPresenter(presentingView: self.symbolView)
        presenter.shouldBeRequiredToFailByOtherGestureRecognizers = true
        presenter.onBegan = { [unowned self] in self.onPanBegan?() }
        presenter.onChanged = { [unowned self] in self.onPanMoved?($0, $1) }
        presenter.onEnded = { [unowned self] in self.onPanEnded?() }
        presenter.onCancelled = { [unowned self] in self.onPanCancelled?() }
        return presenter
    }()
}
