//
//  LayoutSymbolAnchorsHelper.swift
//  FlowCharts
//
//  Created by alex on 12/09/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import Foundation

class LayoutSymbolAnchorsHelper {
    
    private let symbol: FlowChartSymbol
    
    init(symbol: FlowChartSymbol) {
        self.symbol = symbol
    }
    
    static func layoutAnchors(for symbol: FlowChartSymbol) {
        let interactor = LayoutSymbolAnchorsHelper(symbol: symbol)
        interactor.layoutAnchors()
    }
    
    func layoutAnchors() {
        
        let rect = symbol.frame
        
        let topAnchor = symbol.anchor(withDirection: .up)
        topAnchor.location = symbol.shapePreset.shapeType.topPoint(within: rect)
        layoutLinkAnchor(forSymbolAnchor: topAnchor)
        
        let bottomAnchor = symbol.anchor(withDirection: .down)
        bottomAnchor.location = symbol.shapePreset.shapeType.bottomPoint(within: rect)
        layoutLinkAnchor(forSymbolAnchor: bottomAnchor)
        
        let rightAnchor = symbol.anchor(withDirection: .right)
        rightAnchor.location = symbol.shapePreset.shapeType.rightPoint(within: rect)
        layoutLinkAnchor(forSymbolAnchor: rightAnchor)
        
        let leftAnchor = symbol.anchor(withDirection: .left)
        leftAnchor.location = symbol.shapePreset.shapeType.leftPoint(within: rect)
        layoutLinkAnchor(forSymbolAnchor: leftAnchor)
    }
    
    private func layoutLinkAnchor(forSymbolAnchor anchor: FlowChartSymbolAnchor) {
        for linkAnchor in anchor.linkAnchors {
            linkAnchor.location = anchor.location
            linkAnchor.direction = anchor.direction.opposite
        }
    }
}
