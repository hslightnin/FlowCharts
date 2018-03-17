//
//  SymbolAccessoriesPresenter.swift
//  FlowCharts
//
//  Created by alex on 12/08/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class SymbolAccessoriesPresenter {
    
    private let symbol: FlowChartSymbol
    private let diagramViewController: DiagramViewController
    
    weak var delegate: SymbolViewObserverDelegate?
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
    }
    
    var isObserving = false {
        didSet {
            if self.isObserving {
                self.beginObserving()
            } else {
                self.endObserving()
            }
        }
    }
    
    private func beginObserving() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(diagramViewDidZoom(_:)),
                                               name: .diagramViewControllerDidZoom,
                                               object: self.diagramViewController)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(symbolViewDidChangeFrame(_:)),
                                               name: .symbolViewPresenterDidChangeFrame,
                                               object: self.diagramViewController.presenter(for: self.symbol))
    }
    
    private func endObserving() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .diagramViewControllerDidZoom,
                                                  object: self.diagramViewController)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: .symbolViewPresenterDidChangeFrame,
                                                  object: self.diagramViewController.presenter(for: self.symbol))
    }
    
    @objc func diagramViewDidZoom(_ notification: Notification) {
        self.delegate?.symbolViewObserverDidObserveLayoutChange(self)
    }
    
    @objc func symbolViewDidChangeFrame(_ notification: Notification) {
        self.delegate?.symbolViewObserverDidObserveLayoutChange(self)
    }
}
