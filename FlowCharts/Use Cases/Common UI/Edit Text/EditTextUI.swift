//
//  EditSymbolTestUI.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class EditTextUI: EditTextUIProtocol {
    
    var onButtonPressed: (() -> Void)?
    var onDoubleTapRecognized: (() -> Void)?
    var onTextViewEndedEditing: (() -> Void)?
    var onTextViewCancelledEditing: (() -> Void)?
    var onCancelTapRecognized: (() -> Void)?
    
    private let diagramScrollView: UIScrollView
    private let diagramContentView: UIView
    private let symbolView: UIView
    
    weak var layoutDelegate: EditTextUILayoutDelegate!
    
    init(diagramScrollView: UIScrollView,
         diagramContentView: UIView,
         itemView: UIView) {
        
        self.diagramScrollView = diagramScrollView
        self.diagramContentView = diagramContentView
        self.symbolView = itemView
    }
    
    // MARK: - Presented items
    
    private lazy var buttonPresenter: DiagramButtonPresenter = {
        let presentingView = self.diagramScrollView
        let presenter = DiagramButtonPresenter(presentingView: presentingView)
        presenter.buttonIcon = .pen
        presenter.buttonBackground = .blue
        presenter.onPressed = { [unowned self] in self.onButtonPressed?() }
        return presenter
    }()
    
    private lazy var doubleTapGestureRecognizerPresenter: TapGestureRecognizerPresenter = {
        let presenter = TapGestureRecognizerPresenter(presentingView: self.symbolView, numberOfTapsRequired: 2)
        presenter.onRecognized = { [unowned self] in self.onDoubleTapRecognized?() }
        return presenter
    }()
    
    private var textViewPresenter: DiagramTextViewPresenter?
    
    private func loadTextViewPresenterIfNeeded() {
        if textViewPresenter == nil {
            let presentingView = diagramContentView
            let presenter = DiagramTextViewPresenter(
                presentingView: presentingView,
                scrollView: diagramScrollView)
            presenter.onEndedEditing = { [unowned self] in self.onTextViewEndedEditing?() }
            presenter.onCancelledEditing = { [unowned self] in self.onTextViewCancelledEditing?() }
            presenter.minTextViewWidth = layoutDelegate.minTextViewWidth(in: presentingView)
            presenter.maxTextViewWidth = layoutDelegate.maxTextViewWidth(in: presentingView)
            presenter.textViewCenter = layoutDelegate.textViewLocation(in: presentingView)
            textViewPresenter = presenter
        }
    }
    
    private var tapGestureRecognizerPresenter: TapGestureRecognizerPresenter?
    
    private func loadTapGestureRecognizerPresenterIfNeeded() {
        if tapGestureRecognizerPresenter == nil {
            let presenter = TapGestureRecognizerPresenter(
                presentingView: diagramContentView)
            presenter.shouldBeRequiredToFailByOthers = true
            presenter.onRecognized = { [unowned self] in self.onCancelTapRecognized?() }
            tapGestureRecognizerPresenter = presenter
        }
    }
    
    // MARK: - Properties
    
    var text: String? {
        
        get {
            return textViewPresenter?.text
        }
        
        set {
            loadTextViewPresenterIfNeeded()
            textViewPresenter!.text = newValue
        }
    }
    
    var font: UIFont {
        
        get {
            loadTextViewPresenterIfNeeded()
            return textViewPresenter!.font
        }
        
        set {
            loadTextViewPresenterIfNeeded()
            textViewPresenter!.font = newValue
        }
    }
    
    var textInsets: UIEdgeInsets {
        
        get {
            loadTextViewPresenterIfNeeded()
            return textViewPresenter!.textInsets
        }
        
        set {
            loadTextViewPresenterIfNeeded()
            textViewPresenter!.textInsets = newValue
        }
    }
    
    // MARK: - Presentation
    
    // MARK: Button
    
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
    
    // MARK: Double tap
    
    var isDoubleTapPresented: Bool {
        return doubleTapGestureRecognizerPresenter.isOn
    }
    
    func prepareForDoubleTapPresentation(withIn transition: Transition) {
        doubleTapGestureRecognizerPresenter.prepareForPresentation(withIn: transition)
    }
    
    func prepareForDoubleTapDismission(withIn transition: Transition) {
        doubleTapGestureRecognizerPresenter.prepareForDismission(withIn: transition)
    }
    
    // MARK: Text view
    
    var isTextViewPresented: Bool {
        return textViewPresenter?.isOn ?? false
    }
    
    func prepareForTextViewPresentation(withIn transition: Transition) {
        loadTextViewPresenterIfNeeded()
        textViewPresenter!.prepareForPresentation(withIn: transition)
    }
    
    func prepareForTextViewDismission(withIn transition: Transition) {
        textViewPresenter!.prepareForDismission(withIn: transition)
    }
    
    // MARK: Cancel tap
    
    var isCancelTapPresented: Bool {
        return tapGestureRecognizerPresenter?.isOn ?? false
    }
    
    func prepareForCancelTapPresentation(withIn transition: Transition) {
        loadTapGestureRecognizerPresenterIfNeeded()
        tapGestureRecognizerPresenter!.prepareForPresentation(withIn: transition)
    }
    
    func prepareForCancelTapDismission(withIn transition: Transition) {
        tapGestureRecognizerPresenter!.prepareForDismission(withIn: transition)
    }
    
    // MARK: - Layout
    
    func layout() {
        buttonPresenter.buttonLocation = layoutDelegate.buttonLocation(in: buttonPresenter.presentingView)
        textViewPresenter?.textViewCenter = layoutDelegate.textViewLocation(in: textViewPresenter!.presentingView)
    }
}
