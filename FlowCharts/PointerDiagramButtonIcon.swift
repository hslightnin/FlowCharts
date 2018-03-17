//
//  FlowChartPointerButtonIcon.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit
import DiagramGeometry

class PointerDiagramButtonIcon: DiagramButtonIcon {
    
    let pointerPreset: PointerPreset
    let pointerVector: Vector
    
    init(pointerPreset: PointerPreset, vector: Vector) {
        self.pointerPreset = pointerPreset
        self.pointerVector = vector
    }
    
    override func draw(in context: CGContext, with bounds: CGRect) {
        
        if pointerPreset === PointerPreset.empty {
            
            context.saveGState()
            context.addEllipse(in: CGRect(center: bounds.center, size: CGSize(width: 2, height: 2)))
            context.setFillColor(UIColor.white.cgColor)
            context.fillPath()
            context.restoreGState()
            
        } else {
            
            let arrowCenter = Point(bounds.center)
            
            let arrow = Arrow()
            
            arrow.lineType = StraightLineType()

            arrow.point1 = arrowCenter.translated(by: -pointerPreset.buttonArrowLength / 2 * pointerVector.unit)
            arrow.direction1 = .left
            arrow.pointer1Type = EmptyPointerType()
            
            arrow.point2 = arrowCenter.translated(by: +pointerPreset.buttonArrowLength / 2 * pointerVector.unit)
            arrow.direction2 = .right
            arrow.pointer2Type = pointerPreset.pointerType
            arrow.pointer2Size = pointerPreset.buttonPointerSize
            
            let iconPath = pointerPreset.pointerType is EllipsisPointerType ? arrow.pointer2Path : arrow.path
            let cgIconPath = CGPath(iconPath)
            
            context.saveGState()
            context.addPath(cgIconPath)
            context.setStrokeColor(UIColor.white.cgColor)
            context.strokePath()
            
            if pointerPreset.pointerFillPattern == .fillWithStrokeColor {
                context.addPath(cgIconPath)
                context.setFillColor(UIColor.white.cgColor)
                context.fillPath()
            }
            
            context.restoreGState()
        }
    }
}
