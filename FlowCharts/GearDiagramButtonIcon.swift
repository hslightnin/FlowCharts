//
//  FlowChartGearButtonIcon.swift
//  FlowCharts
//
//  Created by Alexander Kozlov on 03/01/2018.
//  Copyright © 2018 Brown Coats. All rights reserved.
//

import UIKit

class GearDiagramButtonIcon: DiagramButtonIcon {
    
    override func draw(in context: CGContext, with bounds: CGRect) {
        UIImage(named: "gear")!.draw(in: CGRect(center: bounds.center, size: CGSize(width: 18, height: 18)))
    }
}
