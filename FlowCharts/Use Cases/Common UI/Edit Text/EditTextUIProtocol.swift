//
//  EditSymbolTextProtocol.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

protocol EditTextUILayoutDelegate: class {
    func buttonLocation(in view: UIView) -> CGPoint
    func textViewLocation(in view: UIView) -> CGPoint
//    func textViewWidth(in view: UIView) -> CGFloat
    
    func minTextViewWidth(in view: UIView) -> CGFloat
    func maxTextViewWidth(in view: UIView) -> CGFloat
}

protocol EditTextUIProtocol: class {
    
    // Properties
    
    var text: String? { get set }
    var font: UIFont { get set }
    var textInsets: UIEdgeInsets { get set }
    
    // Events
    
    var onButtonPressed: (() -> Void)? { get set }
    var onDoubleTapRecognized: (() -> Void)? { get set }
    var onTextViewEndedEditing: (() -> Void)? { get set }
    var onTextViewCancelledEditing: (() -> Void)? { get set }
    var onCancelTapRecognized: (() -> Void)? { get set }
    
    // Presentation
    
    var isButtonPresented: Bool { get }
    func prepareForButtonPresentation(withIn transition: Transition)
    func prepareForButtonDismission(withIn transition: Transition)
    
    var isDoubleTapPresented: Bool { get }
    func prepareForDoubleTapPresentation(withIn transition: Transition)
    func prepareForDoubleTapDismission(withIn transition: Transition)
    
    var isTextViewPresented: Bool { get }
    func prepareForTextViewPresentation(withIn transition: Transition)
    func prepareForTextViewDismission(withIn transition: Transition)
    
    var isCancelTapPresented: Bool { get }
    func prepareForCancelTapPresentation(withIn transition: Transition)
    func prepareForCancelTapDismission(withIn transition: Transition)
    
    // Layout
    
    weak var layoutDelegate: EditTextUILayoutDelegate! { get set }
    func layout()
}
