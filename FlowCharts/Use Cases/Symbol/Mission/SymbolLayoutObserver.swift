//
//  SymbolLayoutObserver.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/03/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import Foundation
import DiagramView

class SymbolLayoutObserver: SymbolLayoutObserverProtocol {
    
    private let symbol: FlowChartSymbol
    private let diagramViewController: DiagramViewController
    private let symbolPresenter: SymbolPresenter
    
    private var diagramZoomObserver: NSObjectProtocol?
    private var symbolLayoutObserver: NSObjectProtocol?
    
    var onLayoutChanged: (() -> Void)?
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
        self.symbolPresenter = diagramViewController.presenter(for: symbol.dataSource)!
    }
    
    func beginObservingLayout() {
        
        diagramZoomObserver = NotificationCenter.default.addObserver(
            forName: .diagramViewControllerDidZoom,
            object: diagramViewController,
            queue: nil,
            using: { [unowned self] _ in self.onLayoutChanged?() })
        
        symbolLayoutObserver = NotificationCenter.default.addObserver(
            forName: .symbolPresenterDidLayout,
            object: symbolPresenter,
            queue: nil,
            using: { [unowned self] _ in self.onLayoutChanged?() })
    }
    
    func endObservingLayout() {
        NotificationCenter.default.removeObserver(diagramZoomObserver!)
        NotificationCenter.default.removeObserver(symbolLayoutObserver!)
    }
}
