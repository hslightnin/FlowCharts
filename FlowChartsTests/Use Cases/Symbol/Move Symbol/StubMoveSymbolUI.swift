//
//  StubMoveSymbolUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import PresenterKit
@testable import FlowCharts

class StubMoveSymbolUI: MoveSymbolUIProtocol {
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGVector, UIView) -> Void)?
    var onPanEnded: (() -> Void)?
    var onPanCancelled: (() -> Void)?
    
    var isPanPresented = false
    
    func prepareForPanPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isPanPresented = true
        }
    }
    
    func prepareForPanDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isPanPresented = false
        }
    }
}
