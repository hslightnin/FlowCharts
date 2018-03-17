//
//  StubDeleteUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class StubDeleteUI: DeleteUIProtocol {
    
    var onButtonPressed: (() -> Void)?
    
    var isButtonPresented = false
    
    func prepareForButtonPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = true
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = false
        }
    }
    
    let presentingView = UIView()
    private(set) var buttonLocation = CGPoint.zero
    
    weak var layoutDelegate: DeleteUILayoutDelegate!
    
    func layout() {
        buttonLocation = layoutDelegate.buttonLocation(in: presentingView)
    }
}
