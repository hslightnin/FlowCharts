//
//  StubEditTextUI.swift
//  FlowChartsTests
//
//  Created by Alexander Kozlov on 08/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import PresenterKit
@testable import FlowCharts

class StubEditTextUI: EditTextUIProtocol {
    
    var text: String?
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var textInsets: UIEdgeInsets = .zero
    
    var onButtonPressed: (() -> Void)?
    var onDoubleTapRecognized: (() -> Void)?
    var onTextViewEndedEditing: (() -> Void)?
    var onTextViewCancelledEditing: (() -> Void)?
    var onCancelTapRecognized: (() -> Void)?
    
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
    
    var isDoubleTapPresented = false
    
    func prepareForDoubleTapPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isDoubleTapPresented = true
        }
    }
    
    func prepareForDoubleTapDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isDoubleTapPresented = false
        }
    }
    
    var isTextViewPresented = false
    
    func prepareForTextViewPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isTextViewPresented = true
        }
    }
    
    func prepareForTextViewDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isTextViewPresented = false
        }
    }
    
    var isCancelTapPresented = false
    
    func prepareForCancelTapPresentation(withIn transition: Transition) {
        transition.addBeginning {
            self.isCancelTapPresented = true
        }
    }
    
    func prepareForCancelTapDismission(withIn transition: Transition) {
        transition.addBeginning {
            self.isCancelTapPresented = false
        }
    }
    
    let presentingView = UIView()
    private(set) var buttonLocation = CGPoint.zero
    private(set) var textViewLocation = CGPoint.zero
    private(set) var textViewWidth = CGFloat(0.0)
    
    weak var layoutDelegate: EditTextUILayoutDelegate!
    
    func layout() {
        buttonLocation = layoutDelegate.buttonLocation(in: presentingView)
        textViewLocation = layoutDelegate.textViewLocation(in: presentingView)
        textViewWidth = layoutDelegate.maxTextViewWidth(in: presentingView)
    }
}
