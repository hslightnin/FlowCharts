//
//  DeleteSymbolUseCaseUIPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class DeleteUI: FreePresenter, DeleteUIProtocol {
    
    var onButtonPressed: (() -> Void)?
    
    private let diagramScrollView: UIScrollView
    
    init(diagramScrollView: UIScrollView) {
        self.diagramScrollView = diagramScrollView
    }
    
    private lazy var buttonPresenter: DiagramButtonPresenter = {
        let presenter = DiagramButtonPresenter(presentingView: self.diagramScrollView)
        presenter.buttonIcon = .cross
        presenter.buttonBackground = .red
        presenter.onPressed = { [unowned self] in self.onButtonPressed?() }
        return presenter
    }()
    
    func prepareForButtonPresentation(withIn transition: Transition) {
        buttonPresenter.prepareForPresentation(withIn: transition)
        transition.addBeginning {
            self.layout()
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        buttonPresenter.prepareForDismission(withIn: transition)
    }
    
    weak var layoutDelegate: DeleteUILayoutDelegate!
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
    }
}
