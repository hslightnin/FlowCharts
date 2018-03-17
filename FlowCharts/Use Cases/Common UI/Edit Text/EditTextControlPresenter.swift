//
//  TextViewPresenter.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 10/12/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit

class DiagramTextViewPresenter: FreePresenter, UITextViewDelegate {
    
    let presentingView: UIView
    let scrollView: UIScrollView
    private var initialContentOffset: CGPoint?

    var onCancelledEditing: (() -> Void)?
    var onEndedEditing: (() -> Void)?
    
    init(presentingView: UIView, scrollView: UIScrollView) {
        self.presentingView = presentingView
        self.scrollView = scrollView
    }
    
    // MARK: - Properties
    
    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
            layout()
        }
    }
    
    var attributedText: NSAttributedString? {
        get {
            return textView.attributedText
        }
        set {
            textView.attributedText = attributedText
            layout()
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize) {
        didSet {
            textView.font = font
            layout()
        }
    }
    
    var minTextViewWidth: CGFloat = 0.0 {
        didSet {
            layout()
        }
    }
    
    var maxTextViewWidth: CGFloat = .greatestFiniteMagnitude {
        didSet {
            layout()
        }
    }
    
    var textInsets: UIEdgeInsets {
        get {
            return textView.textContainerInset
        }
        set {
            textView.textContainerInset = newValue
        }
    }
    
    var textViewCenter: CGPoint = .zero {
        didSet {
            layout()
        }
    }
    
    // MARK: - Presented items
    
    private lazy var textView: UITextView = {
        
        let textView = UITextView(frame: CGRect.zero)
        textView.textAlignment = .center
        textView.backgroundColor = .white
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5
        
        let assitantItem = textView.inputAssistantItem

        let cancelBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(self.cancel(_:)))

        let doneBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.done(_:)))

        let doneButtonFont = UIFont.boldSystemFont(ofSize: UIFont.buttonFontSize)
        let doneButtonTitleAttributes = [NSFontAttributeName: doneButtonFont];
        doneBarButtonItem.setTitleTextAttributes(doneButtonTitleAttributes, for: .normal)

        let representativeItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: nil,
            action: nil)

        assitantItem.trailingBarButtonGroups = [
            UIBarButtonItemGroup(
                barButtonItems: [cancelBarButtonItem, doneBarButtonItem],
                representativeItem: representativeItem)
        ]

        return textView
    }()
    
    // MARK: - Lifecycle
    
    override func setUpPresentation(withIn transition: Transition) {
        super.setUpPresentation(withIn: transition)
        transition.add(beginning: {
            self.presentingView.addSubview(self.textView)
//            self.scrollView.addSubview(self.textView)
            self.textView.textInputView.contentScaleFactor = self.scrollView.zoomScale * UIScreen.main.scale
            self.layout()
            NotificationCenter.default.addObserver(
                self, selector: #selector(self.keyboardWillShow(_:)),
                name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(
                self, selector: #selector(self.keyboardWillHide(_:)),
                name: .UIKeyboardWillHide, object: nil)
            self.textView.delegate = self
            self.textView.becomeFirstResponder()
            self.textView.alpha = 0.0
        }, animation: {
            self.textView.alpha = 1.0
            
            
        })
    }
    
    override func setUpDismission(withIn transition: Transition) {
        super.setUpDismission(withIn: transition)
        transition.add(beginning: {
            self.textView.delegate = nil
            self.textView.resignFirstResponder()
            NotificationCenter.default.removeObserver(
                self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(
                self, name: .UIKeyboardWillHide, object: nil)
        }, animation: {
            self.textView.alpha = 0.0
        }, completion: {
            self.textView.removeFromSuperview()
        })
    }
    
    private func layout() {
//        let textInset = textView.textContainerInset
        let maxSize = CGSize(width: maxTextViewWidth, height: CGFloat.greatestFiniteMagnitude)
        let sizeThatFits = textView.sizeThatFits(maxSize)
        let textViewWidth = max(minTextViewWidth, sizeThatFits.width)
        let textViewHeight = sizeThatFits.height
        let center = textViewCenter
        textView.frame = CGRect(
            x: center.x - textViewWidth / 2,
            y: center.y - textViewHeight / 2,
            width: textViewWidth,
            height: textViewHeight)
    }
    
    // MARK: - Interactions
    
    func done(_ sender: UIBarButtonItem) {
        textView.delegate = nil
        textView.resignFirstResponder()
        onEndedEditing?()
    }
    
    func cancel(_ sender: UIBarButtonItem) {
        textView.delegate = nil
        textView.resignFirstResponder()
        onCancelledEditing?()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        layout()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        onEndedEditing?()
    }
    
    func keyboardWillShow(_ notification: Notification) {
        
        // When using "Dock and Merge" key this notification is fired twice (iOS 11, Simulator)
        // Second time with wrong values
        // TODO: Check on other iOS versions and custom keyboards
        
        let isFirstNotification = initialContentOffset == nil
        if isFirstNotification {
            let keyboardFrame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
            let textViewFrame = textView.convert(textView.bounds, to: nil)
            initialContentOffset = scrollView.contentOffset
            if keyboardFrame.intersects(textViewFrame) {
                var contentOffset = scrollView.contentOffset
                contentOffset.y += textViewFrame.midY - (keyboardFrame.minY + scrollView.contentInset.top) / 2
                scrollView.setContentOffset(contentOffset, animated: false)
            }
            
            scrollView.panGestureRecognizer.isEnabled = false
            scrollView.pinchGestureRecognizer?.isEnabled = false
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        // This notification can be fired twice
        // See keyboardWillShow(_:) for details
        // TODO: Check on other iOS versions and custom keyboards
        
        let isFirstNotification = initialContentOffset != nil
        if isFirstNotification {
            scrollView.setContentOffset(initialContentOffset!, animated: false)
            initialContentOffset = nil
            
            scrollView.panGestureRecognizer.isEnabled = true
            scrollView.pinchGestureRecognizer?.isEnabled = true
        }
    }
}

