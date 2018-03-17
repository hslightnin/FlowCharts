//
//  SymbolPropertiesPresenter.swift
//  FlowCharts
//
//  Created by Alexandr Kozlov on 28/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramView

class SymbolPropertiesPresenter: NSObject, SymbolAccessoryPresenter {
    
    weak var buttonsLayoutManager: SymbolButtonsLayoutManager?
    
    let symbol: FlowChartSymbol
    private var deleteInteractor: SymbolDeleteInteractor?
    private var diagramViewController: DiagramViewController?
    private var button: UIButton?
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
    }
    
    func present() {
        self.button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.button!.backgroundColor = UIColor.blue
        self.diagramViewController?.view.addSubview(self.button!)
    }
    
    func dismiss() {
        self.button!.removeFromSuperview()
    }
    
    func layout() {
        self.button!.center = self.buttonsLayoutManager!.location(forPresenterButton: self, in: self.button!.superview!)
    }
}
