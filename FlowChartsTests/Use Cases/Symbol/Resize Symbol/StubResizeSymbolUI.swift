//
//  StubResizeSymbolUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
@testable import FlowCharts

class StubResizeSymbolUI: ResizeSymbolUIProtocol {
    
    var onBeganChoosingMode: ((Transition) -> Void)?
    var onEndedChoosingMode: ((Transition) -> Void)?
    
    var onPanBegan: ((SymbolResizingMode) -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    var isResizeControlOn = false
    
    func prepareForResizeControlPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isResizeControlOn = true
        }
    }
    
    func prepareForResizeControlDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isResizeControlOn = false
        }
    }
    
    var presentingView = UIView()
    var buttonLocation = CGPoint.zero
    
    weak var layoutDelegate: ResizeSymbolUILayoutDelegate!
    
    func layout() {
        buttonLocation = layoutDelegate.buttonLocation(in: presentingView)
    }
}
