//
//  FlowChartButtonIcon.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class DiagramButtonIcon {
    
    func draw(in context: CGContext, with bounds: CGRect) {
        fatalError("Must be implemented in subclasses")
    }
    
    static let plus = PlusDiagramButtonIcon()
    static let cross = CrossDiagramButtonIcon()
    static let pen = PenDiagramButtonIcon()
    static let resizeFromCenter = ResizeFromCenterDigramButtonIcon()
    static let resizeFromOrigin = ResizeFromOriginDiagramButtonIcon()
    static let gear = GearDiagramButtonIcon()
    
    static func pointer(preset: PointerPreset, vector: Vector) -> DiagramButtonIcon {
        return PointerDiagramButtonIcon(pointerPreset: preset, vector: vector)
    }
    
    static func direction(direction: Direction) -> DiagramButtonIcon {
        switch direction {
        case .up:
            return UpArrowDiagramButtonIcon()
        case .down:
            return DownArrowDiagramButtonIcon()
        case .right:
            return RightArrowDiagramButtonIcon()
        case .left:
            return LeftArrowDiagramButtonIcon()
        }
    }
}
