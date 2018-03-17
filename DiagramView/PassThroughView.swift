//
//  PasstthroughView.swift
//  FlowCharts
//
//  Created by alex on 22/10/2017.
//  Copyright © 2017 Brown Coats. All rights reserved.
//

import UIKit

class PassThroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView === self ? nil : hitView
    }
}
