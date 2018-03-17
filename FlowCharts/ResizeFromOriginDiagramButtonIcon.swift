//
//  FlowChartResizeFromOriginArrowButton.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 06/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class ResizeFromOriginDiagramButtonIcon: DiagramButtonIcon {
    
    override func draw(in context: CGContext, with bounds: CGRect) {
        
        context.saveGState()
        
        context.addEllipse(in: CGRect(x: bounds.midX - 1.5, y: bounds.midX - 1.5, width: 2, height: 2))
        context.addEllipse(in: CGRect(x: bounds.midX - 5.5, y: bounds.midX - 5.5, width: 2, height: 2))
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
        
        context.move(to: CGPoint(x: bounds.midX + 4.5, y: bounds.midY - 2.5))
        context.addLine(to: CGPoint(x: bounds.midX + 4.5, y: bounds.midY + 4.5))
        context.addLine(to: CGPoint(x: bounds.midX - 2.5, y: bounds.midY + 4.5))
        context.setStrokeColor(UIColor.white.cgColor)
        context.strokePath()
        
        context.restoreGState()
    }
}
