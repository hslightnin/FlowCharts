//
//  FlowChartRightArrowButtonIcon.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 06/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class RightArrowDiagramButtonIcon: DiagramButtonIcon {
    
    override func draw(in context: CGContext, with bounds: CGRect) {
        
        context.saveGState()
        
        context.move(to: CGPoint(x: bounds.midX - 7, y: bounds.midY + 0.5))
        context.addLine(to: CGPoint(x: bounds.midX + 5, y: bounds.midY + 0.5))
        
        context.move(to: CGPoint(x: bounds.midX, y: bounds.midY + 5.5))
        context.addLine(to: CGPoint(x: bounds.midX + 5, y: bounds.midY + 0.5))
        context.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY - 4.5))
        
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
        
        context.restoreGState()
    }
}
