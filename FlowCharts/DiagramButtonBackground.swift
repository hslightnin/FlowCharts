//
//  FlowChartButtonBackground.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class DiagramButtonBackground {
    
    func draw(in context: CGContext, with bounds: CGRect, isHighlighted: Bool) {
        fatalError("Must be implemented in subclasses")
    }
    
    static let red = CircleDiagramButtonBackground(color: .systemRed)
    static let blue = CircleDiagramButtonBackground(color: .systemBlue)
    static let green = CircleDiagramButtonBackground(color: .systemGreen)
}
