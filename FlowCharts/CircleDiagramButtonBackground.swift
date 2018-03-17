//
//  FlowChartCircleButtonBackground.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class CircleDiagramButtonBackground: DiagramButtonBackground {
    
    let color: UIColor
    
    init(color: UIColor) {
        self.color = color
    }
    
    override func draw(in context: CGContext, with bounds: CGRect, isHighlighted: Bool) {
        
        context.saveGState()
        
        context.addEllipse(in: CGRect(center: bounds.center, size: CGSize(width: 27, height: 27)))
        context.setFillColor(color.withAlphaComponent(0.92).cgColor)
        context.fillPath()
        
        if isHighlighted {
            context.addEllipse(in: CGRect(center: bounds.center, size: CGSize(width: 27, height: 27)))
            context.setFillColor(UIColor(white: 0.0, alpha: 0.15).cgColor)
            context.fillPath()
        }
        
        context.restoreGState()
    }
}
