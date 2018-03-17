//
//  SymbolUseCaseButtonsLayoutManager.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 04/02/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry
import DiagramView

class SymbolUseCaseGroupLayoutManager: SymbolButtonsLayoutManagerProtocol {
    
    private let symbol: FlowChartSymbol
    private let diagramViewController: DiagramViewController
    
    init(symbol: FlowChartSymbol, diagramViewController: DiagramViewController) {
        self.symbol = symbol
        self.diagramViewController = diagramViewController
    }
    
    func deleteButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.minX, y: rect.minY)
    }
    
    func editTextButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.maxX, y: rect.minY)
    }
    
    func editPropertiesButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.minX, y: rect.maxY)
    }
    
    func resizeButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.maxX, y: rect.maxY)
    }
    
    func buildLinkButtonLocation(for direction: Direction, in view: UIView) -> CGPoint {
        switch direction {
        case .up:
            return buildTopLinkButtonLocation(in: view)
        case .down:
            return buildBottomLinkButtonLocation(in: view)
        case .right:
            return buildRightLinkButtonLocation(in: view)
        case .left:
            return buildLeftLinkButtonLocation(in: view)
        }
    }
    
    func buildTopLinkButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.midX, y: rect.minY)
    }
    
    func buildBottomLinkButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.midX, y: rect.maxY)
    }
    
    func buildRightLinkButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.maxX, y: rect.midY)
    }
    
    func buildLeftLinkButtonLocation(in view: UIView) -> CGPoint {
        let rect = buttonsRect(in: view)
        return CGPoint(x: rect.minX, y: rect.midY)
    }
    
    private func buttonsRect(in view: UIView) -> CGRect {
        
        let symbolFrameInDiagram = symbol.frame
        let symbolFrameInView = diagramViewController.viewRect(for: symbolFrameInDiagram, in: view)
        let minSide = min(symbolFrameInView.width, symbolFrameInView.height)
        
        if minSide < 64 {
            let multiplier = 64 / minSide
            let newWidth = symbolFrameInView.width * multiplier
            let newHeight = symbolFrameInView.height * multiplier
            let newX = symbolFrameInView.center.x - newWidth / 2
            let newY = symbolFrameInView.center.y - newHeight / 2
            return CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        }
        
        return symbolFrameInView
    }
}
