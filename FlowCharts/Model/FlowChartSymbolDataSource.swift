//
//  FlowChartSymbolDataSource.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 15/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import PresenterKit
import DiagramGeometry
import DiagramView

class FlowChartSymbolDataSource: SymbolDataSource {
    
    unowned let symbol: FlowChartSymbol
    
    var delegate: SymbolDataSourceDelegate?
    
    private(set) var shape: Shape
    private(set) var fillColor: UIColor
    private(set) var strokeColor: UIColor
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
        self.shape = symbol.shape
        self.fillColor = symbol.color
        self.strokeColor = FlowChartSymbol.normalStrokeColor
    }
    
    // MARK: - Shape
    
    func updateShape(withIn transition: Transition) {
        changeShape(symbol.shape, withIn: transition)
    }
    
    private func changeShape(_ shape: Shape, withIn transition: Transition) {
        transition.addBeginning {
            self.shape = shape
        }
        delegate?.symbolWillChangeShape(self, withIn: transition)
    }
    
    // MARK: - Fill color
    
    func updateFillColor(withIn transition: Transition) {
        changeFillColor(symbol.color, withIn: transition)
    }
    
    private func changeFillColor(_ color: UIColor, withIn transition: Transition) {
        transition.addBeginning {
            self.fillColor = color
        }
        delegate?.symbolWillChangeFillColor(self, withIn: transition)
    }
    
    func setStrokeColor(_ color: UIColor, withIn transition: Transition) {
        updateStrokeColor(color, withIn: transition)
    }
    
    func setStrokeColor(_ color: UIColor, with transition: Transition = .instant()) {
        setStrokeColor(color, withIn: transition)
        transition.perform()
    }
    
    func focus(withIn transition: Transition) {
        updateStrokeColor(FlowChartSymbol.focusedStrokeColor, withIn: transition)
    }
    
    func focus(with transition: Transition = .instant()) {
        focus(withIn: transition)
        transition.perform()
    }
    
    func unfocus(withIn transition: Transition) {
        updateStrokeColor(FlowChartSymbol.normalStrokeColor, withIn: transition)
    }
    
    func unfocus(with transition: Transition = .instant()) {
        unfocus(withIn: transition)
        transition.perform()
    }
    
    private func updateStrokeColor(_ color: UIColor, withIn transition: Transition) {
        transition.addBeginning {
            self.strokeColor = color
        }
        delegate?.symbolWillChangeStrokeColor(self, withIn: transition)
    }
}
