//
//  StubBuildLinkUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
import DiagramGeometry
@testable import FlowCharts

class StubBuildLinkUI: BuildLinkUIProtocol {
    
    var onPanBegan: (() -> Void)?
    var onPanMoved: ((CGPoint, UIView) -> Void)?
    var onPanCancelled: (() -> Void)?
    var onPanEnded: (() -> Void)?
    var onPresetsSelected: ((ShapePreset, UIColor) -> Void)?
    var onPresetsSelectionCancelled: (() -> Void)?
    
    var isButtonPresented = false
    
    func prepareForButtonPresentaion(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = true
        }
    }
    
    func prepareForButtonDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isButtonPresented = false
        }
    }
    
    var isDirectionZonesControlPresented = false
    
    func prepareForDirectionZonesPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isDirectionZonesControlPresented = true
        }
    }
    
    func prepareForDirectionZonesDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isDirectionZonesControlPresented = false
        }
    }
    
    var isSymbolPresetsPopoverPresented = false
    
    func prepateSymbolPresetsPopoverPresentationTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isSymbolPresetsPopoverPresented = true
        }
        return transition
    }
    
    func prepateSymbolPresetsPopoverDismissionTransition() -> Transition {
        let transition = Transition.instant()
        transition.addBeginning {
            self.isSymbolPresetsPopoverPresented = false
        }
        return transition
    }
    
    let presentingView = UIView()
    private(set) var buttonLocation: CGPoint?
    private(set) var buttonDirection: Direction?
    
    weak var layoutDelegate: BuildLinkUILayoutDelegate!
    
    func layout() {
        buttonLocation = layoutDelegate.buttonLocation(in: presentingView)
        buttonDirection = layoutDelegate.buttonDirection
    }
}
