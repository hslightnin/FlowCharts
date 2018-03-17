//
//  BuildSymbolInteractor.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 05/11/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class BuildSymbolInteractor: Interactor, BuildSymbolInteractorProtocol {
    
    let diagram: FlowChartDiagram
    let location: Point
    private(set) var addedSymbol: FlowChartSymbol?
    
    init(diagram: FlowChartDiagram, location: Point) {
        self.diagram = diagram
        self.location = location
        super.init(managedObjectContext: diagram.flowChartManagedObjectContext)
    }
    
    var symbolCenter: Point {
        return location
    }
    
    var symbolFrame: Rect {
        return Rect(center: location, size: ShapePreset.placeholder.defaultSize)
    }
    
    func createPlaceholder() {
        let shapePreset = ShapePreset.placeholder
        let color = SymbolColorPresets.snow
        addedSymbol = BuildSymbolHelper.buildSymbol(
            in: diagram,
            frame: symbolFrame,
            shapePreset: shapePreset,
            color: color)
    }
    
    func setShapePreset(_ preset: ShapePreset) {
        
        addedSymbol!.shapePreset = preset
        
        let size = preset.defaultSize
        let center = symbolCenter
        addedSymbol!.x = center.x - size.width / 2
        addedSymbol!.y = center.y - size.height / 2
        addedSymbol!.width = size.width
        addedSymbol!.height = size.height
        
        LayoutSymbolAnchorsHelper.layoutAnchors(for: addedSymbol!)
    }
    
    func setColor(_ color: UIColor) {
        addedSymbol!.color = color
    }
}
