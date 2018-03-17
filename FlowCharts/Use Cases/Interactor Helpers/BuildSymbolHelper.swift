//
//  AddSymbolInteractor.swift
//  FlowCharts
//
//  Created by alex on 11/06/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import CoreData
import DiagramGeometry

class BuildSymbolHelper {
    
    @discardableResult
    static func buildSymbol(
        in diagram: FlowChartDiagram,
        center: Point,
        shapePreset: ShapePreset,
        color: UIColor) -> FlowChartSymbol {
        
        let frame = Rect(center: center, size: shapePreset.defaultSize)
        return buildSymbol(
            in: diagram,
            frame: frame,
            shapePreset: shapePreset,
            color: color)
    }
    
    @discardableResult
    static func buildSymbol(
        in diagram: FlowChartDiagram,
        frame: Rect,
        shapePreset: ShapePreset,
        color: UIColor) -> FlowChartSymbol {
        
        let symbol = createSymbol(
            in: diagram,
            frame: frame,
            shapePreset: shapePreset,
            color: color)
        
        createAnchor(for: symbol, direction: .up)
        createAnchor(for: symbol, direction: .down)
        createAnchor(for: symbol, direction: .right)
        createAnchor(for: symbol, direction: .left)
        LayoutSymbolAnchorsHelper.layoutAnchors(for: symbol)
        symbol.diagram = diagram
        return symbol
    }
    
    @discardableResult
    static private func createSymbol(
        in diagram: FlowChartDiagram,
        frame: Rect,
        shapePreset: ShapePreset,
        color: UIColor) -> FlowChartSymbol {
        
        guard let managedObjectContext = diagram.managedObjectContext else {
            fatalError("Can't create symbol in diagram without managed object context.")
        }
        
        let symbol = NSEntityDescription.insertNewObject(
            forEntityName: "Symbol",
            into: managedObjectContext) as! FlowChartSymbol
        symbol.x = frame.origin.x
        symbol.y = frame.origin.y
        symbol.width = frame.size.width
        symbol.height = frame.size.height
        symbol.shapePreset = shapePreset
        symbol.color = color
        
        return symbol
    }
    
    @discardableResult
    static private func createAnchor(
        for symbol: FlowChartSymbol,
        direction: Direction) -> FlowChartSymbolAnchor {
        
        let anchor = NSEntityDescription.insertNewObject(
            forEntityName: "SymbolAnchor",
            into: symbol.managedObjectContext!) as! FlowChartSymbolAnchor
        anchor.direction = direction
        anchor.symbol = symbol
        return anchor
    }
}
