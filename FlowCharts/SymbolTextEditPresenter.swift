//
//  SymbolTextEditPresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 28/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
import DiagramView

class SymbolTextEditPresenter: NSObject, SymbolAccessoryPresenter, UITextViewDelegate {
    
    weak var buttonsLayoutManager: SymbolButtonsLayoutManager?
    
    let symbol: FlowChartSymbol
    let diagramViewController: DiagramViewController
    
    private var button: UIButton?
    private var doubleTapGestureRecognizer: UITapGestureRecognizer?
    private var textView: UITextView?
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
    }
    
    func present() {
        
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.button!.backgroundColor = UIColor.blue
        self.button!.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
        self.diagramViewController.view.addSubview(self.button!)
        
        self.doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        self.doubleTapGestureRecognizer!.numberOfTapsRequired = 2
        self.diagramViewController.view.addGestureRecognizer(self.doubleTapGestureRecognizer!)
    }
    
    func dismiss() {
        self.hideTextField()
        self.button!.removeFromSuperview()
        self.diagramViewController.view.removeGestureRecognizer(self.doubleTapGestureRecognizer!)
    }
    
    func layout() {
        self.button!.center = self.buttonsLayoutManager!.location(forPresenterButton: self, in: self.button!.superview!)
    }
    
    func buttonPress(_ sender: UIButton) {
        self.showTextField()
    }
    
    func doubleTap(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            self.showTextField()
        }
    }
    
    private func showTextField() {
        let symbolRectInDiagram = self.symbol.rect
        let symbolRectInView = try! self.diagramViewController.viewRect(for: symbolRectInDiagram, in: self.diagramViewController.view)
        self.textView = UITextView(frame: symbolRectInView)
        self.textView!.delegate = self
        self.diagramViewController.view.addSubview(self.textView!)
    }
    
    private func hideTextField() {
        self.textView?.removeFromSuperview()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let symbolRectInDiagram = self.symbol.rect
        let symbolRectInView = try! self.diagramViewController.viewRect(for: symbolRectInDiagram, in: self.diagramViewController.view)
        
        var frame = self.textView!.frame
        frame.size.height = self.textView!.sizeThatFits(CGSize(width: Double(symbolRectInView.width), height: Double.greatestFiniteMagnitude)).height
        self.textView!.frame = frame
    }
}
